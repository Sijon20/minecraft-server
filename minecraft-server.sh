#!/bin/sh
# Function to check if screen is installed
function check_screen {
    if ! command -v screen &> /dev/null
    then
        echo "ERROR : Screen could not be found. Please install it and run the script again."
        exit 1
    fi
}

# Function to check if Java is installed
function check_java {
    if ! command -v java &> /dev/null
    then
        echo "ERORR : Java could not be found. Please install it and run the script again."
        exit 1
    fi
}

check_screen
check_java

#make server directory
mkdir /home/mincraft-server
#change directory to server directory
cd /home/mincraft-server


#take user input [purpur, paper, spigot, vanilla] if something else loop
echo "Enter the server type [purpur, paper, spigot , vanilla]"
read server_type

#check if server type is purpur
if [ $server_type = "purpur" ]
then
    #take user input [version-build] if something else loop
    echo "Enter the purpur version "
    read server_version
    echo "Enter the purpur build "
    read server_build
    #download the purpur jar
    wget https://api.purpurmc.org/v2/purpur/$server_version/$server_build/download -O purpur.jar
fi
#check if server type is paper
if [ $server_type = "paper" ]
then
    #take user input [version-build] if something else loop
    echo "Enter the paper version "
    read server_version
    echo "Enter the paper build "
    read server_build
    #download the paper jar
    wget https://api.papermc.io/v2/projects/paper/versions/$server_version/builds/$server_build/downloads/paper-$server_version-$server_build.jar -O server.jar
fi
#check if server type is spigot
if [ $server_type = "spigot" ]
then
    #take user input [version] if something else loop
    echo "Enter the spigot version "
    read server_version
    #download the spigot jar
    wget https://download.getbukkit.org/spigot/spigot-$server_version.jar -O server.jar

fi
if [ $server_type = "vanilla" ]
then
    #download the vanilla jar
    wget https://piston-data.mojang.com/v1/objects/8dd1a28015f51b1803213892b50b7b4fc76e594d/server.jar -O server.jar
fi
#check if server type is invalid
if [ $server_type != "purpur" ] && [ $server_type != "paper" ] && [ $server_type != "spigot" ] && [ $server_type != "vanilla" ]
then
    echo "Unsupported server type"
    exit 1
fi

#create a eula.txt
cat > eula.txt <<EOF
#By changing the setting below to TRUE you are indicating your agreement to our EULA (https://account.mojang.com/documents/minecraft_eula).
#Sun Oct 17 18:37:28 UTC 2021
eula=true
EOF

#create a script
cat > $server_type-mc.sh <<EOF
#!/bin/sh
#start , stop , restart , status, console using screen


case "\$1" in
    start)
        screen -dmS console java -Xmx1024M -Xms1024M -jar server.jar nogui
        echo "Server started"
        echo "To view the console type ./server_type-mc.sh console"
        ;;
    stop)
        if pgrep -f console > /dev/null
    then
        pkill -f console
        echo "Server stopped"
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
        if pgrep -f console > /dev/null
    then
        echo "Server is running."
    else
        echo "Server is not currently running."
    fi
        ;;
    console)
        screen -r console
        ;;
    *)
        echo "Usage: \$0 {start|stop|restart|status|console}"
        exit 1
        ;;
esac

EOF

chmod +x $server_type-mc.sh
