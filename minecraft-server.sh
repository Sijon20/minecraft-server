#!/bin/sh
#create a directory for the server
mkdir ~/minecraft-purpur-server
cd ~/minecraft-purpur-server
#download the latest purpur jar
wget https://api.purpurmc.org/v2/purpur/1.20.4/latest/download -O purpur.jar

#install java
#check if java is installed

if ! command -v java &> /dev/null
then
    #install java 17

    #check linux distro [redhat, debian, arch , alpine ]
    if [ -f /etc/redhat-release ]; then
        #redhat
        sudo dnf install java-17-openjdk
    elif [ -f /etc/debian_version ]; then
        #debian
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

case "$1" in
  start)
    $JAVA_EXECUTABLE -Xmx2G -jar $PURPUR_JAR $SERVER_OPTS &
    ;;
  stop)
    pid=$(pgrep -f $PURPUR_JAR)
    kill $pid
    ;;
  restart)
    $0 stop
    sleep 2
    $0 start
    ;;
  *)
    echo "Usage: $0 {start|stop|restart}"
    exit 1
    ;;
esac
EOF

#make purpur-mc.sh executable
chmod +x purpur-mc.sh
#make directory plugins
mkdir plugins
#run purpur-mc.sh
./purpur-mc.sh start


#download latest plugins [viaVersion,viaBackwards,viaRewind,viaVersinStatus,geysermc,floodgate , Playit.gg ]
cd plugins

# wget https://ci.viaversion.com/job/ViaVersion/lastSuccessfulBuild/artifact/jar/target/ViaVersion-4.0.1.jar -O ViaVersion.jar

# wget https://ci.viaversion.com/job/ViaBackwards/lastSuccessfulBuild/artifact/jar/target/ViaBackwards-4.0.1.jar -O ViaBackwards.jar 

# wget https://ci.viaversion.com/job/ViaRewind/lastSuccessfulBuild/artifact/jar/target/ViaRewind-4.0.1.jar -O ViaRewind.jar

# wget https://ci.viaversion.com/job/ViaVersionStatus/lastSuccessfulBuild/artifact/jar/target/ViaVersionStatus-1.0.0.jar -O ViaVersionStatus.jar

wget https://download.geysermc.org/v2/projects/geyser/versions/latest/builds/latest/downloads/spigot -O Geyser.jar

wget https://download.geysermc.org/v2/projects/floodgate/versions/latest/builds/latest/downloads/spigot -O Floodgate.jar

wget https://github.com/playit-cloud/playit-minecraft-plugin/releases/latest/download/playit-minecraft-plugin.jar -O Playit-gg.jar

# Write eula.txt
cat > eula.txt <<EOF
#By changing the setting below to TRUE you are indicating your agreement to our EULA (https://account.mojang.com/documents/minecraft_eula).
#Sun Oct 17 18:37:28 UTC 2021
eula=true
EOF

# create readme.md
cat > README.md <<EOF
# Minecraft Purpur Server
## How to start the server
~Run ./purpur-mc.sh start
Enjoy
## How to stop the server
~Run ./purpur-mc.sh stop
## How to restart the server
~Run ./purpur-mc.sh restart
## How to update the server
~Run ./purpur-mc.sh stop
~Run ./purpur-mc.sh start
## How to install plugins
1. Go to plugins directory
2. Download the plugin
3. Restart the server
EOF

