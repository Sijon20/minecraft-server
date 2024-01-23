#!/bin/bash

PURPUR_JAR="purpur.jar"
SERVER_OPTS=""
SCREEN_NAME="script"
JAVA_EXECUTABLE="java" # Make sure to set this to your Java path

mkdir server
cd server

# Function to check if screen is installed
function check_screen {
    if ! command -v screen &> /dev/null
    then
        #echo in red
        tput setaf 1
        echo "ERORR : Screen could not be found. Please install it and run the script again."
        exit
    fi
}

# Function to check if Java is installed
function check_java {
    if ! command -v $JAVA_EXECUTABLE &> /dev/null
    then
        tput setaf 1
        echo "ERORR : Java could not be found. Please install it and run the script again."
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
        wget https://api.purpurmc.org/v2/purpur/$purpur_version/$purpur_build/download -O $PURPUR_JAR || echo "ERORR : Purpur jar file could not be found. Please make sure it's in the same directory as this script."
        exit
    fi
}

check_screen
check_java
check_purpur
echo "More info Check README.md"
#create README.md
cat > README.md <<EOF
# Purpur Minecraft Server
script(script file that you installed) is a script to manage your Purpur Minecraft server using screen.
## How to use
### Start
./script.sh start
### Stop
./script.sh stop
### Restart
./script.sh restart
### Status
./script.sh status
### Console
./script.sh console
## closed console 
ctrl + a + d
EOF

#create eula.txt
cat > eula.txt <<EOF
#By changing the setting below to TRUE you are indicating your agreement to our EULA (https://account.mojang.com/documents/minecraft_eula).
#Sun Oct 17 18:37:28 UTC 2021
eula=true
EOF

#create sh file
cat > purpur-mc.sh <<EOF

case "\$1" in
  start)
    screen -q -S \$SCREEN_NAME -dm \$JAVA_EXECUTABLE -Xmx2G -jar \$PURPUR_JAR \$SERVER_OPTS nogui
    echo "Server started."
    ;;
  stop)
    if pgrep -f \$SCREEN_NAME > /dev/null
    then
        pkill -f \$SCREEN_NAME
    else
        echo "Server is not currently running."
    fi
    ;;
  restart)
    \$0 stop
    sleep 2
    \$0 start
    ;;
  status)
    if pgrep -f \$SCREEN_NAME > /dev/null
    then
        echo "Server is running."
    else
        echo "Server is not currently running."
    fi
    ;;
  console)
    screen -r \$SCREEN_NAME
    ;;
  *)
    echo "Usage: \$0 {start|stop|restart|status|console}"
    exit 1
    ;;
esac
EOF
chmod +x purpur-mc.sh
