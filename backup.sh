#!/bin/bash

INSTALL_DIR=
source $INSTALL_DIR/config
source $INSTALL_DIR/helpFile.sh
source $INSTALL_DIR/colors.sh

suffix="$GENERAL_DIR"/
DIFF_SAME_DATE="4046" #coefficient to calculate diff between dates
current_day=$(date +%d-%m-%Y)
daily_dir="$GENERAL_DIR/$current_day"
deleted=false

overwrite(){
    printf "\t$1\n"
    sudo rm -rf $1
    mkdir $1
}

overwriteDir() {
    if [ $AUTO_OVERWRITE = false ];
    then
        printf "${PURPLE}Do you want to overwrite it? [Y/n]:${NORMAL}"
        read decision
        if [ $decision = "y" -o $decision = "Y" ]; then
            printf "Overwriting backup dir:\n"
            overwrite $1
        fi
    else
        printf "${PURPLE}Auto overwriting daily backup:\n${NORMAL}"
        overwrite $1
    fi
}

createBackup() {
    printf "${GREEN}Backuping dirs:\n${NORMAL}"
    for dir in "${DIRS_TO_BACKUP[@]}";
    do
        printf "\t$dir\n"
        sudo cp -R $dir "$daily_dir"/
    done
}

createBackupDir() {
    if mkdir "$GENERAL_DIR" > /dev/null; then
        printf "Creating backup dir\n"
    else
        printf "${YELLOW}Ommiting creating backup dir(exist)\n${NORMAL}"
    fi
}

dailyBackup() {
    if mkdir $daily_dir > /dev/null; then
        printf "Creating today backup\n"
        createBackup
    else
        printf "${YELLOW}Daily backup already made, ${NORMAL}"
        overwriteDir $daily_dir
        createBackup
    fi
}

deleteOldBackup() {
    printf "${PURPLE}Deleting old backups:\n${NORMAL}"
    for path_to_backup_from_day in "$GENERAL_DIR"/*
    do
        backup_dir=${path_to_backup_from_day#"$suffix"}
        difference=$(( $current_day - $backup_dir + $DIFF_SAME_DATE ))
        if (( difference >= DAYS_TO_KEEP_BACKUP )); then
            sudo rm -rf $path_to_backup_from_day
            printf "\t$backup_dir\n${NORMAL}"
            deleted=true
        fi
    done
    if [ $deleted = false ];
    then
        printf "\tNothing to delete\n"
    fi
    deleted=false
}

printAutoOverwrite(){
    if [ $AUTO_OVERWRITE = false ];
    then
        COLOR=$PURPLE
    else
        COLOR=$GREEN
    fi
    printf "${YELLOW}AUTO_OVERWRITE${NORMAL} turned ${COLOR}$AUTO_OVERWRITE\n${NORMAL}"
}

printBackups(){
    if [[ $1 = "" ]];
    then
        ls -l $GENERAL_DIR
    else
        ls -l $GENERAL_DIR/$1
    fi
}

deleteBackups(){
    rm -rf "$GENERAL_DIR"/*
}

changeOverwriteMode(){
    if [ $AUTO_OVERWRITE = false ];
    then
        sed -i -e 's/AUTO_OVERWRITE=false/AUTO_OVERWRITE=true/g' $INSTALL_DIR/config
        printf "Changed ${YELLOW}AUTO_OVERWRITE${NORMAL} mode to ${GREEN}true\n${NORMAL}"
    else
        sed -i -e 's/AUTO_OVERWRITE=true/AUTO_OVERWRITE=false/g' $INSTALL_DIR/config
        printf "Changed ${YELLOW}AUTO_OVERWRITE${NORMAL} mode to ${PURPLE}false\n${NORMAL}"
    fi
}

getAbsoluteNum(){
    var=$1
    while [[ $var == *"-"* ]];
    do
        var=${var#-}
    done
    echo "$var"
}

changeLiveTime(){
    days_to_change=$( getAbsoluteNum $1 )
    sed -i "s/^\(DAYS_TO_KEEP_BACKUP=\).*/\1$days_to_change/" $INSTALL_DIR/config
    printf "Changed ${PURPLE}\"LiveTime\"${NORMAL} to ${GREEN}$days_to_change days\n${NORMAL}".
}

printCurrentConfig(){
    cat $INSTALL_DIR/config
}

defaultBackup(){
    printAutoOverwrite
    createBackupDir
    dailyBackup
    deleteOldBackup
    sudo chmod -R 777 $GENERAL_DIR
}

