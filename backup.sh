#!/bin/bash

source `pwd`/config #configuration file

RED=$'\e[1;31m'
YELLOW=$'\e[1;33m'
GREEN=$'\e[1;32m'
NORMAL=$'\e[0m'

suffix="$GENERAL_DIR"/
DIFF_SAME_DATE="4046" #coefficient to calculate diff between dates
current_day=$(date +%d-%m-%Y)
daily_dir="$GENERAL_DIR/$current_day"
deleted=false


overwriteDir() {
    if [ $AUTO_OVERWRITE = false ];
    then
        printf "${RED}Do you want to overwrite it? [Y/n]:${NORMAL}"
        read decision
        if [ $decision = "y" -o $decision = "Y" ]; then
            printf "Overwriting backup dir\n"
            rm -rf $1
            mkdir $1
        fi
    else
        printf "${RED}Auto overwriting daily backup:\n${NORMAL}"
        printf "\t$1\n"
        rm -fr $1
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
    printf "${RED}Deleting old backups:\n${NORMAL}"
    for path_to_backup_from_day in "$GENERAL_DIR"/*
    do
        backup_dir=${path_to_backup_from_day#"$suffix"}
        difference=$(( $current_day - $backup_dir + $DIFF_SAME_DATE ))
        if (( difference >= DAYS_TO_KEEP_BACKUP )); then
            rm -rf $path_to_backup_from_day
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
        COLOR=$RED
    else
        COLOR=$GREEN
    fi
    printf "${YELLOW}AUTO_OVERWRITE${NORMAL} turned ${COLOR}$AUTO_OVERWRITE\n${NORMAL}"
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
        printf "Changed ${YELLOW}AUTO_OVERWRITE${NORMAL} mode to ${GREEN}true\n${NORMAL}"
    else
        sed -i -e 's/AUTO_OVERWRITE=true/AUTO_OVERWRITE=false/g' config
        printf "Changed ${YELLOW}AUTO_OVERWRITE${NORMAL} mode to ${RED}false\n${NORMAL}"
    fi
}

changeTimeLive(){
        sed -i -e 's/days2=9/10/g' config
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

printHelp(){
    printf "help\n"
}

echo "$2"

if [[ $1 = "-ls" ]];
then
    printBackups
elif [[ $1 = "-rm" ]];
then
    deleteBackups
elif [[ $1 = "-cm" ]];
then
    changeOverwriteMode
elif [[ $1 = "-print" ]];
then
    printCurrentConfig
elif [[ $1 = "-time" ]]
then
    changeTimeLive
elif [[ $1 = "-h" || $1 = "--help" ]];
then
    printHelp
elif [[ $1 = "" ]];
then
    defaultBackup
else
    printf "${YELLOW}Unknow option $1 \n${NORMAL}"
fi
