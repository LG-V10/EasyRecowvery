# EasyRecowvery
A collection of scripts to install @jcadduono's [Recowvery](https://github.com/jcadduono/android_external_dirtycow).
Please see his original thread @ [[H918] recowvery, unlock your V20 root shell - now with TWRP!](http://forum.xda-developers.com/v20/development/h918-recowvery-unlock-v20-root-shell-t3490594) for more information, and don't forget to thank him any way you can!

## Disclaimer

WARNING: ATTEMPT AT YOUR OWN RISK! THIS PACKAGE IS RELEASED AS-IS AND WITHOUT ANY WARRANTY, IMPLIED OR EXPRESSED

THIS PACKAGE MAY MAKE YOUR LIFE EASIER (or harder) BUT NOTHING CAN FULLY PROTECT YOU FROM TROUBLE WHEN ROOTING A DEVICE!

IT IS NOT MY RESPONSIBILITY IF YOU END UP WITH A BRICK IN YOUR POCKET AFTER ATTEMPTING ROOT

## Features
With this package, you can accomplish the following:
- Install TWRP and root in just a couple of clicks
- Optionally set selinux to Permissive mode
- Back up and restore boot and recovery partitions
- Get a root shell in Permissive mode without flashing anything
- Much more to come!

## Installation & Usage
1. Download the latest ZIP from [GitHub](https://github.com/bziemek/EasyRecowvery/releases) and extract it to your Dekstop or the like
2. Put the recovery of your choosing (i.e. [TWRP 3.0.2-0-rc8](https://build.nethunter.com/test-builds/twrp/lge/twrp-3.0.2-0-rc8-h918.img)) on your internal storage, and rename it to recovery.img
3. Put the latest no-verity-opt-encrypt.zip (i.e. [4.1](https://build.nethunter.com/android-tools/no-verity-opt-encrypt/no-verity-opt-encrypt-4.1.zip)) in the "zips" folder
4. If you want to install SuperSU using this script, put that ZIP in the "zips" folder as well.
5. Run EasyRecowvery.cmd and follow the prompts
6. Profit!

## Tips:
- In 99% of cases, you will need to run Format Data the first time you enter TWRP. This will erase everything on your Internal Storage!
- If you're having ADB problems, try dragging "adb.exe", "AdbWinApi.dll", and "AdbWinUsbApi.dll" into the folder with EasyRecowvery.
- You may want to Run as Administrator if you encounter permission errors.
- Sometimes things like this work better if you try them a second time, so I do recommend trying twice.
- Please provide your log files and/or screenshots when reporting issues.
- If you end up in a bootloop and are using TWRP > 3.0.2.0-beta5, you can enter recovery by using the factory reset hardware key combo.

## Todo & Known Issues
Host script can't tell if the flash failed. A check for this is under development.
If ADB crashes or restarts during the process, the host script may fail to complete.
Some of the latest changes and additions have sloppy output or logging.
TODO: Remember more of the things.

## Donations
PayPal: bezeek@gmail.com
BTC: 1bu5MMgagtbN7QVeciyWfAzRbfk8vmynM
