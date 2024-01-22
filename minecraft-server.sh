#!/bin/sh
#create a directory for the server
mkdir ./minecraft-purpur-server 
cd ./minecraft-purpur-server 
#download the latest purpur jar
wget https://api.purpurmc.org/v2/purpur/1.20.4/latest/download -O purpur.jar
#install screen
#check if screen is installed
if ! command -v screen &> /dev/null
then
    #install screen
    #check linux distro [redhat, debian,ubuntu, arch , alpine ]
    if [ -f /etc/redhat-release ]; then
        #redhat
        sudo dnf install screen
    elif [ -f /etc/debian_version ]; then
        #debian
        sudo apt install screen
    #check if ubuntu
    elif [ -f /etc/lsb-release ]; then
        #ubuntu
        sudo apt install screen
    elif [ -f /etc/arch-release ]; then
        #arch
        sudo pacman -S screen
    elif [ -f /etc/alpine-release ]; then
        #alpine
        sudo apk add screen
    else
        echo "Unsupported linux distro"
        exit 1
    fi
fi

#install java
#check if java is installed

if ! command -v java &> /dev/null
then
    #install java 17

    #check linux distro [redhat, debian,ubuntu, arch , alpine ]
    if [ -f /etc/redhat-release ]; then
        #redhat
        sudo dnf install java-17-openjdk
    elif [ -f /etc/debian_version ]; then
        #debian
        sudo apt install openjdk-17-jdk
    #check if ubuntu
    elif [ -f /etc/lsb-release ]; then
        #ubuntu
        sudo apt install openjdk-17-jdk
    elif [ -f /etc/arch-release ]; then
        #arch
        sudo pacman -S jdk-openjdk
    elif [ -f /etc/alpine-release ]; then
        #alpine
        sudo apk add openjdk17
    else
        echo "Unsupported linux distro"
        exit 1
    fi
fi




# creat purpur-mc.sh that will be constent  "script"
cat > purpur-mc.sh <<EOF
#!/bin/sh
### BEGIN INIT INFO
# Provides:          purpur
# Required-Start:    $remote_fs $syslog
# Required-Stop:     $remote_fs $syslog
# Default-Start:     2 3 4 5
# Default-Stop:      0 1 6
# Short-Description: Purpur Minecraft Server
# Description:       Start, stop, and restart the Purpur Minecraft server.
### END INIT INFO

JAVA_EXECUTABLE="/usr/bin/java"
PURPUR_JAR="purpur.jar"
SERVER_OPTS=""
SCREEN_NAME="purpur-mc"


case "\$1" in
  start)
    screen -S \$SCREEN_NAME -dm \$JAVA_EXECUTABLE -Xmx2G -jar \$PURPUR_JAR \$SERVER_OPTS nogui
    ;;
  stop)
    pid=\$(pgrep -f \$PURPUR_JAR)
    kill \$pid
    ;;
  restart)
    \$0 stop
    sleep 2
    \$0 start
    ;;
    status)
    pid=\$(pgrep -f \$PURPUR_JAR)
    if [ -z "\$pid" ]; then
      echo "Purpur is not running."
    else
      echo "Purpur is running with PID \$pid."
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

#make purpur-mc.sh executable
chmod +x purpur-mc.sh
#make directory plugins
mkdir plugins
# Write eula.txt
cat > eula.txt <<EOF
#By changing the setting below to TRUE you are indicating your agreement to our EULA (https://account.mojang.com/documents/minecraft_eula).
#Sun Oct 17 18:37:28 UTC 2021
eula=true
EOF

# create readme.md
cat > README.md <<EOF
# Minecraft Server Setup Script

This script automates the setup of a Minecraft server using the Purpur server software. It also allows you to choose which plugins to install.

## Usage

1. Make sure you have `screen` installed on your system. You can install it on an Ubuntu system with `sudo apt-get install screen`, or on an Alpine system with `apk add screen`.

2. Run the script with `./minecraft-server.sh`.

3. When prompted, enter the number corresponding to the set of plugins you want to install:

    1. GeyserMC, Floodgate
    2. GeyserMC, Floodgate, PlayIt.GG
    3. ViaVersion, ViaBackwards, ViaRewind, ViaVersionStatus
    4. ViaVersion, ViaBackwards, ViaRewind, ViaVersionStatus, GeyserMC, Floodgate
    5. ViaVersion, ViaBackwards, ViaRewind, ViaVersionStatus, GeyserMC, Floodgate, PlayIt.GG
    6. None

4. The script will download the Purpur server software, make it executable, and start the server in a `screen` session.

5. You can attach to the server console with `./purpur-mc.sh console`. To detach from the console and leave the server running, press `Ctrl+A` followed by `D`.

Please note that this script is intended for use on a Linux system with `screen` installed. It may not work correctly on other systems.


EOF

# Write eula.txt
cat > eula.txt <<EOF
#By changing the setting below to TRUE you are indicating your agreement to our EULA (https://account.mojang.com/documents/minecraft_eula).
#Sun Oct 17 18:37:28 UTC 2021
eula=true
EOF
#download latest plugins [viaVersion,viaBackwards,viaRewind,viaVersinStatus,geysermc,floodgate , Playit.gg ]
cd plugins
#input choice shoud stay in front of terminal

