@echo off

taskkill /f /im Steam.exe /t
taskkill /F /IM "Fivem.exe"
taskkill /F /IM "Steam.exe"
taskkill /F /IM "EpicGamesLauncher.exe"

for /f "delims=" %%G in ('powershell -Command "[guid]::NewGuid().ToString()"') do set "NewGuid=%%G"
echo Novo MachineGuid gerado: %NewGuid%
set "RegPath=HKLM\SOFTWARE\Microsoft\Cryptography"
reg add "%RegPath%" /v MachineGuid /d "%NewGuid%" /f

set reg_key_path=HKEY_CURRENT_USER\Software\Microsoft\Internet Explorer\LowRegistry\Audio\PolicyConfig\PropertyStore

reg delete "%reg_key_path%" /f

set "FIVEM_APP_DIR=%localappdata%\fivem\fivem.app"
rmdir /s /q "%localappdata%\D3DSCache"
del /q /s /f "%FIVEM_APP_DIR%\crashes\*.*"
rmdir /s /q "%FIVEM_APP_DIR%\crashes"
del /q /s /f "%FIVEM_APP_DIR%\logs\*.*"
rmdir /s /q "%FIVEM_APP_DIR%\logs"
rmdir /s /q "%appdata%\CitizenFX\kvs"
del /q /s /f "%appdata%\CitizenFX\*.dat*"
del /q /s /f "%FIVEM_APP_DIR%\*.*"

del /s /f /q %userprofile%\AppData\Local\FiveM\FiveM.app\logs
del /s /f /q %userprofile%\AppData\Local\FiveM\FiveM.app\crashes
del /s /f /q %userprofile%\AppData\Local\FiveM\FiveM.app\data\cache
del /s /f /q %userprofile%\AppData\Local\FiveM\FiveM.app\data\nui-storage
del /s /f /q %userprofile%\AppData\Local\FiveM\FiveM.app\data\server-cache
del /s /f /q %userprofile%\AppData\Local\FiveM\FiveM.app\data\server-cache-priv
del /s /f /q %userprofile%\AppData\Local\FiveM\FiveM.app\plugins

powershell -Command "& {Get-AppxPackage -AllUsers xbox | Remove-AppxPackage}"
sc stop XblAuthManager
sc stop XblGameSave
sc stop XboxNetApiSvc
sc stop XboxGipSvc
sc delete XblAuthManager
sc delete XblGameSave
sc delete XboxNetApiSvc
sc delete XboxGipSvc
reg delete "HKLM\SYSTEM\CurrentControlSet\Services\xbgm" /f
schtasks /Change /TN "Microsoft\XblGameSave\XblGameSaveTask" /disable
schtasks /Change /TN "Microsoft\XblGameSave\XblGameSaveTaskLogon" /disableL
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\GameDVR" /v AllowGameDVR /t REG_DWORD /d 0 /f
cls
set hostspath=%windir%\System32\drivers\etc\hosts
echo 127.0.0.1 xboxlive.com >> %hostspath%
echo 127.0.0.1 user.auth.xboxlive.com >> %hostspath%
echo 127.0.0.1 presence-heartbeat.xboxlive.com >> %hostspath%

REG DELETE "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\MSLicensing\HardwareID" /f
REG DELETE "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\MSLicensing\Store" /f
REG DELETE "HKEY_CURRENT_USER\Software\WinRAR\ArcHistory" /f
REG DELETE "HKEY_LOCAL_MACHINE\SYSTEM\ControlSet001\Services\bam\State\UserSettings\S-1-5-21-1282084573-1681065996-3115981261-1001" /va /f
REG DELETE "KEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\FeatureUsage\ShowJumpView" /f
REG DELETE "KEY_CURRENT_USER\Software\Classes\Local Settings\Software\Microsoft\Windows\Shell\MuiCache" /f
REG DELETE "HKEY_CURRENT_USER\Software\WinRAR\ArcHistory" /f
REG DELETE "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\FeatureUsage\AppSwitched" /f
REG DELETE "HKEY_CLASSES_ROOT\Local Settings\Software\Microsoft\Windows\Shell\MuiCache" /f
REG DELETE "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\FeatureUsage\ShowJumpView" /f
REG DELETE "HKEY_LOCAL_MACHINE\SYSTEM\ControlSet001\Services\bam\State\UserSettings\S-1-5-21-332004695-2829936588-140372829-1002" /f
REG DELETE "HKEY_CLASSES_ROOT\Local Settings\Software\Microsoft\Windows\Shell\MuiCache" /f
REG DELETE "HKEY_CURRENT_USER\Software\Classes\Local Settings\Software\Microsoft\Windows\Shell\MuiCache" /f
REG DELETE "HKEY_CURRENT_USER\Software\Microsoft\Windows NT\CurrentVersion\AppCompatFlags\Compatibility Assistant\Store" /f
REG DELETE "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\FeatureUsage\AppSwitched" /f
REG DELETE "HKEY_LOCAL_MACHINE\SYSTEM\ControlSet001\Services\bam\State\UserSettings\S-1-5-21-1282084573-1681065996-3115981261-1001" /f
REG DELETE "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\FeatureUsage\AppSwitched" /f


