@echo off
rem remove the extra text in the command prompt to make it look cleaner

rem color 8 = grey
color 8

title Zip Password Cracker - time0ut
echo Zip Password Cracker - time0ut
echo Make sure all files are in the your current directory
echo Make sure 7z is installed

rem get the current directory that user is in
set "current_dir=%CD%"
rem asking for inputs
set /p zipfile="Zip File Name: "
call :mistake %zipfile%

set /p wordlist="Password List: "
call :mistake %wordlist%

set /p out="Output File Name: "
set /p threads="Number of Threads (Default 1-5): "

rem set a counter for attempt count
set /a count=1
rem prepand the variable zipfile and out with the current directory
set "zipfile=%current_dir%\%zipfile%"
set "out=%current_dir%\%out%"

rem for loop to try all password on the zip file
for /f %%a in (%wordlist%) do (
	set pass=%%a
	rem invoke attempt each time
	call :attempt
)
rem if non of the password matches, invoke fail
goto fail

rem success function 
rem tell user the password and it was successful
:success
echo [+] Successfully cracked zip file!
echo [+] Password: %pass%
echo [*] Extracting file to %out%...
rem for dramatic effect
timeout /t 2 /nobreak >nul
echo [+] Successfully extracted file
pause
exit

rem fail function
rem tell user they fail
:fail
echo [-] Password not found
echo [*] Get a better dictionary
pause
exit

rem attempt function
rem run command to try to open the zip file using the password from the wordlist
:attempt
"C:\Program Files\7-Zip\7z.exe" x -p"%pass%" -o"%out%" "%zipfile%" >nul 2>&1
echo [-] attempt %count%: %pass%
rem increase count value by one after each attempt
set /a count=%count%+1
rem if there is no error (correct), go to success
if %errorlevel% EQU 0 goto success
rem goto eof just bring the process back from the subroutine
goto :eof

rem mistake function
rem tells the user that they made a mistake
:mistake
if not exist "%1" (
	echo [-] File does not exist!
	pause
	exit
)
goto :eof
