#!/bin/bash

## This script is for prepocessing of the image so that it can fed into R-bigmemory.
## That is, it will create a .csv file for each of RGB plus a header file containing the dimensions.

## Convert binary to text format:
##    line 1: format -- P3
##    line 2: dimensions  -- ncol nrow
##    line 3: max value -- 255
##    line 4,$: 6 pixels a line separated by double spaces. Each pixel is in itself a triplet of integers separated by a single space.
pnmnoraw data/andromedeSmall.ppm > data/andromedeSmall.txt

## Create the header file with the first 3 lines
sed -n '1,3 p' < data/andromedeSmall.txt > data/smallHeader.txt

## Make each line into ;-sep values
## Note: apparently faster than using sed's -i flag
sed -e '4,$ s/  / /g' -e '4,$ s/ /;/g' data/andromedeSmall.txt | sponge data/andromedeSmall.txt 

