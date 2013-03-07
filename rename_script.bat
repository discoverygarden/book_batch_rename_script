@echo off
SETLOCAL ENABLEDELAYEDEXPANSION
echo *****************************************************************************
echo *                    ISLANDORA BOOK BATCH RENAME SCRIPT                     *
echo *                                                                           *
echo * This batch script takes a folder full of book files and sorts them into   *
echo * a folder that can be uploaded to the server staging area to be ingested.  *
echo * It requires every .tif page to be paired with a .dng negative. It also    *
echo * accepts the first .mrc and .xml metadata file it finds, and adds in any   *
echo * files containing the word 'colourchecker'. Only put in one .xml or .mrc.  *
echo *                                                                           *
echo * Make sure all the tif/dng files are in alphabetical, NOT numerical order. *
echo * This means that instead of 1.tif, ... 9.tif, 10.tif, the files should be  *
echo * be named 001.tif, ... 009.tif, 010.tif; otherwise those pages would be    *
echo * sorted as 1.tif, 10.tif, ...9.tif. Also, again, make sure each .tif has a *
echo * matching .dng file.                                                       *
echo *                                                                           *
echo * Once complete, the created folder needs to be placed in the staging area  *
echo * of the server (/usr/local/fedora/staging). The metadata file should be    *
echo * uploaded last.                                                            *
echo *****************************************************************************
pause
:: Ask for the book name
set /p book="Name of book: "
mkdir "%book%"
:: Throw in the first XML found
for /f "tokens=1" %%x in ('dir /b *.xml') do (
	move *.xml "!book!"
	)
:: Move over all colourchecker files
for /f %%c in ('dir /b *colourchecker*') do (
	move *colourchecker* "!book!"
	)
:: Throw in the first MARC binary found
for /f %%m in ('dir /b *.mrc') do (
	move *.mrc "!book!"
	)
:: Set folder count
set /a c=1
:: Move over .tiffs
for /f "tokens=*" %%t in ('dir /b *.tif*') do (
	mkdir !c!
	rename "%%t" OBJ.tif
	move OBJ.tif !c!
	move !c! "!book!"
	set /a c=c+1
	)
:: Move over .dngs
set /a c=1
for /f "tokens=*" %%d in ('dir /b *.dng') do (
	rename "%%d" DNG.dng
	move DNG.dng "!book!"/!c!
	set /a c=c+1
	)
ENDLOCAL
