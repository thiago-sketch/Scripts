@ECHO OFF

color 9
echo  ___  _  _  ___  ____  ____  ____  ____ 
echo / __)( \/ )/ __)(  _ \(  _ \( ___)(  _ \
echo \__ \ \  / \__ \ )___/ )   / )__)  )___/
echo (___/ (__) (___/(__)  (_)\_)(____)(__)                                                              
ECHO.   
ECHO #Script by: Thiago Gabriel de Oliveira
ECHO. 
ECHO Inicializando o Sysprep, se certifique de rodar este script como administrador.
ECHO.

cd %WINDIR%\System32\Sysprep\
sysprep.exe
	if %ERRORLEVEL%==0 (
		ECHO Sysprep inicializado com sucesso, o script ja pode ser encerrado.
		Pause
		exit
		) else (
			echo Acesso negado, se certifique de rodar o script como administrador.
			Pause
			Exit
		) 