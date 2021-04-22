@ECHO OFF

REM Load default values...
SET pool=eu1.ethermine.org:4444
SET protocol=stratum1+tcp
SET wallet=0xf089E7f956F0bCE27Fad4E2dFaEe25bF81fDBd4d
SET workername=default
SET restart=false
SET restartTimeout=60
REM Possible logging values: all, none, file, file_append
SET logging=all

REM Load configuration file
FOR /f "delims=" %%x IN (miner.cfg) DO (SET "%%x")

REM Validate logging settings
FOR %%G IN ( "all" "none" "file" "file_append" ) DO (
	IF /I "%logging%"=="%%~G" GOTO LOGGING_OK
)
SET logging=all
:LOGGING_OK

if [%logging%] == [none] (
	SET _miner_output=^> NUL
) ELSE IF [%logging%] == [file] (
	SET _miner_output=^> miner.log
) ELSE IF [%logging%] == [file_append] (
	SET _miner_output=^>^> miner.log
)

REM Set internal variables
SET _version=0.2
SET _miner_app=ethminer.exe
SET _miner_args=-R -P %protocol%://%wallet%.%workername%@%pool%
SET _start_after=10

TITLE Ethminer-Script v%_version%

ECHO #-------------------------------------------
ECHO # Configuration:
ECHO #-------------------------------------------
ECHO # Pool: %pool%
ECHO # Protocol: %protocol%
ECHO # Wallet: %wallet%
ECHO # Workername: %workername%
ECHO # Restart on failure: %restart%
ECHO # Restart timeout: %restartTimeout%
ECHO # Logging: %logging%
ECHO #-------------------------------------------
ECHO #
ECHO # Starting miner in 10 Seconds... Abort(Close or Ctrl + C) when settings are wrong 
ECHO #

TIMEOUT /t %_start_after% /nobreak > NUL

ECHO Starting miner!

:START_MINER
%_miner_app% %_miner_args% %_miner_output%
IF [%restart%] == [true] (
	ECHO Restarting miner in %restartTimeout% seconds...
	TIMEOUT /t %restartTimeout% /nobreak > NUL
	GOTO START_MINER
)

ECHO Miner-Script closed!
