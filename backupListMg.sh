#!/bin/bash

INSTALL_DIR=
DIRS_TO_BACKUP=$INSTALL_DIR/listOfBackups

addExistingFile(){
    if ls $1 >/dev/null;
    then
        printf "Added $1 to list.\n"
        echo "$1" >> $DIRS_TO_BACKUP
    else
        printf "Omitting $1. File/Dir $1 doesn't exist(or incorrect path).\n"
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
    cat temp_file > $DIRS_TO_BACKUP
    rm temp_file
}

addNewBackup(){
    if [[ $1 = "" ]];
    then
        printf "Empty argument list. Add new List:\n"
        read new_list
        addNewBackup $new_list
    else
        addBackupsFromList ${@:1}
        removeDuplicates
    fi
}
