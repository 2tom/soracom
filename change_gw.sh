#!/bin/bash

change() {
	echo "...now default gw"
	netstat -rnv
	echo ""
	sudo route del default dev wlan0
	sudo route add default dev ppp0
	echo "...change default gw"
	netstat -rnv
	return 0
}

reset() {
	echo "...reset default gw"
	netstat -rnv
	sudo ifdown wlan0 ; sudo ifup wlan0
	return 0
}

case $1 in
        change)
                change
                        ;;
        reset)
                reset
                        ;;
        *)
               echo "Usage: $0 {change|reset}"
               exit 2
                        ;;
esac
