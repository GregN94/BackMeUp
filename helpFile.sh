#!/bin/bash

printHelp(){
    printf "Script run without any options should create general directory where will be stored all backups, if it doesn't exist.
Then it will try to create new \"daily\" backup, whith the name as current date(format dd-mm-YYYY). If such file already
exist programm will overwrite this backup(if AUTO_OVERWRITE is set to true) or ask User if she/he wants to overwrite it.
At the end programm will delete all \"old backups\".\n"
}

