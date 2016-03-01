#!/bin/bash

## This script is for prepocessing of the image so that it can feed into R-bigmemory.
## That is, it will create a .csv file for each of RGB plus a header file containing the dimensions.

## Convert binary to text format:
##    line 1: format -- P3
##    line 2: dimensions  -- ncol nrow
##    line 3: max value -- 255
##    line 4,$: 6 pixels a line separated by double spaces. Each pixel is in itself a triplet of integers separated by a single space.

pnmnoraw data/andromedeSmall.ppm > data/andromedeSmall.txt


## On small sized andromede, sed takes about 1m10s and awks takes 0m40s. We have to call it for each colour though. It is still extremely fast, compared to R script that ran for hours.

awk -F' ' -v colour=1 -f src/imageFormatting.awk data/andromedeSmall.txt > data/smallRed.txt
awk -F' ' -v colour=2 -f src/imageFormatting.awk data/andromedeSmall.txt > data/smallGreen.txt
awk -F' ' -v colour=3 -f src/imageFormatting.awk data/andromedeSmall.txt > data/smallBlue.txt
