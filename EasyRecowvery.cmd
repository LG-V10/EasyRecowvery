@echo off
set SRC=%~dp0exploit
set ZIPS=%~dp0zips
set TARGET=/data/local/tmp
set EXPLOITLOG=%~dp0recowvery-exploit.log
set FLASHLOG=%~dp0recowvery-flash.log
set ADB=""
set MODE=
set EXTADB=
set OPTCRYPT=true
set NOHASH=

:mainmenu

if "%OPTCRYPT%"=="installed" set OPTCRYPT=true

cls
set command=
echo.
echo ============================================================================================
echo ==            T-mobile LG V20 ^(H918^) One-Click DirtyCow Installer and Toolkit!            ==
echo ==                        https://github.com/bziemek/EasyRecowvery                        ==
echo ==----------------------------------------------------------------------------------------==
echo ==                      Powered by jcadduono's Dirtycow root exploit                      ==
echo ==                 https://github.com/jcadduono/android_external_dirtycow                 ==
echo ================================================================================ 1.3b2 =====
echo.
echo Pre-flight checklist:
echo - Install ADB, perferably with the Android SDK provided by Google (https://goo.gl/7ijkjp)
echo - Unlock your bootloader with "fastboot oem unlock" (see: http://i.imgur.com/2BhNatP.png)
echo - Enable USB debugging on your device and set this computer to always be allowed to connect
echo - Place the latest no-verity-opt-encrypt-*.zip in %ZIPS%
echo - Upload your desired recovery to /sdcard/recovery.img
echo - Plug in only one device - this script does not support batch operations
echo - Try to resist the urge to touch your phone, especially when the screen goes all weird
echo - FORMAT DATA the first time you enter TWRP! This is NEEDED to remove the default encryption
echo.
echo IF YOU JUST WANT TO GET TWRP RUNNING WITH NO OTHER MODIFICATIONS, USE OPTION 1
echo TO ROOT AFTER FLASHING TWRP, PLACE A SUPERUSER ZIP IN THE "ZIPS" FOLDER AND USE OPTION 3
echo.
echo Please select from the following options:
echo.
echo 1) Run exploit and flash /sdcard/recovery.img ^(Leave selinux enforcing^)
echo 2) Run exploit and flash /sdcard/recovery.img ^(Set selinux permissive^)
echo 3) Install superuser ZIP from %ZIPS% ^(Requires TWRP^)
echo 4) Restore stock boot and recovery from /sdcard/stock_*.img
echo 5) Extras and Advanced Tools
echo 0) Quit this script
echo.
set /p command=^(0-5^) %=%

if "%command%"=="0" goto end
if "%command%"=="1" (
    set mode=1
    echo.
    echo Running in normal exploit mode
    goto start
)
if "%command%"=="2" (
    set mode=2
    echo.
    echo Running in permissive exploit mode
    goto start
)
if "%command%"=="3" (
    set mode=5
    echo.
    echo Running in superuser install mode
    goto start
)
if "%command%"=="4" (
    set mode=7
    echo.
    echo Running in restore mode
    goto start
)
if "%command%"=="5" goto advmenu

rem TODO: Accept custom zips by checking input against files in \zips\

goto mainmenu

:advmenu

cls
set command=
echo.
echo ============================================================================================
echo ==                               Extras and Advanced Tools                                ==
echo ============================================================================================
echo.
echo Please select from the following options:
echo.
echo 1) Run exploit and spawn a limited root shell ^(Be careful in there!^)
echo 2) Flash only ^(For resuming after a successful exploit^)
echo 3) Download boot and recovery backups from /sdcard/stock_*.img
echo 4) Install no-verity-opt-encrypt from the "zips" folder
echo 5) Reboot to recovery
<nul set /p= 6) Toggle forced encryption after exploit ^(currently 
if "%OPTCRYPT%"=="true" (echo optional^)) else (echo forced^))
<nul set /p= 7) Toggle integrity verification during exploit ^(currently 
if "%NOHASH%"=="--nohash" (echo disabled^)) else (echo enabled^))
<nul set /p= 8) Toggle using bundled adb.exe ^(currently 
if "%EXTADB%"=="true" (echo external^)) else (echo bundled^))
echo 0) Return to main menu
echo.
set /p command=^(0-5^) %=%

if "%command%"=="0" goto mainmenu
if "%command%"=="1" (
    set mode=3
    echo.
    echo Running in spawn shell mode
    goto start
)
if "%command%"=="2" (
    set mode=4
    echo.
    echo Running in flash-only mode
    goto start
)
if "%command%"=="3" (
    set mode=6
    echo.
    echo Running in backup download mode
    goto start
)
if "%command%"=="4" (
    set mode=8
    echo.
    echo Running in no-verity-opt-encrypt install mode
    goto start
)
if "%command%"=="5" (
    set mode=9
    echo.
    echo Running in reboot to recovery mode
    goto start
)
if "%command%"=="6" (
    if "%OPTCRYPT%"=="" (set OPTCRYPT=true) else (set OPTCRYPT=)
    goto advmenu
)
if "%command%"=="7" (
    if "%NOHASH%"=="--nohash" (set NOHASH=) else (set NOHASH=--nohash)
    goto advmenu
)
if "%command%"=="8" (
    if "%EXTADB%"=="true" (set EXTADB=) else (set EXTADB=true)
    goto advmenu
)

