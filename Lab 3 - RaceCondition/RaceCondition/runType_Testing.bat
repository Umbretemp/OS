@echo off
REM ------------------------------------------------------------------
REM -- This script runs RaceCondition.exe with configurable arguments.
REM --
REM -- Usage:
REM --   run_test.bat [threadCount] [stringLength] [numStrings] [runType] [iterations]
REM --
REM -- Example:
REM --   run_test.bat 4 30 5 1 10
REM ------------------------------------------------------------------

REM -- Input Validation: Check if all 5 arguments were provided --
if "%5"=="" (
    echo Error: Missing arguments.
    echo.
    echo Usage: %0 [threadCount] [stringLength] [numStrings] [runType] [iterations]
    echo Example: %0 4 30 5 1 10
    goto :EOF
)

REM -- Configuration from Command-Line Arguments --
set EXECUTABLE=..\x64\Debug\RaceCondition.exe
set threadCount=%1
set stringLength=%2
set numStrings=%3
set runType=%4
set ITERATIONS=%5

REM -- Combine the first four arguments for the executable --
set ARGS=%threadCount% %stringLength% %numStrings% %runType%

REM -- Create a dynamic output filename based on the runType --
set OUTPUT_FILE=output_runtype_%runType%.txt

REM -- Test Execution --
echo Running Test for runType %runType%... > %OUTPUT_FILE%
echo Command: %EXECUTABLE% %ARGS% >> %OUTPUT_FILE%
echo Iterations: %ITERATIONS% >> %OUTPUT_FILE%
echo. >> %OUTPUT_FILE%

for /L %%i in (1, 1, %ITERATIONS%) do (
    echo --- Iteration %%i --- >> %OUTPUT_FILE%
    (echo.) | %EXECUTABLE% %ARGS% >> %OUTPUT_FILE% 2>>&1
    echo. >> %OUTPUT_FILE%
)

echo Test complete. Output saved to %OUTPUT_FILE%
pause

:EOF