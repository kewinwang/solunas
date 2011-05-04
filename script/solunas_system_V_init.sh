#!/bin/bash
#
# Solunas System V script
#
# description: the script [start/stops/restart]s Solunas;
#    should be set to start at the default runlevel
#

# Start Solunas servers
start() {
        echo -n "Starting Solunas server ... "
        cd $SOLUNAS
        ./script/server -d
}

# Restart Solunas server
stop() {
        echo -n "Stopping Solunas server ..."
        kill $(cat $SOLUNAS/tmp/pids/server.pid)
}



### main logic ###
case "$1" in
  start)
        start
        ;;
  stop)
        stop
        ;;
  status)
        echo "status"
        ;;
  restart|reload|restart)
        stop
        start
        ;;
  *)
	### check the validity of the configuration ###
        exists=1
        if [ $SOLUNAS ]
        then
	  if [ ! -d $SOLUNAS ]
	  then
	    exists=0
          else
            if [ ! -x $SOLUNAS/script/server ]
            then
              exists=0
            fi
	  fi
        else
          exists=0
        fi
        if [ $exists -eq 0 ]
        then
          echo "Please set SOLUNAS ENV varable to point the Solunas' directory"
          exit 1
        fi
        echo $"Usage: $0 {start|stop|restart|status}"
        exit 1
esac

exit 0