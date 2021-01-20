@ECHO OFF
Rem This script will enable the internal Administrator account with the password "@IM&&@B!v1"
Rem Not intended for public use, internal use only.
color 9

:check_admin
Rem Do a simple privilege check
echo Conferindo permissao de administrador...
echo.
timeout /t 3 1>nul
net sessions 1>nul 2>nul
	if %errorlevel%== 0 (
		echo Permissao autenticada com sucesso!
		goto top_menu
	) else (
		echo O script nao esta sendo executado como administrador, tente novamente.
		pause
		exit
	)

:top_menu
ECHO           .://---.           
ECHO       .:+yyyyo.---/:-.       
ECHO `ooosyyyyyyyyo.------:/:::/` 		
ECHO `hyyyyyyyyyyyo.-----------/` =============================
ECHO `hyyyyyyyyyhho.-----------/` ENABLE INTERNAL ADMINISTRATOR
ECHO `hyyyyyyyhhhho.-----------/` =============================
ECHO `hyyyyyyhhhhhs.-----------+` 		    
ECHO  +///////////::////////////  
ECHO  `/----------.shhhhhhhhhhy`  
ECHO   ./---------.shhhhhhhhhy.   
ECHO    `/:--------shhhhhhhho`    
ECHO      ./:------shhhhhhs.      
ECHO        .:/----shhhho.        #Leia o README.txt antes de utilizar
ECHO          `-::-shs:`          #Execute como administrador
ECHO             `--`             #Script by Thiago Gabriel de Oliveira 
ECHO.

set /p language=Por favor, selecione o idioma do sistema operacional (pt-BR para portugues brasileiro e en-US para ingles):

if %language%==pt-BR (
	Rem You can change the displayed password as needed
	echo Idioma selecionado: Portugues brasileiro
	echo Habilitando o Administrador local com a senha: "@IM&&@B!v1"
	goto enable_admin_pt-BR  	
) 

if %language%==en-US (
	Rem You can change the displayed password as needed
	echo Selected language: English
	echo Enabling local Administrator account with the password: "@IM&&@B!v1"
	goto enable_admin_en-US
)

::
echo Invalid option, please try again / Opcao invalida, tente novamente.
Pause
Exit

:enable_admin_pt-BR
Rem Insert the desired user account password between the quotation marks 
net user Administrador "@IM&&@B!v1" /active:yes
	if %errorlevel%==0 (
	echo Administrador ativado com exito!
	goto prompt_user_del_pt-BR
	) else (
		echo Este usuario nao existe, confirme se o idioma selecionado esta correto e tente novamente.
		Pause
		exit 
	)
			
:enable_admin_en-US
Rem Insert the desired user account password between the quotation marks 
net user Administrator "@IM&&@B!v1" /active:yes
	if %errorlevel%==0 (
	echo Administrator enabled successfully! 
	goto prompt_user_del_en-US
	) else (
		echo This user does not exist, check if the selected language is correct and try again.
		Pause
		exit 
	)
			
:prompt_user_del_pt-BR
Rem This command is responsible for deleting the typed user account
set /p user_del=Escreva o nome do usuario a ser removido:
net user %user_del% /delete
	if %ERRORLEVEL%==0 (			
		echo Usuario removido com sucesso!
		pause
		exit 
	) else (
		echo Este usuario nao existe, confirme se o nome de usuario digitado esta correto.
		Pause
		exit 
	)
	
:prompt_user_del_en-US
Rem This command is responsible for deleting the typed user account
set /p user_del=Type the user name to be removed:
net user %user_del% /delete
	if %ERRORLEVEL%==0 (
		echo User sucesfully removed!
		pause
		exit
	) else (
		echo This user does not exist, make sure you typed the correct user name.
		Pause
	exit 
	)