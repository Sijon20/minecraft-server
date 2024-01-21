#!/bin/sh
#create a directory for the server
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
# creat purpur-mc.sh that will be constent  "script to start, stop, restart the server"
cat > purpur-mc.sh <<EOF
#!/bin/sh
# Path: purpur-mc.sh
#install server
#check if purpur.jar exists
if [ ! -f purpur.jar ]; then
    echo "purpur.jar not found"
    echo "Downloading purpur.jar"
    wget https://api.purpurmc.org/v2/purpur/1.20.4/latest/download -O purpur.jar
fi

#start the server

start() {
    java -Xms1G -Xmx1G -jar purpur.jar nogui
}
#stop the server
stop() {
    screen -S minecraft -X stuff "stop^M"
}
#restart the server
restart() {
    stop
    start
}
#check if the server is running
status() {
    screen -list | grep -q "minecraft" && echo "Server is running" || echo "Server is not running"
}
#check if the server is running
if [ "\$1" = "start" ]; then
    start
elif [ "\$1" = "stop" ]; then
    stop
elif [ "\$1" = "restart" ]; then
    restart
elif [ "\$1" = "status" ]; then
    status
else
    echo "Usage: ./purpur-mc.sh [start|stop|restart|status]"
fi
EOF

#make purpur-mc.sh executable
chmod +x purpur-mc.sh

./purpur-mc.sh start