goto advmenu

:start

set GETBACKUPS=

pause
echo. >%FLASHLOG%
echo Starting in mode %mode% >%EXPLOITLOG%

echo.
echo - - - Making sure we're good to go - - -
echo.

:checksrc

<nul set /p= Checking permissions in the EasyRecowvery directory...

copy /y NUL %~dp0tmp >NUL 2>&1 || (
    echo FAILED!
    echo.
    echo We don't have permission to create log or backup files in
    echo %~dp0!
    echo Please extract EasyRecowvery to a different directory, then try again.
    goto tomenu
)
del %~dp0tmp

<nul set /p= Checking that the exploit files exist...

if exist "exploit\" ^
if exist "exploit\recowvery.sh" ^
if exist "exploit\dirtycow" ^
if exist "exploit\recowvery-app_process64" ^
if exist "exploit\recowvery-applypatch" ^
if exist "exploit\recowvery-run-as" (
    echo SUCCESS!
    goto findzips
)
echo FAILED!
echo.
echo You seem to be missing one or more files in the "exploit" directory.
echo Please download and extract a fresh copy of EasyRecowvery, then try again.
goto tomenu

:findzips

set CRYPTZIP=noverity-optcrypt.zip
set SUZIP=supersu.zip
for %%i in (%ZIPS%\*crypt*.zip) do (set CRYPTZIP=%%i)
for %%i in (%ZIPS%\*super*.zip) do (set SUZIP=%%i)

<nul set /p= Locating adb.exe...                                             

if not "%EXTADB%"=="true" (
    rem <nul set /p= Using bundled adb.exe...
    for /f "tokens=5" %%i in ('adb\adb-recowvery.exe version') do (
        if not "%%i"=="" (
            if not "%%i"=="1.0.36" (
                goto findadb
            )
        )
    )
    echo SUCCESS!
    set ADB=adb\adb-recowvery.exe
    goto scan
)

:findadb

where /q adb && for /f "tokens=1" %%i in ('where adb') do set ADB=%%i
if not exist %ADB% (
    echo Failed to find adb.exe in %cd% or PATH >>%EXPLOITLOG%
    set ADB=%ANDROID_HOME%\platform-tools\adb.exe
)
if not exist %ADB% (
    echo Failed to find adb.exe in ANDROID_HOME >>%EXPLOITLOG%
    set ADB=%LOCALAPPDATA%\Android\sdk\platform-tools\adb.exe
)
if not exist %ADB% (
    echo Failed to find adb.exe in AppData >>%EXPLOITLOG%
    set ADB=%ProgramFiles^(x86^)%\Android\android-sdk\platform-tools\adb.exe
)
if not exist %ADB% (
    echo Failed to find adb.exe in Program Files ^(x86^) >>%EXPLOITLOG%
    set ADB=%PROGRAMFILES%\Android\android-sdk\platform-tools\adb.exe
)
if not exist %ADB% (
    echo Failed to find adb.exe in Program Files >>%EXPLOITLOG%
    set ADB=C:\Android\platform-tools\adb.exe
)
if not exist %ADB% (
    echo Failed to find adb.exe in C:\Android >>%EXPLOITLOG%
    set ADB=C:\android-sdk\platform-tools\adb.exe
)
if not exist %ADB% (
    echo Failed to find adb.exe in C:\android-sdk >>%EXPLOITLOG%
    set ADB=C:\adb\platform-tools\adb.exe
)
if not exist %ADB% (
    echo Failed to find adb.exe in C:\adb >>%EXPLOITLOG%
    echo FAILED!
    echo.
    echo Could not locate adb.exe. Please ensure that it is installed properly.
    pause
    goto tomenu
)
echo SUCCESS!
echo adb.exe found at "%ADB%" >>%EXPLOITLOG%
echo Version info: >>%EXPLOITLOG%
%ADB% version >>%EXPLOITLOG% 2>&1

:scan

<nul set /p= Looking for ADB device...                                       
%ADB% kill-server >nul 2>&1 || (echo FAILED! & echo Could not run adb.exe...)
%ADB% devices >nul 2>&1

