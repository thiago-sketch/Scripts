@echo OFF
Rem Printer Installer Script
Rem Source: Printer server at \\192.168.0.170 or \\prdopimpap01

:TopMenu
color 9
echo ============================
echo Instalador de impressora
echo Localizacao: Civitas 3 andar
echo Versao: 1.00
echo ============================
echo.
goto :AdminRights

:AdminRights
Rem Checks for admin privileges
echo Conferindo permissao de administrador, aguarde...
timeout /t 3 1>nul
net sessions 1>nul 2>nul
    if %errorlevel%==0 (
        echo.
        echo Permissao autenticada com sucesso!
        goto :CheckConnection
    ) else (
        echo.
        echo O script nao esta sendo executado como administrador, reinicie e tente novamente.
        pause
        exit
    )

:CheckConnection
Rem Pings the server to check if connection is stable
Rem You can change the displayed names as needed inside "PrinterNames.txt"
Rem Current printer names: BRRPOIMPPB01; BRRPOIMPPB02; BRRPOIMPPB04; BRRPOIMPPB11; BRRPOIMPPB12
timeout /t 2 1>nul 
echo.
echo Conferindo conexao com o servidor, aguarde um instante...
echo.
ping 192.168.0.170 -n 5 1>nul 2>nul
    if %errorlevel%==0 (
        echo Conexao estabelecida! 
        echo O script ira instalar as seguintes impressoras:
        for /F "skip=5 delims=" %%a in (%~p0\PrinterNames.txt) do echo. | echo %%a
        goto :FetchPrinters
    ) else (
        echo Nao foi possivel estabelecer uma conexao estavel com o servidor, tente novamente mais tarde.
        pause
        exit
    )

:FetchPrinters
Rem Fetchs the printer network adress list from "PrintersLocalAdress.txt"
echo.
echo Recuperando lista de impressoras...
for /F "skip=3 tokens=1,2,3,4,5 delims= " %%a in (%~p0\PrintersLocalAdress.txt) do (
    set printer1=%%a
    set printer2=%%b
    set printer3=%%c
    set printer4=%%d
    set printer5=%%e 
    )
rundll32 printui.dll,PrintUIEntry /in /n\\%printer1%
    if %errorlevel%==0 (
        echo Instalado com exito: %printer1%
    ) else (
        echo Erro de instalacao: %printer1%
    )

rundll32 printui.dll,PrintUIEntry /in /n\\%printer2%
    if %errorlevel%==0 (
        echo Instalado com exito: %printer2%
    ) else (
        echo Erro de instalacao: %printer2%
    )

rundll32 printui.dll,PrintUIEntry /in /n\\%printer3%
    if %errorlevel%==0 (
        echo Instalado com exito: %printer3%
    ) else (
        echo Erro de instalacao: %printer3%
    )

rundll32 printui.dll,PrintUIEntry /in /n\\%printer4%
    if %errorlevel%==0 (
        echo Instalado com exito: %printer4%
    ) else (
        echo Erro de instalacao: %printer4%
    )

rundll32 printui.dll,PrintUIEntry /in /n\\%printer5%
    if %errorlevel%==0 (
        echo Instalado com exito: %printer5%
    ) else (
        echo Erro de instalacao: %printer5%
    )
echo.
echo Instalacao concluida, se algum erro ter ocorrido procure suporte tecnico abrindo um chamdo.
pause
exit




