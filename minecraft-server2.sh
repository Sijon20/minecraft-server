#!/bin/bash

PURPUR_JAR="purpur.jar"
SERVER_OPTS=""
SCREEN_NAME="purpur-mc"
JAVA_EXECUTABLE="java" # Make sure to set this to your Java path

# Function to check if screen is installed
function check_screen {
    if ! command -v screen &> /dev/null
    then
        echo "Screen could not be found. Please install it and run the script again."
        exit
    fi
}

# Function to check if Java is installed
function check_java {
    if ! command -v $JAVA_EXECUTABLE &> /dev/null
    then
        echo "Java could not be found. Please install it and run the script again."
        exit
    fi
}

# Function to check if Purpur jar exists
function check_purpur {
    if [ ! -f $PURPUR_JAR ]; 
    then
        echo "Enter Purpur version to download (e.g. 1.17.1):"
        read purpur_version
        echo "Enter Purpur build to download (e.g. 100):"
        read purpur_build
        #if wget throws an error, exit the script
        wget https://api.pl3x.net/v2/purpur/$purpur_version/$purpur_build/download -O $PURPUR_JAR || echo "Purpur jar file could not be found. Please make sure it's in the same directory as this script."
        exit
    fi
}

check_screen
check_java
check_purpur

case "$1" in
  start)
    screen -q -S $SCREEN_NAME -dm $JAVA_EXECUTABLE -Xmx2G -jar $PURPUR_JAR $SERVER_OPTS nogui
    ;;
  stop)
    if pgrep -f $SCREEN_NAME > /dev/null
    then
        pkill -f $SCREEN_NAME
    else
        echo "Server is not currently running."
    fi
    ;;
  restart)
    $0 stop
    sleep 2
    $0 start
    ;;
  status)
    if pgrep -f $SCREEN_NAME > /dev/null
    then
        echo "Server is running."
    else
        echo "Server is not currently running."
    fi
    ;;
  console)
    screen -r $SCREEN_NAME
    ;;
  *)
    echo "Usage: $0 {start|stop|restart|status|console}"
    exit 1
    ;;
esac