set ANDROID_SERIAL=""
for /f "tokens=1,2,3" %%i in ('%ADB% devices -l') do (
    if not "%%i"=="List" (
        if "%%j"=="unauthorized" (echo UNAUTHORIZED & goto modelcheck)
        set ANDROID_SERIAL=%%i
        for /f "tokens=2 delims=:" %%n in ("%%k") do echo %%n
        set MODEL=%%k
        goto modelcheck
    )
)

:modelcheck

if %ANDROID_SERIAL%=="" (
    echo.
    echo Failed to find your V20!
    echo.
    echo Did you remember to plug in the device?
    echo Is your V20 set to "always allow" this computer to connect to ADB? ^(see: http://i.imgur.com/wgDZmRJ.png^)
    echo Are you using a recent version of ADB?
    echo.
    echo Press Ctrl-C to quit, or any other key to retry.
    pause
    echo.
    goto scan
)

set ADB=%ADB% -s %ANDROID_SERIAL%

if "%MODEL%"=="product:elsa_tmo_us" goto unlockcheck

echo.
echo This device doesn't look like a T-mobile V20. Proceed anyway? ^(DANGEROUS!^)
set response=""
set /p response=^(Y/N^) %=%
if /i "%response%"=="n" goto tomenu
if /i "%response%"=="y" goto unlockcheck
goto scan

:unlockcheck

set response=""

<nul set /p= Checking unlock status...                                       
for /f "tokens=1 delims= " %%i in ('%ADB% shell getprop ro.boot.bl_unlock_complete') do (
    set unlocked=%%i
)
if not "%unlocked%"=="true" (
    echo FAILED!
    echo.
    echo Your device does not appear to be unlocked.
    echo Please boot into fastboot mode and run:
    echo fastboot oem unlock
    echo From your computer, then try again.
    echo http://i.imgur.com/2BhNatP.png
    goto tomenu
)
echo SUCCESS!
echo.
echo Using device with serial %ANDROID_SERIAL%

if "%mode%"=="5" goto superuser
if "%mode%"=="6" goto getbackups
if "%mode%"=="8" goto optcrypt
if "%mode%"=="9" (
    echo.
    echo Rebooting to recovery... please wait...
    %ADB% reboot recovery
    goto tomenu
)
goto push

:push

echo.
echo - - - Pushing exploit to %TARGET%/recowvery - - -
echo.

<nul set /p= Copying files...                                                
echo Pushing exploit >>%EXPLOITLOG%
%ADB% shell rm -rf %TARGET%/recowvery >nul
%ADB% push %SRC% %TARGET%/recowvery >>%EXPLOITLOG% 2>&1
%ADB% shell test -e %TARGET%/recowvery/recowvery.sh || (
    echo FAILED!
    echo.
    echo Could not write to /data/local/tmp/.
    echo Please check the directory permsisions and delete
    echo any files or folders named "recowvery" if needed.
    goto tomenu
)
echo SUCCESS!

:run

echo.
echo - - - Launching Recowvery on device - - -
echo.

if "%mode%"=="1" goto exploit-normal
if "%mode%"=="2" goto exploit-permissive
if "%mode%"=="3" goto exploit-only
if "%mode%"=="4" goto flash
if "%mode%"=="7" goto restore

echo Invalid mode... exiting to main menu.
goto tomenu

:exploit-normal
%ADB% shell sh %TARGET%/recowvery/recowvery.sh %NOHASH% && %ADB% wait-for-device 2>nul && %ADB% wait-for-device 2>nul && ^
%ADB% shell sh %TARGET%/recowvery/recowvery.sh --stage1 %NOHASH% && %ADB% wait-for-device 2>nul && %ADB% wait-for-device 2>nul && ^
%ADB% shell sh %TARGET%/recowvery/recowvery.sh --stage2 %NOHASH%
goto installedrec

:exploit-permissive
%ADB% shell sh %TARGET%/recowvery/recowvery.sh %NOHASH% && %ADB% wait-for-device 2>nul && %ADB% wait-for-device 2>nul && ^
%ADB% shell sh %TARGET%/recowvery/recowvery.sh --stage1 %NOHASH% --permissive && %ADB% wait-for-device 2>nul && %ADB% wait-for-device 2>nul && ^
%ADB% shell sh %TARGET%/recowvery/recowvery.sh --stage2 %NOHASH%
goto installedrec

:exploit-only
%ADB% shell sh %TARGET%/recowvery/recowvery.sh %NOHASH% && %ADB% wait-for-device 2>nul && %ADB% wait-for-device 2>nul && ^
%ADB% shell sh %TARGET%/recowvery/recowvery.sh --stage1 --shell %NOHASH% && %ADB% wait-for-device
goto getlogs

:flash
%ADB% shell sh %TARGET%/recowvery/recowvery.sh --flash
goto getlogs

:optcrypt

echo.
echo - - - Flashing no-verity-opt-encrypt - - -
echo.

if not exist %CRYPTZIP% (
    echo Failed to locate a suitable no-verity-opt-encrypt ZIP. Please flash it manually if desired.
)
echo Using %CRYPTZIP%
echo.
pause

%ADB% reboot recovery
echo.
echo Rebooting to recovery to flash no-verity-opt-encrypt.
echo If necessary, please exit the decryption screen when TWRP finishes booting, then continue.
echo.
pause
%ADB% wait-for-recovery 2>nul && %ADB% wait-for-recovery 2>nul
%ADB% push %CRYPTZIP% /cache/recovery/noverity-optcrypt.zip >>%FLASHLOG% 2>&1 && ^
%ADB% shell twrp install /cache/recovery/noverity-optcrypt.zip && ^
%ADB% shell twrp wipe cache && ^
%ADB% reboot
echo.
echo Booting back into system... please wait...
%ADB% wait-for-device

set OPTCRYPT=installed
goto installedrec

:superuser

echo.
echo - - - Flashing Root - - -
echo.

if not exist %SUZIP% (
    echo Failed to locate a suitable superuser ZIP. Please ensure you placed one in:
    echo %ZIPS%
    goto tomenu
)
echo Using %SUZIP%
echo.
pause

%ADB% reboot recovery
echo.
echo Rebooting to recovery to flash superuser.
echo If necessary, please exit the decryption screen when TWRP finishes booting, then continue.
echo.
pause
%ADB% wait-for-recovery 2>nul && %ADB% wait-for-recovery 2>nul
%ADB% push %SUZIP% /cache/recovery/su.zip >>%FLASHLOG% 2>&1 && ^
%ADB% shell twrp install /cache/recovery/su.zip && ^
%ADB% reboot
echo.
echo Booting back into system... please wait...
%ADB% wait-for-device
goto getlogs

:restore
%ADB% shell sh %TARGET%/recowvery/recowvery.sh %NOHASH% && %ADB% wait-for-device 2>nul && %ADB% wait-for-device 2>nul && ^
%ADB% shell sh %TARGET%/recowvery/recowvery.sh --stage1 --restore %NOHASH% && %ADB% wait-for-device 2>nul && %ADB% wait-for-device 2>nul && ^
%ADB% shell sh %TARGET%/recowvery/recowvery.sh --stage2 %NOHASH%
goto getlogs

:installedrec
if "%OPTCRYPT%"=="true" goto optcrypt
echo.
echo All done! Would you like to download your boot and recovery backup images now?
set /p response=^(Y/N^) %=%
if /i "%response%"=="y" set GETBACKUPS=true
goto getlogs

:getlogs
rem Pull whatever we managed to log

%ADB% pull %TARGET%/recowvery/audit.log %~dp0recowvery-audit.log >nul 2>&1
%ADB% pull %TARGET%/recowvery/shell.log %~dp0recowvery-shell.log >nul 2>&1
%ADB% logcat -d > %~dp0recowvery-logcat.log 2>nul
%ADB% shell cat %TARGET%/recowvery/recowvery.log 2>nul >>%EXPLOITLOG%

if "%GETBACKUPS%"=="true" goto getbackups

echo.
echo - - - SAVED LOGS TO %cd%\recowvery-*.log - - -
echo.
goto tomenu

:getbackups
rem Grab any backups taken before the flash

echo.
<nul set /p= Downloading backups...                                          
%ADB% pull /sdcard/stock_recovery.img %~dp0 2>nul >>%EXPLOITLOG% && ^
%ADB% pull /sdcard/stock_recovery.img.sha1 %~dp0 2>nul >>%EXPLOITLOG% && ^
%ADB% pull /sdcard/stock_boot.img %~dp0 2>nul >>%EXPLOITLOG% && ^
%ADB% pull /sdcard/stock_boot.img.sha1 %~dp0 2>nul >>%EXPLOITLOG% && (
    echo SUCCESS!
    echo.
    echo - - - SAVED LOGS AND BACKUPS TO %cd%\ - - -
    echo.
    echo Delete backup images from internal storage?
    set response=""
    set /p response=^(Y/N^) %=%
    if /i "%response%"=="y" (
        %ADB% shell rm /sdcard/stock_recovery.img 2>nul
        %ADB% shell rm /sdcard/stock_recovery.img.sha1 2>nul
        %ADB% shell rm /sdcard/stock_boot.img 2>nul
        %ADB% shell rm /sdcard/stock_boot.img.sha1 2>nul
    )
    goto tomenu
)
echo FAILED!
echo.
echo Could not get backup images from /sdcard/. Please copy them manually.
echo (They may be stuck in /data/local/tmp/recowvery/)

goto tomenu

:sendimg
rem Push a custom recovery to flash at the end of the process
rem TODO: Dead execution path

%ADB% push %customimg% /sdcard/recovery.img

goto tomenu

rem Hi mom

:tomenu

pause
goto mainmenu

:end
