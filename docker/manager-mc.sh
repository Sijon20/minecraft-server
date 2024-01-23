#!/bin/sh
#start , stop , restart , status, console using screen

case "$1" in
    start)
        screen -dmS console java -Xmx1024M -Xms1024M -jar server.jar nogui
        echo "Server started"
        echo "To view the console type ./server_type-mc.sh console"
        tail -f /dev/null
        
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
        $0 stop
        sleep 2
        $0 start
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
        echo "Usage: $0 {start|stop|restart|status|console}"
        exit 1
        ;;
esac