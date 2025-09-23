@echo off
REM ------------------------------------------------------------------
REM -- This script automates running the ReservationSystem.exe program.
REM -- It can be run with command-line arguments or without to use defaults.
REM -- It pipes an "Enter" keypress to the program after each execution
REM -- to prevent it from pausing for human interaction.
REM ------------------------------------------------------------------

REM --               Configuration Section                     --
REM ------------------------------------------------------------------

REM -- Input Validation: Check if all 4 arguments were provided --
if "%4"=="" (
    echo No arguments provided, using default values.
    echo.
    set carCount=10
    set pumpCount=2
    set testTime=30
    set ITERATIONS=5
) else (
    echo Using command-line arguments.
    echo.
    set carCount=%1
    set pumpCount=%2
    set testTime=%3
    set ITERATIONS=%4
)

REM -- IMPORTANT: You may need to change this path to match your project's output directory.
set EXECUTABLE=..\x64\Debug\ReservationSystem.exe

REM -- Combine the arguments for the executable --
set ARGS=%carCount% %pumpCount% %testTime%

REM -- Create a dynamic output filename based on test parameters --
set OUTPUT_FILE=output_c%carCount%_p%pumpCount%_t%testTime%_i%ITERATIONS%.txt


REM --                   Test Execution                        --
REM ------------------------------------------------------------------
echo Running Automated Gas Station Test... > %OUTPUT_FILE%
echo. >> %OUTPUT_FILE%
echo Configuration: >> %OUTPUT_FILE%
echo  - Cars: %carCount% >> %OUTPUT_FILE%
echo  - Pumps: %pumpCount% >> %OUTPUT_FILE%
echo  - Time (sec): %testTime% >> %OUTPUT_FILE%
echo. >> %OUTPUT_FILE%
echo Command: %EXECUTABLE% %ARGS% >> %OUTPUT_FILE%
echo Iterations: %ITERATIONS% >> %OUTPUT_FILE%
echo. >> %OUTPUT_FILE%

REM -- used to track variation of time between completion
set START_TIME=%TIME%

for /L %%i in (1, 1, %ITERATIONS%) do (
    echo --- Iteration %%i --- >> %OUTPUT_FILE%

    REM This command runs the program and pipes a newline (Enter key)
    REM into its input stream to handle the "pause()" function at the end.
    REM It appends all output (stdout and stderr) to the log file.
    (echo.) | %EXECUTABLE% %ARGS% >> %OUTPUT_FILE% 2>>&1
      
    echo. >> %OUTPUT_FILE%
)

REM -- formating and calculation of time passed after program completed
set TOTAL_END_TIME=%TIME%
echo. >> %OUTPUT_FILE%
echo --- TIMING RESULTS --- >> %OUTPUT_FILE%
powershell -Command "$ts = New-TimeSpan -Start '%START_TIME%' -End '%END_TIME%'; Write-Output ('{0:00}:{1:00}.{2:000}' -f $ts.Minutes, $ts.Seconds, $ts.Milliseconds)" >> %OUTPUT_FILE%

echo.
echo Test complete.
echo Output saved to %OUTPUT_FILE%
pause

:EOF