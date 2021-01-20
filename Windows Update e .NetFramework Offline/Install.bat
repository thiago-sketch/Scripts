@ECHO OFF
Rem .NET Framework 3.5 and Windows Update conflict resolver
Rem Internal use only, not inteded for public release

:Top
echo =============================================================================
echo Windows Update and .NetFramework install resolver  
echo.                                                                             
echo Script by Thiago Gabriel de Oliveira
echo Uso interno TI e Infraestrutura - BILD VITTA
echo =============================================================================
echo.
goto :Check_Admin

:Check_Admin
Rem Do a simple privilege check
echo.
echo Conferindo permissao de administrador...
echo.
timeout /t 3 1>nul
net sessions 1>nul 2>nul
	if %errorlevel%== 0 (
		echo Permissao autenticada com sucesso!
		goto :Stop_Services
	) else (
		echo O script nao esta sendo executado como administrador, tente novamente.
		pause
		exit
	)

:Stop_Services
Rem Stop services related to Windows Update
Rem Services list: Windows Update; Cryptographic Services; Background Intelligent Transfer Service; Windows Installer
echo.
echo Interrompendo o Windows Update, aguarde...
echo.
timeout /t 2 1>nul
net stop wuauserv 1>nul 2>nul 
echo Interrompendo Cryptographic Services, aguarde...
net stop cryptSvc 1>nul 2>nul
echo Interrompendo Background Intelligent Transfer Service, aguarde...
net stop bits 1>nul 2>nul
echo Interrompendo Windows Installer, aguarde...
net stop msiserver 1>nul 2>nul
timeout /t 2 1>nul
echo.
echo Servicos interrompidos com exito!
echo.
timeout /t 2 1>nul
goto :Delete_Cache
	
:Delete_Cache
Rem Deletes all Windows Update cache folders from all versions of Windows
echo.
echo Excluindo pastas de cache, aguarde um momento...
echo.
timeout /t 3 1>nul
rd /s /q C:\Windows.old 1>nul 2>nul
rd /s /q C:\$WINDOWS.~BT 1>nul 2>nul
rd /s /q C:\Windows\SoftwareDistribution 1>nul 2>nul
echo.
echo Cache deletado com exito!
echo.
timeout /t 3 1>nul
goto :Net_Prompt
		
:Net_Prompt
echo.
set /p choice=Windows update limpo com sucesso, gostaria de instalar o .NetFramework 3.5? [Y/N]:
	if %choice%==Y (
	echo.
	echo Iniciando a instalacao! 
	echo.
	goto :Delete_RootKey
	) 

	if %choice%==N (
	echo.
	echo Reiniciando os servicos do Windows Update, aguarde um momento...
	echo.
	goto :Start_Services_Close
	)

::
echo Comando invalido, tente novamente.
pause
exit
 
:Delete_RootKey
Rem Deleting InstallRoot register for a clean netfx3.5 install
echo.
echo Limpando o arquivo de registro do .NetFramework...
echo.
timeout /t 2 1>nul
reg delete HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\.NETFramework /v InstallRoot /f 1>nul 2>nul
	if %errorlevel%==0 (
	echo.
	echo Registro de instalacao do .NETFramework removido com exito!
	echo.
	goto :Start_Services_Install 
	) Else (
		echo.
		echo O registro nao foi encontrado, continuando com a instalacao...
		goto :Start_Services_Install
		)

:Start_Services_Close
Rem Restart the Windows Update Services
net start wuauserv 1>nul 2>nul 
net start cryptSvc 1>nul 2>nul
net start bits 1>nul 2>nul
net start msiserver 1>nul 2>nul
timeout /t 3 1>nul
echo.
echo =============================================================================
echo Servicos iniciados com sucesso, voce ja pode fechar este script!
echo =============================================================================
echo.
pause
exit

:Start_Services_Install
Rem Restart the Windows Update Services
echo.
echo Reiniciando os servicos do Windows Update, aguarde...
echo.
net start wuauserv 1>nul 2>nul 
net start cryptSvc 1>nul 2>nul
net start bits 1>nul 2>nul
net start msiserver 1>nul 2>nul
echo.
echo Servicos iniciados com sucesso!
echo.
goto :OfflineInstall

:OfflineInstall
Rem This is a simple version check
echo.
echo Identificando a versao do Windows...
echo.
timeout /t 2 1>nul
cd %ProgramFiles(x86)%
	if errorlevel = 0 (
	rem x64 version
	goto :x64_Install
	) else (
	rem x86 version
	goto :x32_Install
	)

:x64_Install
echo Windows de 64 bits, iniciando a instalacao...
echo.
DISM /Online /NoRestart /Add-Package /PackagePath:"C:\UpdateResolver\ntfx3Offline\x64\update.mum"
	if %errorlevel%==0 (
		echo.
		echo Instalacao concluida com exito! Iniciando reparo no registro.
		echo.
		goto :Fix_Reg
	) else (
		reg add HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\.NETFramework /v InstallRoot /t REG_SZ /d C:\Windows\Microsoft.NET\Framework64\ /f 1>nul 2>nul
		echo.
		echo A instalacao nao pode ser concluida, se certifique de desabilitar o antivirus e tente novamente.
		echo.
		pause 
		exit
	)

:x32_Install
echo Windows de 32 bits, iniciando a instalacao...
echo.
DISM /Online /NoRestart /Add-Package /PackagePath:"C:\UpdateResolver\ntfx3Offline\x86\update.mum"
	if %errorlevel%==0 (
		echo.
		echo Instalacao concluida com exito! Iniciando reparo no registro.
		echo.
		goto :Fix_Reg
	) else (
		reg add HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\.NETFramework /v InstallRoot /t REG_SZ /d C:\Windows\Microsoft.NET\Framework64\ /f 1>nul 2>nul
		echo.
		echo A instalacao nao pode ser concluida, se certifique de desabilitar o antivirus e tente novamente.
		echo.
		pause
		exit
	)
 

:Fix_Reg
rem Creates a new register file after the installation
echo.
echo Criando arquivo de registro...
echo.
timeout /t 2 >nul
reg add HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\.NETFramework /v InstallRoot /t REG_SZ /d C:\Windows\Microsoft.NET\Framework64\ /f
	if %errorlevel%==0 (
		echo.
		echo =============================================================================
		echo Arquivo de registro criado com exito! Voce ja pode fechar o script.
		echo =============================================================================
		pause 
		exit
	) else (
		echo.
		echo =============================================================================
		echo O arquivo de registro nao pode ser criado, tente fazer isso manualmente.
		echo =============================================================================
		pause
		exit
	)
