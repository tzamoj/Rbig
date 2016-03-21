require(pixmap)
require(bigmemory)

# img <- read.pnm("../data//andromede.ppm"). Error image too large. 

## Terminal: pnmnoraw andromede.ppm > andromede.txt
## In the file, the first line is the encoding: P3. The second line the dimensions: ncol and nrow. The third line is the max value: 255. Then we have triplets of RGB, six per line.
## Each row of the image is recorded as a rowChunk. A rowChunk is just the row split to display only 6 pixels per row. As ncol is 2 mod 6, the last line of a rowChunk is 2 entries only.

## Need first to reformat the above file into csv:
## Could use Terminal: sed -n  '1,3 p' < andromede.txt > headerAndromede.txt 

setwd("/home/zamoj/Documents/doc/ensai/Rbig/project")
ff <- file("data/andromedeSmall.txt", open = 'r')
redFile <- file("data/smallRed.txt", 'w')
greenFile <- file("data/smallGreen.txt", 'w')
blueFile <- file("data/smallBlue.txt", 'w')

dims <- as.integer( strsplit( readLines(ff, n = 3)[2] , split = ' ')[[1]] )
rowChunkSize <- floor(dims[1] / 6) + 1  
for( k in 1:dims[2] ){
  rowChunk <- readLines(ff, n = rowChunkSize)
  pixels <- as.integer(unlist(strsplit( unlist(strsplit( rowChunk, split = '  ')),
				        split=' ')))
  # Pixels is one-long row of integers of alternating RGB.
  N <- length(pixels)
  vecRed <- pixels[1:N %% 3 == 0] #  
  vecGreen <- pixels[1:N %% 3 == 1]
  vecBlue <- pixels[1:N %% 3 == 2]
  write(vecRed, redFile, append = TRUE, sep=";")
  write(vecGreen, greenFile, append = TRUE, sep=";")
  write(vecBlue, blueFile, append = TRUE, sep=";")
}
close(ff)
close(redFile)
close(greenFile)
close(blueFile)
  






