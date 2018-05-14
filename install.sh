#!/bin/bash

DIRS=("menu.sh" "backup.sh" "helpFile.sh" "backupListMg.sh")

setInstalationPath(){
    for dir in ${DIRS[@]};
    do
        sed -i "s:^\(INSTALL_DIR=\).*:\1`pwd`:" $dir
    done
}

setInstalationPath
printf "Creating new alias BackMeUp\n"
echo "alias BackMeUp='`pwd`/menu.sh'" >> /home/$USER/.bashrc
exec bash

