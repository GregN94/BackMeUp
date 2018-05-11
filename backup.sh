#!/bin/bash

source `pwd`/config #configuration file
source `pwd`/helpFile.sh
source `pwd`/colors.sh

suffix="$GENERAL_DIR"/
DIFF_SAME_DATE="4046" #coefficient to calculate diff between dates
current_day=$(date +%d-%m-%Y)
daily_dir="$GENERAL_DIR/$current_day"
deleted=false

overwriteDir() {
    if [ $AUTO_OVERWRITE = false ];
    then
        printf "${LIGHT_RED}Do you want to overwrite it? [Y/n]:${NORMAL}"
        read decision
        if [ $decision = "y" -o $decision = "Y" ]; then
            printf "Overwriting backup dir\n"
            rm -rf $1
            mkdir $1
        fi
    else
        printf "${LIGHT_RED}Auto overwriting daily backup:\n${NORMAL}"
        printf "\t$1\n"
        sudo rm -fr $1
        mkdir $1
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
        printf "${LIGHT_YELLOW}Ommiting creating backup dir(exist)\n${NORMAL}"
    fi
}

dailyBackup() {
    if mkdir $daily_dir > /dev/null; then
        printf "Creating today backup\n"
        createBackup
    else
        printf "${LIGHT_YELLOW}Daily backup already made, ${NORMAL}"
        overwriteDir $daily_dir
        createBackup
    fi
}

deleteOldBackup() {
    printf "${LIGHT_RED}Deleting old backups:\n${NORMAL}"
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
        COLOR=$LIGHT_RED
    else
        COLOR=$GREEN
    fi
    printf "${LIGHT_YELLOW}AUTO_OVERWRITE${NORMAL} turned ${COLOR}$AUTO_OVERWRITE\n${NORMAL}"
}

printBackups(){
    ls -l $GENERAL_DIR
}

deleteBackups(){
    rm -rf "$GENERAL_DIR"/*
}

changeOverwriteMode(){
    if [ $AUTO_OVERWRITE = false ];
    then
        sed -i -e 's/AUTO_OVERWRITE=false/AUTO_OVERWRITE=true/g' config
        printf "Changed ${LIGHT_YELLOW}AUTO_OVERWRITE${NORMAL} mode to ${GREEN}true\n${NORMAL}"
    else
        sed -i -e 's/AUTO_OVERWRITE=true/AUTO_OVERWRITE=false/g' config
        printf "Changed ${LIGHT_YELLOW}AUTO_OVERWRITE${NORMAL} mode to ${LIGHT_RED}false\n${NORMAL}"
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
    sed -i "s/^\(DAYS_TO_KEEP_BACKUP=\).*/\1$days_to_change/" config
    printf "Changed ${PURPLE}\"LiveTime\"${NORMAL} to ${GREEN}$days_to_change days\n${NORMAL}".
}

printCurrentConfig(){
    cat `pwd`/config
}

defaultBackup(){
    printAutoOverwrite
    createBackupDir
    dailyBackup
    deleteOldBackup
    sudo chmod -R 777 $GENERAL_DIR
}


if [[ $1 = "-ls" || $1 = "-list" || $1 = "--list" ]];
then
    printBackups
elif [[ $1 = "-rm" || $1 = "-remove" || $1 = "--remove" ]];
then
    deleteBackups
elif [[ $1 = "-a" || $1 = "--auto" || $1 = "-auto" ]];
then
    changeOverwriteMode
elif [[ $1 = "-p" || $1 = "-print" || $1 = "--print" ]];
then
    printCurrentConfig
elif [[ $1 = "-t" || $1 = "-time"  || $1 = "--time" ]];
then
    changeLiveTime $2
elif [[ $1 = "-h" || $1 = "--help" || $1 = "-help" ]];
then
    printHelp
elif [[ $1 = "" ]];
then
    defaultBackup
else
    printf "${LIGHT_YELLOW}Unknow option $1 \n${NORMAL}"
fi
