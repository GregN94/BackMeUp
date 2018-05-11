#!/bin/bash

source `pwd`/colors.sh

printHelp(){
    printf "${GREEN}BackMeUp${YELLOW} - simple shell script to create and manage your backups.

${BLUE}Script run without any options should create general directory where will be stored all backups, if it doesn't exist.
Then it will try to create new \"daily\" backup, whith the name as current date(format dd-mm-YYYY). If such file already
exist programm will overwrite this backup(if AUTO_OVERWRITE is set to true) or ask User if she/he wants to overwrite it.
At the end programm will delete all \"old backups\".

${PURPLE}Script can be also run with many options:
         Syntax                  Arguments         Description ${NORMAL}

  -h,  -help   or --help   |                  |  Displays help.
  -a,  -auto   or --auto   |                  |  Turn OFF/ON AUTO_OVERWRITE backups.
  -p,  -print  or --print  |                  |  Prints current configuration.
  -rm, -remove or --remove |                  |  Deletes backups.
  -ls, -list   or --list   |                  |  Lists all backups.
  -t,  -time   or --time,  | -[time in days]  |  Changes \"LiveTime\" of backups.${NORMAL}
\n"

}

