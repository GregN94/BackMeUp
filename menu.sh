#!/bin/bash

INSTALL_DIR=
source $INSTALL_DIR/backup.sh
source $INSTALL_DIR/colors.sh
source $INSTALL_DIR/backupListMg.sh


if [[ $1 = "-ls" || $1 = "-list" || $1 = "--list" ]];
then
    printBackups $2
elif [[ $1 = "-rm" || $1 = "-remove" || $1 = "--remove" ]];
then
    deleteBackups ${@:2}
elif [[ $1 = "-m" || $1 = "--mode" || $1 = "-mode" ]];
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
elif [[ $1 = "-a" || $1 = "-add" || $1 = "--add" ]];
then
    addToBackupList ${@:2}
    printBackupList
elif [[ $1 = "-d" || $1 = "-delete" || $1 = "--delete" ]];
then
    deleteFromBackupList ${@:2}
    printBackupList
elif [[ $1 = "" ]];
then
    defaultBackup
else
    printf "${YELLOW}Unknow option $1.${NORMAL}Use command below to see possible option:\n./backup.sh -h\n"
fi
