@echo off
SETLOCAL ENABLEDELAYEDEXPANSION
echo *****************************************************************************
echo *                    ISLANDORA BOOK BATCH RENAME SCRIPT                     *
echo *                                                                           *
echo * This batch script takes a folder full of book files and sorts them into   *
echo * a folder that can be uploaded to the server staging area to be ingested.  *
echo * It is compatible with .tif files that are paired with .dng negatives. It  *
echo * accepts the first .mrc and .xml metadata file it finds, and adds in any   *
echo * files containing the word 'colourchecker'. Only put in one .xml or .mrc.  *
echo *                                                                           *
echo * WARNING: CHECK THE DOCUMENTATION FOR INSTRUCTIONS ON HOW TO SORT THE BOOK *
echo * FILES IN PREPARATION FOR USING THIS SCRIPT! MAKE A BACKUP OF THE FILES!   *
echo * INCORRECTLY NAMED FILES WILL CAUSE SEVERE SORTING ERRORS THAT WILL BE     *
echo * EXTREMELY DIFFICULT TO RECOVER FROM! IF YOU ARE NOT SURE THAT YOUR FILES  *
echo * ARE NAMED CORRECTLY, EXIT THIS SCRIPT NOW AND CHECK THE DOCUMENTATION!    *
echo ***************************************************************************** 
pause
:: Ask for the book name
set /p book="Name of book: "
mkdir "%book%"
:: Throw in the first XML found
for /f "tokens=1" %%x in ('dir /b *.xml') do (
	rename "%%x" "--METADATA--.xml"
	move "--METADATA--.xml" "!book!"
	)
:: Move over all colourchecker files
for /f %%c in ('dir /b *colourchecker*') do (
	move *colourchecker* "!book!"
	)
:: Throw in first MARC binary found
for /f %%m in ('dir /b *.mrc') do (
	rename "%%m" "--METADATA--.mrc"
	move "--METADATA--.mrc" "!book!"
	)
:: Set folder count
set /a c=1
:: Move over .tiffs and .dngs
:tiffdngloop
for /f "tokens=*" %%t in ('dir /b *.tif*') do (
	mkdir !c!
	set filenamet=%%~nt
	:: Searches for a matching filename and if found, renames and exits loop
	for /f "tokens=*" %%d in ('dir /b *.dng') do (
		set filenamed=%%~nd
		if "!filenamet!"=="!filenamed!" (
			rename "%%t" OBJ.tif
			move OBJ.tif "!c!"
			rename "%%d" DNG.dng
			move DNG.dng "!c!"
			move "!c!" "!book!"
			set /a c=c+1
			goto tiffdngloop
			)
		)
	rename "%%t" OBJ.tif
	move OBJ.tif "!c!"
	move "!c!" "!book!"
	set /a c=c+1
	)
ENDLOCAL
