#!/bin/bash

AVD_NAME=""
AVD_TARGET=""

getTargetByVersion(){

	if [ "$1" == "4.3" ]; then

		AVD_TARGET="18"
	elif [ "$1" == "4.2.2" ]; then

		AVD_TARGET="17"
	elif [ "$1" == "4.1.2" ]; then

		AVD_TARGET="16"
	else

		AVD_TARGET="19"
	fi
}

verificaSeAvdTargetExisteCasoNaoSetaValorDefault (){
    
    if [ "$1" == "" ]; then
	
		AVD_TARGET="19"
		echo "Nenhum target foi passado como parametro, entao usarei default: ${AVD_TARGET}"
	else
		
		echo "Recuperando target pela versao passada como parametro: $1"
		getTargetByVersion $1
	fi
}

verificaSeAvdNameExisteCasoNaoSetaValorDefault(){

	if [ "$1" == "" ]; then
	
		AVD_NAME="AndroidEmulatorAppium_${AVD_TARGET}"
		echo "Nenhum nome de emulator foi passado como parametro, entao usarei default: ${AVD_NAME}"
	else
		
		AVD_NAME=$1
		echo "Utilizando nome de emulador passado como parametro: ${AVD_NAME}"
	fi
}

executeEmulator(){

	echo "Executando emulador:  $1"
	${ANDROID_HOME}/tools/emulator -avd $1 &
}

emulatorExists(){

	echo "Verificando se o emulador $1 ja existe."
	AVD=$(${ANDROID_HOME}/tools/android list avd | grep "Name: $1" | wc -l)

	if [ $AVD -gt 0 ]
		then
		   		
			return 0;	
	else

		return 1;
	fi
}

createEmulator(){

	echo "Emulador $2  nao encontrado, entao irei cria-lo"
	${ANDROID_HOME}/tools/android create avd -f -a -c 20M -s HVGA -n $2 -t "Google Inc.:Google APIs:$1" --abi armeabi-v7a
}

hasAlreadyConnectedAndroid(){

	ADB_DEVICES=$( adb devices | wc -l  )

	if [ $ADB_DEVICES -gt 2 ]
		then
			return 0;
	else
		return 1;
	fi
}

main(){

	if hasAlreadyConnectedAndroid; then
		echo "has already connected android"
	else

		verificaSeAvdTargetExisteCasoNaoSetaValorDefault $1
		verificaSeAvdNameExisteCasoNaoSetaValorDefault $2

		if [ -z "$ANDROID_HOME" ]; then
		    echo "Variavel de ambiente ANDROID_HOME nao foi encontrada, por favor adicione ela e tente novamente!!!"
		else
				
				if emulatorExists ${AVD_NAME}; then
			   		
					executeEmulator ${AVD_NAME}		
				else
					
					createEmulator ${AVD_TARGET} ${AVD_NAME}

					if emulatorExists ${AVD_NAME}; then
				   		
						executeEmulator ${AVD_NAME}
					else

						echo "Ocorreu um erro ao criar o emulador:  ${AVD_NAME}"

					fi
				fi		
		fi
	fi
}

#funcoes declaradas no inicio do script
main $1 $2