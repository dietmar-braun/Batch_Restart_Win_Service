@echo off

REM set service as variable, %~1 = passed from the task planner
set ServiceName=%~1
set ForceRestart=%~2
SC queryex "%ServiceName%" | find "STATE" | find /v "RUNNING" >nul && (
    echo "%ServiceName%" not running
    echo Start "%ServiceName%"

    net start "%ServiceName%" >nul || (
        echo "%ServiceName%" wont start 
        exit /b 1
    )
    echo "%ServiceName%" started
    exit /b 0
) || (
	
    echo "%ServiceName%" running and working
	echo Force Restart "%ForceRestart%"
	IF "%ForceRestart%" =="1" (
	
		net stop "%ServiceName%" >nul || (
			echo Service could not be stopped. use taskkill.
			taskkill /F /FI "SERVICES eq %ServiceName%"
		)
		
		net start "%ServiceName%"
	)
    exit /b 0
)
