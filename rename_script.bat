@echo off
SETLOCAL ENABLEDELAYEDEXPANSION
echo *****************************************************************************
echo *                    ISLANDORA BOOK BATCH RENAME SCRIPT                     *
echo *                                                                           *
echo * This batch script places a folder full of .tif files/ into a folder that   *
echo * can be ingested using the Book Batch module. It is intended to be placed  *
echo * in and run from the folder where the .tif files to be sorted are.         *
echo *                                                                           *
echo * Make sure all the .tif files are in alphabetical, NOT numerical order.    *
echo * This means that instead of 1.tif, ... 9.tif, 10.tif, the files should be  *
echo * be named 001.tif, ... 009.tif, 010.tif; otherwise those pages would be    *
echo * sorted as 1.tif, 10.tif, ...9.tif                                         *
echo *                                                                           *
echo * Once complete, the created folder needs to be placed in the root          *
echo * directory of a .zip file, NOT compressed into its own .zip file. The .zip *
echo * file does not need a special name.                                        *
echo *****************************************************************************
pause
set /p book="Name of book: "
mkdir "%book%"
for /f %%i in ('dir /b *.xml') do (
	move *.xml "!book!"
	)
for /f %%i in ('dir /b *.mrc') do (
	move *.mrc "!book!"
	)
set /a c=1
for /f "tokens=*" %%f in ('dir /b *.tif*') do (
	mkdir !c!
	rename "%%f" OBJ.tif
	move OBJ.tif !c!
	move !c! "!book!"
	set /a c=c+1
	)
ENDLOCAL
