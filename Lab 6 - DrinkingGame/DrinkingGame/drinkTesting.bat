@echo off
REM ------------------------------------------------------------------
REM -- This script runs DrinkingGame.exe repeatedly and automatically
REM -- pipes an "Enter" keypress to it after each execution
REM -- to prevent it from pausing for human interaction.
REM ------------------------------------------------------------------

REM -- Input Validation: Check if all 4 arguments were provided --
if "%4"=="" (
    echo Error: Missing arguments.
    echo.
    echo Usage: %0 [drinkerCount] [bottleCount] [openerCount] [iterations]
    echo Example: %0 10 5 2 20
    goto :EOF
)

REM --               Configuration Section                     --
REM ------------------------------------------------------------------
set EXECUTABLE=..\x64\Debug\DrinkingGame.exe
set drinkerCount=%1
set bottleCount=%2
set openerCount=%3
set ITERATIONS=%4

REM -- Combine the arguments for the executable --
set ARGS=%drinkerCount% %bottleCount% %openerCount%

REM -- Create a dynamic output filename based on test parameters --
set OUTPUT_FILE=output_d%drinkerCount%_b%bottleCount%_o%openerCount%.txt


REM -- Test Execution --
echo Running Automated Drinking Game Test... > %OUTPUT_FILE%
echo Command: %EXECUTABLE% %ARGS% >> %OUTPUT_FILE%
echo Iterations: %ITERATIONS% >> %OUTPUT_FILE%
echo. >> %OUTPUT_FILE%

for /L %%i in (1, 1, %ITERATIONS%) do (
    echo --- Iteration %%i --- >> %OUTPUT_FILE%
    
    REM This command runs the program and pipes a newline (Enter key)
    REM into its input stream to handle the "Pause()" function.
    (echo.) | %EXECUTABLE% %ARGS% >> %OUTPUT_FILE% 2>>&1
    
    echo. >> %OUTPUT_FILE%
)

echo.
echo Test complete.
echo Output saved to %OUTPUT_FILE%
pause

:EOF