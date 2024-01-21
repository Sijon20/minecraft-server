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

case "\$1" in
  start)
    \$JAVA_EXECUTABLE -Xmx2G -jar \$PURPUR_JAR \$SERVER_OPTS nogui &
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
  *)
    echo "Usage: \$0 {start|stop|restart|status}"
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
echo "1. plugins to install [viaVersion,viaBackwards,viaRewind,viaVersinStatus]"
echo "2. plugins to install [geysermc,floodgate , Playit.gg]"
echo "3. plugins to install [viaVersion,viaBackwards,viaRewind,viaVersinStatus,geysermc,floodgate , Playit.gg]"
echo "4. None"

read -p "Enter your choice: " choice
#install plugins
#check if choice is 1
if [ $choice -eq 1 ]; then
    #install plugins [viaVersion,viaBackwards,viaRewind,viaVersinStatus]
    wget https://ci.viaversion.com/job/ViaVersion/lastSuccessfulBuild/artifact/jar/target/ViaVersion-4.0.1.jar -O ViaVersion.jar
    wget https://ci.viaversion.com/job/ViaBackwards/lastSuccessfulBuild/artifact/jar/target/ViaBackwards-4.0.1.jar -O ViaBackwards.jar
    wget https://ci.viaversion.com/job/ViaRewind/lastSuccessfulBuild/artifact/jar/target/ViaRewind-4.0.1.jar -O ViaRewind.jar
    wget https://ci.viaversion.com/job/ViaVersionStatus/lastSuccessfulBuild/artifact/jar/target/ViaVersionStatus-1.0.0.jar -O ViaVersionStatus.jar
#check if choice is 2
elif [ $choice -eq 2 ]; then
    #install plugins [geysermc,floodgate , Playit.gg]
    wget https://download.geysermc.org/v2/projects/geyser/versions/latest/builds/latest/downloads/spigot -O Geyser-Spigot.jar
    wget https://download.geysermc.org/v2/projects/floodgate/versions/latest/builds/latest/downloads/spigot -O Floodgate-Bukkit.jar
    wget https://github.com/playit-cloud/playit-minecraft-plugin/releases/latest/download/playit-minecraft-plugin.jar -O PlayIt-gg.jar
#check if choice is 3
elif [ $choice -eq 3 ]; then
    #install plugins [viaVersion,viaBackwards,viaRewind,viaVersinStatus,geysermc,floodgate , Playit.gg]
    wget https://ci.viaversion.com/job/ViaVersion/lastSuccessfulBuild/artifact/jar/target/ViaVersion-4.0.1.jar -O ViaVersion.jar
    wget https://ci.viaversion.com/job/ViaBackwards/lastSuccessfulBuild/artifact/jar/target/ViaBackwards-4.0.1.jar -O ViaBackwards.jar
    wget https://ci.viaversion.com/job/ViaRewind/lastSuccessfulBuild/artifact/jar/target/ViaRewind-4.0.1.jar -O ViaRewind.jar
    wget https://ci.viaversion.com/job/ViaVersionStatus/lastSuccessfulBuild/artifact/jar/target/ViaVersionStatus-1.0.0.jar -O ViaVersionStatus.jar
    wget https://download.geysermc.org/v2/projects/geyser/versions/latest/builds/latest/downloads/spigot -O Geyser-Spigot.jar
    wget https://download.geysermc.org/v2/projects/floodgate/versions/latest/builds/latest/downloads/spigot -O Floodgate-Bukkit.jar
    wget https://github.com/playit-cloud/playit-minecraft-plugin/releases/latest/download/playit-minecraft-plugin.jar -O PlayIt-gg.jar
#check if choice is 4
elif [ $choice -eq 4 ]; then
    #do nothing
    echo "Nothing to install"
else
    echo "Invalid choice"
    exit 1
fi
 
#go back to server directory
cd ..
#run purpur-mc.sh
./purpur-mc.sh start
