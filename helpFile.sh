#!/bin/bash

INSTALL_DIR=
source $INSTALL_DIR/colors.sh

printHelp(){
    printf "${GREEN}BackMeUp${YELLOW} - simple shell script to create and manage your backups.

${BLUE}Script run without any options should create general directory where will be stored all backups, if it doesn't exist.
Then it will try to create new \"daily\" backup, whith the name as current date(format dd-mm-YYYY). If such file already
exist program will overwrite this backup(if AUTO_OVERWRITE is set to true) or ask User if she/he wants to overwrite it.
At the end program will delete all \"old backups\".

${PURPLE}Script can be also run with options:
         Syntax                  Arguments       Description ${NORMAL}

  -h,  -help   or --help   |                 |  Displays help.
  -m,  -mode   or --mode   |                 |  Turn OFF/ON AUTO_OVERWRITE backup MODE.
  -p,  -print  or --print  |                 |  Prints current configuration.
  -rm, -remove or --remove | [backup dirs]   |  Deletes all backups. Adding arguments define list of backups to delete.
  -ls, -list   or --list   | [backup dir]    |  Lists all backups. Adding argument list contnt od selected backup.
  -a,  -add    or --add    | [backup dirs]   |  Add dirs to backup list.
  -d,  -delete or --delete | [backup dirs]   |  Delete dirs from backup list.
  -t,  -time   or --time,  | [time in days]  |  Changes \"LiveTime\" of backups.${NORMAL}
\n"

}

