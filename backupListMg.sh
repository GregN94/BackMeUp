#!/bin/bash

INSTALL_DIR=
DIRS_TO_BACKUP=$INSTALL_DIR/listOfBackups
source $INSTALL_DIR/colors.sh

addExistingFile(){
    if ls $1 >/dev/null;
    then
        printf "\t${GREEN}Added $1 to list.${NORMAL}\n"
        echo "$1" >> $DIRS_TO_BACKUP
    else
        printf "${PURPLE}Omitting $1. File/Dir $1 doesn't exist(or incorrect path).${NORMAL}\n"
    fi
}

addBackupsFromList(){
    for added_dir in ${@:1};
    do
        addExistingFile $added_dir
    done
}

removeDuplicates(){
    sort -u $DIRS_TO_BACKUP > temp_file
    mv temp_file  $DIRS_TO_BACKUP
}

addToBackupList(){
    if [[ $1 = "" ]];
    then
        printf "${YELLOW}Empty argument list. Add new List:${NORMAL}\n"
        read new_list
        addNewBackup $new_list
    else
        addBackupsFromList ${@:1}
    fi
    removeDuplicates
}

deleteFromBackupList(){
    printf "${PURPLE}Deleted from list:${NORMAL}\n"
    for to_delete in ${@:1};
    do
        printf "\t$to_delete\n"
        grep -vx $to_delete $DIRS_TO_BACKUP > temp
        mv temp $DIRS_TO_BACKUP
    done
}
