#!/bin/bash

echo "*****************************************************************************"
echo "* ISLANDORA BOOK BATCH RENAME SCRIPT                                        *"
echo "*                                                                           *"
echo "* This batch script takes a folder full of book files and sorts them into   *"
echo "* a folder that can be uploaded to the server staging area to be ingested.  *"
echo "* It is compatible with .tif files that are paired with .dng negatives. It  *"
echo "* accepts the first .mrc and .xml metadata file it finds, and adds in any   *"
echo "* files containing the word 'colourchecker'. Only put in one .xml or .mrc.  *"
echo "*                                                                           *"
echo "* This script will ask you for the name of the book and make a copy of all  *"
echo "* your files into a folder with the name of the book you gave. It will also *"
echo "* keep the originals in the folder they were in. Please make sure there is  *"
echo "* enough space for the script to make duplicates of all the book files.     *"
echo "*                                                                           *"
echo "* PLEASE CHECK THE DOCUMENTATION FOR INSTRUCTIONS ON HOW TO NAME YOUR FILES *"
echo "* BEFORE RUNNING THIS SCRIPT. The script cannot check for mistakes in the   *"
echo "* original filenames and will sort indiscriminately. If you notice files    *"
echo "* sorted incorrectly in the new directory, remove it, check your file names *"
echo "* and try again. Otherwise, you may remove the originals if you wish.       *"
echo "*****************************************************************************"
# Ask for the book name
echo "Name of book:"
read BOOK
mkdir "$BOOK"
mkdir "$BOOK"_tmp
# Throw in an XML
xmlcount=`ls -1 *.xml 2>/dev/null | wc -l`
if [ $xmlcount == 1 ];
then
  echo Single XML found, processing ... 
  cp *.xml "$BOOK"/--METADATA--.xml && mv *.xml "$BOOK"_tmp
fi
# Throw in a MARC binary
mrccount=`ls -1 *.mrc 2>/dev/null | wc -l`
if [ $mrccount == 1 ];
then
  echo Single MRC found, processing ...
  cp *.mrc "$BOOK"/--METADATA--.mrc && mv *.mrc "$BOOK"_tmp
fi
# Move over all colourchecker files
if [ -f *colourchecker* ]
then
  echo Colourcheckers present, processing ...
  cp *colourchecker* "$BOOK"
  mv *colourchecker* "$BOOK"_tmp
fi
# Set folder count
c=1
# Move over .tiffs and .dngs
for f in *.tif*
do
  mkdir "$BOOK"/$c
  filenamet="${f%%.*}"
  echo Processing $filenamet ...
  if [ -f "${f%%.*}".dng ]
  then
    d="${f%%.*}".dng
    echo With matching dng ...
    cp "$f" "$BOOK"/$c/OBJ.tif
    cp "$d" "$BOOK"/$c/DNG.dng
    mv "$f" "$BOOK"_tmp
    mv "$d" "$BOOK"_tmp
  else
    cp "$f" "$BOOK"/$c/OBJ.tif
    mv "$f" "$BOOK"_tmp
  fi
  let c=c+1
done
echo Cleaning up ...
mv "$BOOK"_tmp/*.* ./
rm -rf "$BOOK"_tmp
