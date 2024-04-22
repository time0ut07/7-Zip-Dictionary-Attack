@echo off
:: remove the extra text in the command prompt to make it look cleaner

:: color 8 = grey
color 8

title Zip Password Cracker - time0ut
echo Zip Password Cracker - time0ut
echo Make sure all files are in the your current directory
echo Make sure 7z is installed

:: get the current directory that user is in
set "current_dir=%CD%"
:: asking for inputs
set /p zipfile="Zip File Name: "
call :mistake %zipfile%

set /p wordlist="Password List: "
call :mistake %wordlist%

set /p out="Output File Name: "

:: set a counter for attempt count
set /a count=1
:: prepand the variable zipfile and out with the current directory
set "zipfile=%current_dir%\%zipfile%"
set "out=%current_dir%\%out%"

:: for loop to try all password on the zip file
for /f %%a in (%wordlist%) do (
	set pass=%%a
	rem invoke attempt each time
	call :attempt
)
:: if non of the password matches, invoke fail
goto fail

:: success function 
:: tell user the password and it was successful
:success
echo [+] Successfully cracked zip file!
echo [+] Password: %pass%
echo [*] Extracting file to %out%...
:: for dramatic effect
timeout /t 2 /nobreak >nul
echo [+] Successfully extracted file
pause
exit

:: fail function
:: tell user they fail
:fail
echo [-] Password not found
echo [*] Get a better dictionary
pause
exit

:: attempt function
:: run command to try to open the zip file using the password from the wordlist
:attempt
"C:\Program Files\7-Zip\7z.exe" x -p"%pass%" -o"%out%" "%zipfile%" >nul 2>&1
echo [-] attempt %count%: %pass%
:: increase count value by one after each attempt
set /a count=%count%+1
:: if there is no error (correct), go to success
if %errorlevel% EQU 0 goto success
:: goto eof just bring the process back from the subroutine
goto :eof

:: mistake function
:: tells the user that they made a mistake
:mistake
if not exist "%1" (
	echo [-] File does not exist!
	pause
	exit
)
goto :eof
