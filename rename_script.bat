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
echo * This script will ask you for the name of the book and make a copy of all  *
echo * your files into a folder with the name of the book you gave. It will also *
echo * keep the originals in the folder they were in. Please make sure there is  *
echo * enough space for the script to make duplicates of all the book files.     *
echo *                                                                           *
echo * PLEASE CHECK THE DOCUMENTATION FOR INSTRUCTIONS ON HOW TO NAME YOUR FILES *
echo * BEFORE RUNNING THIS SCRIPT. The script cannot check for mistakes in the   *
echo * original filenames and will sort indiscriminately. If you notice files    *
echo * sorted incorrectly in the new directory, remove it, check your file names *
echo * and try again. Otherwise, you may remove the originals if you wish.       *
echo *****************************************************************************
pause
:: Ask for the book name
set /p book="Name of book: "
mkdir "%book%"
mkdir "%book%"_tmp
:: Throw in the first XML found
if exist *.xml (
	echo XML found, processing ...
	copy *.xml --METADATA--.xml
	move --METADATA--.xml "!book!"
	move "%%x" "!book!"_tmp
	)
:: Throw in first MARC binary found
if exist *.mrc (
	echo MARC Binary found, processing ...
	copy *.mrc --METADATA--.mrc
	move --METADATA--.mrc "!book!"
	move "%%m" "!book!"_tmp
	)
:: Move over all colourchecker files
if exist *colourchecker* (
	echo Colourchecker[s] found, processing ...
	copy *colourchecker* "!book!"
	move *colourchecker* "!book!"_tmp
	)
:: Set folder count
set /a c=1
:: Move over .tiffs and .dngs
for /f "tokens=*" %%t in ('dir /b *.tif' 'dir /b *.tiff' 'dir /b *.TIF' 'dir /b *.TIFF') do (
	mkdir "!book!"\!c!
	set filenamet=%%~nt
	:: Searches for a matching filename and if found, renames and exits loop
	echo "!filenamet!"
	if exist "!filenamet!".dng (
		set d="!filenamet!".dng
		copy "%%t" "!book!"\!c!\OBJ.tif
		copy !d! "!book!"\!c!\DNG.dng
		move "%%t" "!book!"_tmp
		move !d! "!book!"_tmp
	) else (
		copy "%%t" "!book!"\!c!\OBJ.tif
		move "%%t" "!book!"_tmp
		)
	set /a c=c+1
	)
move "!book!"_tmp\*.* .\
rmdir "!book!"_tmp
pause
ENDLOCAL
