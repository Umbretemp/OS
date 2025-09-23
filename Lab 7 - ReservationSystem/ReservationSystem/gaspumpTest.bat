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
    set ITERATIONS=1
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

REM -- CAPTURE TOTAL START TIME --
set TOTAL_START_TIME=%TIME%

for /L %%i in (1, 1, %ITERATIONS%) do (
    call :RunAndLogTime %%i
)

REM -- CAPTURE TOTAL END TIME AND CALCULATE DURATION --
set TOTAL_END_TIME=%TIME%
echo. >> %OUTPUT_FILE%
echo --- TOTAL TIMING RESULTS --- >> %OUTPUT_FILE%
echo Total Execution Time (min:sec:ms) >> %OUTPUT_FILE%
powershell -Command "$ts = New-TimeSpan -Start '%TOTAL_START_TIME%' -End '%TOTAL_END_TIME%'; Write-Output ('{0:00}:{1:00}.{2:000}' -f $ts.Minutes, $ts.Seconds, $ts.Milliseconds)" >> %OUTPUT_FILE%

echo.
echo Test complete.
echo Output saved to %OUTPUT_FILE%
goto :EOF

REM -----------------------------------------------------------
REM -- SUBROUTINE for running and timing a single iteration  --
REM -----------------------------------------------------------
:RunAndLogTime
echo --- Iteration %1 --- >> %OUTPUT_FILE%

set ITERATION_START_TIME=%TIME%
(echo.) | %EXECUTABLE% %ARGS% >> %OUTPUT_FILE% 2>>&1
set ITERATION_END_TIME=%TIME%

echo Iteration Duration (min:sec:ms) >> %OUTPUT_FILE%
powershell -Command "$ts = New-TimeSpan -Start '%ITERATION_START_TIME%' -End '%ITERATION_END_TIME%'; Write-Output ('{0:00}:{1:00}.{2:000}' -f $ts.Minutes, $ts.Seconds, $ts.Milliseconds)" >> %OUTPUT_FILE%

echo. >> %OUTPUT_FILE%
goto :EOF