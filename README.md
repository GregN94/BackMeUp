# BackMeUp
Simple command line programm written in bash to create and manage backups on your local drive.

Installation:

Clone this repository on your computer, go to cloned directory, and run ./install.sh:

    git clone https://github.com/GregN94/BackMeUp.git
    cd BackMeUp/
    ./install

To run this script try:

    BackMeUp [option]

    e.g, to see help:

    BackMeUp -h


Features included in programm:

-All backups are stored in one major directory defined by User in config file.

-Folders to be backuped are defined by User in config file.

-Backups are named by date in which they are created(unique name).

-All old backups are automatically deleted("live time" is defined in config file).

-Overwriting existing backup(both automatically and manually).

-Option to change overwriting mode.

-Listing all backups.

-Option to remove all backups.

-Option to changing "live time" of backups.

-Option to view help.

-Listing content of backups.

-Install file

-Option to remove selectedd list of backups.

-Option of adding/removing new folders to be backuped.

