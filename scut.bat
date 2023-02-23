@echo off

set _paths=""
set _alias=%1
set _destination=""
set _db_name=%HOMEDRIVE%%HOMEPATH%\AppData\Roaming\scut-db.txt
set _temp_db_name=%HOMEDRIVE%%HOMEPATH%\AppData\Roaming\scut-db-temp.txt

IF not exist %_db_name% type nul > %_db_name%

call :readConfig

IF "%1"=="" goto :USAGE
IF "%1"=="-l" goto :LIST
IF "%1"=="-o" goto :OPEN
IF "%1"=="-a" goto :ADD
IF "%1"=="-d" goto :REMOVE

call :consume "%_paths%"

IF %_destination%=="" (
  echo ERROR: Path "%1" Not Found
) else (
  cd "%_destination%"
)

goto :EOF

:consume
rem echo Path is %~1
for /f "tokens=1,* delims=+" %%a in ("%~1") do (
  rem echo %%a THEN %%b

  for /f "tokens=1-2 delims=@" %%c in ("%%a") do (
    rem echo %_alias% %%c %%d 
    IF "%~2"=="list" (
      echo.
      echo %%c "->" %%d 
      echo. 
    )
    
    IF "%_alias%"=="%%c" (
      set _destination="%%d"
    )
  )
  
  IF "%%b" NEQ """" (
    rem echo Recursing With %%b
    call :consume "%%b" %2
  )
    
)
goto :EOF

:readConfig
set _excludeAlias=%~1

for /f "tokens=*" %%a in (%_db_name%) do (
  rem echo Line--- %%a
  IF "%_excludeAlias%" NEQ "" (

    for /f "tokens=1-2 delims=@" %%d in ("%%a") do (
      rem echo LineB--- %%d %_excludeAlias%
      IF "%%d" NEQ "%_excludeAlias%" (
        rem echo Adding---- %%a
        echo %%a >> %_temp_db_name%
      )
    )
  ) else (
    rem echo Adding---- %%a
    call :addPath "%%a"
  ) 
  
)
goto :EOF

:LIST
call :consume "%_paths%" "list"
goto :EOF

:OPEN
set _alias=%2
call :consume "%_paths%" 
explorer.exe %_destination%
goto :EOF

:ADD
set _alias=%2
call :consume "%_paths%" 

IF %_destination% NEQ "" (
  echo ERROR: Alias "%2" Already Exists
) else (
  
  IF "%~3"=="""" (
    echo ERROR: No Path Given For Alias "%2" 
  ) else (
    echo "%2" Added To Database^! 
    echo %_alias%^@%~3 >> %_db_name%
    
  )
  
)
goto :EOF

:REMOVE

set _paths=""
type nul > %_temp_db_name%
call :readConfig "%2"
type %_temp_db_name% > %_db_name%
echo "%2" Removed From Database^!
if exist %_temp_db_name% del %_temp_db_name%
goto :EOF

:USAGE 
echo.
echo USAGE: %0 [-l^|-d^|-a^|-o] pathalias [pathToAlias]
echo.
echo 'pathalias' is a alias given to a path. 
echo '-l' option will list available path aliases
echo '-o' will open the pathalias in explorer
echo '-d' will remove an alias from database
echo '-a' will add 'pathToAlias' to the database
echo. 
echo 'scut pathalias' will cd into directory pointed to by pathalias
goto :EOF

:addPath

IF "%_paths%"=="""" (
  set _paths=%~1+
  goto :EOF
)

set _paths=%_paths%%~1+
goto :EOF

:EOF