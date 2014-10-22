#!/bin/bash

hasAlreadyConnectedAndroid(){

	count=1

	while [ $count -le 4 ]
	do
		
		ADB_DEVICES=$( adb devices | wc -l  )

		if [ $count -gt 2 ]; then

			if [ $ADB_DEVICES -gt 2 ]
				then
					return 0;
			else
				return 1;
			fi
			break;
		fi
		
		count=$(( count+1 ))
	done
}

main(){

	turn=1

	while [ $turn -le 10 ]
	do
		
		if hasAlreadyConnectedAndroid; then

			echo "hasAlreadyConnectedAndroid"
			break;
		else
			turn=$(( turn+1 ))
			echo $turn
			echo "no devices connected, trying again"
			sleep 60
		fi
	done
	
}

main