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
1. Download the ZIP from [GitHub](https://github.com/bziemek/EasyRecowvery/archive/master.zip) and extract it to a directory of your choosing
2. Put the recovery of your choosing (i.e. [this one](https://build.nethunter.com/test-builds/twrp/lge/twrp-3.0.2-0-beta12-h918.img)) on your internal storage, and rename it to recovery.img
3. Put the latest no-verity-opt-encrypt.zip (i.e. [4.0](https://build.nethunter.com/android-tools/no-verity-opt-encrypt/no-verity-opt-encrypt-4.0.zip)) in the "zips" folder
4. If you want to install SuperSU using this script, put that ZIP in the "zips" folder as well.
5. Run EasyRecowvery.cmd and follow the prompts
6. Profit!

## Tips:
- If you're having ADB problems, try dragging "adb.exe", "AdbWinApi.dll", and "AdbWinUsbApi.dll" into the folder with EasyRecowvery.
- You may want to Run as Administrator to avoid permission errors.
- Sometimes things like this work better if you try them a second time, so I do recommend trying twice.
- Please provide your log files and/or screenshots when reporting issues.

## Todo & Known Issues
Host script can't tell if the flash failed. A check for this is under development.
If ADB crashes or restarts during the process, the host script may fail to complete.
Some of the latest changes and additions have sloppy output or logging.
TODO: Remember more of the things.

## Donations
PayPal: bezeek@gmail.com
BTC: 1bu5MMgagtbN7QVeciyWfAzRbfk8vmynM
