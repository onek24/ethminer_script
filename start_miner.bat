@ECHO OFF

REM Load default values...
SET pool=eu1.ethermine.org:4444
SET protocol=stratum1+tcp
SET wallet=0xf089E7f956F0bCE27Fad4E2dFaEe25bF81fDBd4d
SET workername=default
SET restart=false
SET restartTimeout=60

REM Load configuration file
FOR /f "delims=" %%x IN (miner.cfg) DO (SET "%%x")

REM Set variables
SET _version=0.1
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
ECHO #-------------------------------------------
ECHO #
ECHO # Starting miner in 10 Seconds... Abort(Close or Ctrl + C) when settings are wrong 
ECHO #

timeout /t %_start_after% /nobreak > NUL

ECHO Starting miner!

:START_MINER
%_miner_app% %_miner_args%
IF [%restart%] == [true] (
	ECHO Restarting miner in %restartTimeout% seconds...
	timeout /t %restartTimeout% /nobreak > NUL
	GOTO START_MINER
)

ECHO Miner-Script closed!