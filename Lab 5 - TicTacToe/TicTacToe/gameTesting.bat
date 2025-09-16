@echo off
REM ------------------------------------------------------------------
REM -- This script runs TicTacToe.exe with configurable arguments.
REM --
REM -- Usage:
REM --   run_tictactoe_tests.bat [gameCount] [playerCount] [iterations]
REM --
REM -- Example:
REM --   run_tictactoe_tests.bat 5 10 3
REM ------------------------------------------------------------------

REM -- Input Validation: Check if all 3 arguments were provided --
if "%3"=="" (
    echo Error: Missing arguments.
    echo.
    echo Usage: %0 [gameCount] [playerCount] [iterations]
    echo Example: %0 5 10 3
    goto :EOF
)

REM -- Configuration from Command-Line Arguments --
set EXECUTABLE=..\x64\Debug\TicTacToe.exe
set gameCount=%1
set playerCount=%2
set ITERATIONS=%3

REM -- Combine the arguments for the executable --
set ARGS=%gameCount% %playerCount%

REM -- Create a dynamic output filename based on test parameters --
set OUTPUT_FILE=output_games_%gameCount%_players_%playerCount%.txt

REM -- Test Execution --
echo Running Tic-Tac-Toe Test... > %OUTPUT_FILE%
echo Command: %EXECUTABLE% %ARGS% >> %OUTPUT_FILE%
echo Iterations: %ITERATIONS% >> %OUTPUT_FILE%
echo. >> %OUTPUT_FILE%

for /L %%i in (1, 1, %ITERATIONS%) do (
    echo --- Iteration %%i --- >> %OUTPUT_FILE%
    %EXECUTABLE% %ARGS% >> %OUTPUT_FILE% 2>>&1
    echo. >> %OUTPUT_FILE%
)

echo Test complete.
echo Output saved to %OUTPUT_FILE%
pause

:EOF