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

timeout /t 10 /nobreak > NUL

ECHO Starting miner!

:START_MINER
ethminer.exe -R -P %protocol%://%wallet%.%workername%@%pool%
IF [%restart%] == [true] (
	ECHO Restarting miner in %restartTimeout% seconds...
	timeout /t %restartTimeout% /nobreak > NUL
	GOTO START_MINER
)

ECHO Miner closed!