# take input from user for plugins to install 
echo "1. plugins to install [geysermc,floodgate]"
echo "2. plugins to install [geysermc,floodgate, Playit.gg]"
echo "3. plugins to install [viaVersion,viaBackwards,viaRewind,viaVersinStatus]"
echo "4. plugins to install [viaVersion,viaBackwards,viaRewind,viaVersinStatus,geysermc,floodgate]"
echo "5. plugins to install [viaVersion,viaBackwards,viaRewind,viaVersinStatus,geysermc,floodgate , Playit.gg]"
echo "6. None"

while true; do
    read -p "Enter your choice: " choice
    #install plugins
    #check choice and install plugins
    #check if choice is 1
    if [ $choice -eq 1 ]
    then
        #install geysermc
    wget https://download.geysermc.org/v2/projects/geyser/versions/latest/builds/latest/downloads/spigot -O Geyser.jar
    #install floodgate
    wget https://download.geysermc.org/v2/projects/floodgate/versions/latest/builds/latest/downloads/spigot -O Floodgate.jar
        break
    #check if choice is 2
    elif [ $choice -eq 2 ]
    then
        #install geysermc
    wget https://download.geysermc.org/v2/projects/geyser/versions/latest/builds/latest/downloads/spigot -O Geyser.jar
    #install floodgate
    wget https://download.geysermc.org/v2/projects/floodgate/versions/latest/builds/latest/downloads/spigot -O Floodgate.jar
    #install Playit.gg
    wget https://github.com/playit-cloud/playit-minecraft-plugin/releases/latest/download/playit-minecraft-plugin.jar -O PlayItGG.jar

        break
    #check if choice is 3
    elif [ $choice -eq 3 ]
    then
        #install viaVersion
    wget https://hangarcdn.papermc.io/plugins/ViaVersion/ViaVersion/versions/4.9.2/PAPER/ViaVersion-4.9.2.jar -O ViaVersion.jar
    #install viaBackwards
    wget https://hangarcdn.papermc.io/plugins/ViaVersion/ViaBackwards/versions/4.9.1/PAPER/ViaBackwards-4.9.1.jar -O ViaBackwards.jar
    #install viaRewind
    wget https://hangarcdn.papermc.io/plugins/ViaVersion/ViaRewind/versions/3.0.5/PAPER/ViaRewind-3.0.5.jar -O ViaRewind.jar
    #install viaVersionStatus
    wget https://www.spigotmc.org/resources/viaversionstatus.66959/download?version=473639 -O ViaVersionStatus.jar
        break
    #check if choice is 4
    elif [ $choice -eq 4 ]
    then
        #install viaVersion
    wget https://hangarcdn.papermc.io/plugins/ViaVersion/ViaVersion/versions/4.9.2/PAPER/ViaVersion-4.9.2.jar -O ViaVersion.jar
    #install viaBackwards
    wget https://hangarcdn.papermc.io/plugins/ViaVersion/ViaBackwards/versions/4.9.1/PAPER/ViaBackwards-4.9.1.jar -O ViaBackwards.jar
    #install viaRewind
    wget https://hangarcdn.papermc.io/plugins/ViaVersion/ViaRewind/versions/3.0.5/PAPER/ViaRewind-3.0.5.jar -O ViaRewind.jar
    #install viaVersionStatus
    wget https://www.spigotmc.org/resources/viaversionstatus.66959/download?version=473639 -O ViaVersionStatus.jar
    #install geysermc
    wget https://download.geysermc.org/v2/projects/geyser/versions/latest/builds/latest/downloads/spigot -O Geyser.jar
    #install floodgate
    wget https://download.geysermc.org/v2/projects/floodgate/versions/latest/builds/latest/downloads/spigot -O Floodgate.jar
        break
    #check if choice is 5
    elif [ $choice -eq 5 ]
    then
        #install viaVersion
    wget https://hangarcdn.papermc.io/plugins/ViaVersion/ViaVersion/versions/4.9.2/PAPER/ViaVersion-4.9.2.jar -O ViaVersion.jar
    #install viaBackwards
    wget https://hangarcdn.papermc.io/plugins/ViaVersion/ViaBackwards/versions/4.9.1/PAPER/ViaBackwards-4.9.1.jar -O ViaBackwards.jar
    #install viaRewind
    wget https://hangarcdn.papermc.io/plugins/ViaVersion/ViaRewind/versions/3.0.5/PAPER/ViaRewind-3.0.5.jar -O ViaRewind.jar
    #install viaVersionStatus
    wget https://www.spigotmc.org/resources/viaversionstatus.66959/download?version=473639 -O ViaVersionStatus.jar
    #install geysermc
    wget https://download.geysermc.org/v2/projects/geyser/versions/latest/builds/latest/downloads/spigot -O Geyser.jar
    #install floodgate
    wget https://download.geysermc.org/v2/projects/floodgate/versions/latest/builds/latest/downloads/spigot -O Floodgate.jar
    #install Playit.gg
    wget https://github.com/playit-cloud/playit-minecraft-plugin/releases/latest/download/playit-minecraft-plugin.jar -O PlayItGG.jar
        break
    #check if choice is 6
    elif [ $choice -eq 6 ]
    then
        echo "No plugins will be installed"
        break
    else
        echo "Invalid choice, please enter a number between 1 and 6."
    fi
done

 
#go back to server directory
cd ..
#run purpur-mc.sh
./purpur-mc.sh start
