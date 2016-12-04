@echo off 
color 1F
:ascii

echo """"""""""""""""""""""""""""""""""""""""""""""""
echo """"""""""""""""""""""""""""""""""""""""""""""""
echo "   _______          ____  __                  "
echo "  / ____\ \        / /  \/  |                 "
echo " | |     \ \  /\  / /| \  / |                 "
echo " | |      \ \/  \/ / | |\/| |                 "
echo " | |____   \  /\  /  | |  | |                 "
echo " _\_____|   \/  \/   |_|_ |_|      ______ __  "
echo " \ \ / /               (_)        |  ____/_ | "
echo "  \ V / _ __   ___ _ __ _  __ _   | |__   | | "
echo "   > < | '_ \ / _ \ '__| |/ _` |  |  __|  | | "
echo "  / . \| |_) |  __/ |  | | (_| |  | |____ | | "
echo " /_/ \_\ .__/ \___|_|  |_|\__,_|  |______||_| "
echo "       | |                                    "
echo "       |_|                                    "
echo "                                              "
echo """"""""""""""""""""""""""""""""""""""""""""""""
echo """"""""""""""""""""""""""""""""""""""""""""""""
echo "                                              "
echo "              Par Doctor_Titi                 "
echo "                                              "
echo """"""""""""""""""""""""""""""""""""""""""""""""
echo.
echo.

SET /P q=Voulez-vous installer CWM Philz Recovery sur votre Xperia E1? (y/n) 

 IF /i {%q%}=={y} (GOTO :uep)
 IF /i {%q%}=={n} (GOTO :exit)

goto :ascii

:exit

SET /P q=Voulez-vousvraiment quitter? (y/n) 

	IF /i {%q%}=={y} (exit)
	IF /i {%q%}=={n} (GOTO :ascii)

goto :exit


:uep

cls
echo.
REM //////////////////////////////////////
echo Preparation en cours...
REM //////////////////////////////////////

set PATH=%PATH%\core

echo. 
:rootask

set /P fix="Voulez-vous essayer de fixer le root? (y/n)"

	if /i {%fix%}=={y} (goto :fix1)
	if /i {%fix%}=={n} (goto :nofix)

goto :rootask

:fix1
adb push .\core\doctortiti\fix /data/local/tmp/doctortiti/fix
adb install .\core\doctortiti\fix\su.apk
adb shell su -c "/data/local/tmp/doctortiti/install_hijack.sh"
echo ...
:nofix
timeout /t 5 >nul 


cls
echo.
REM ////////////////////////////////
echo Envoi en cours des binnaires: 
REM ////////////////////////////////

echo.
adb push .\core\doctortiti /data/local/tmp/doctortiti

timeout /t 5 >nul

cls
echo.
REM //////////////////////////
echo Execution de l'exploit: 
REM //////////////////////////

echo.
adb shell "chmod -R 775 /data/local/tmp/doctortiti/"
adb shell "chmod -R 775 /data/local/tmp/doctortiti/*"
adb shell "chmod 775 /data/local/tmp/doctortiti/"
adb shell "chmod 775 /data/local/tmp/doctortiti/*"
adb shell su -c "/data/local/tmp/doctortiti/install_hijack.sh"

timeout /t 5 >nul

echo.
pause|echo Merci d'avoir utilise mon script ;) (Appuyez sur une touche pour quitter)