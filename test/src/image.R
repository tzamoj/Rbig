# require(pixmap)
require(bigmemory)
require(bigalgebra)

# img <- read.pnm("../data//andromede.ppm"). Error image too large. 

## Terminal: pnmnoraw andromede.ppm > andromede.txt
## In the file, the first line is the encoding: P3. The second line the dimensions: ncol and nrow. The third line is the max value: 255. Then we have triplets of RGB, six per line.
## Each row of the image is recorded as a rowChunk. A rowChunk is just the row split to display only 6 pixels per row. As ncol is 2 mod 6, the last line of a rowChunk is 2 entries only.

## Need first to reformat the above file into csv:
## Could use Terminal: sed -n  '1,3 p' < andromede.txt > headerAndromede.txt 

setwd("/home/zamoj/Documents/doc/ensai/Rbig/project")
ff <- file("data/andromedeSmall.txt", open = 'r')
headerFile <- file("data/smallHeader.txt", 'w')
redFile <- file("data/smallRed.txt", 'w')
greenFile <- file("data/smallGreen.txt", 'w')
blueFile <- file("data/smallBlue.txt", 'w')

dims <- as.integer( strsplit( readLines(ff, n = 3)[2] , split = ' ')[[1]] )
rowChunkSize <- floor(dims[1] / 6) + 1  
for( k in 1:dims[2] ){
  rowChunk <- readLines(ff, n = rowChunkSize)
  ## Reformating line: first split each line according to double spaces: gives a list of vectors of strings.
  ## Then on each element of the list, turn each string to a vector of integers, reassembled as a list.
  ## Returns a doubly-nested list of integer-triplets RGB. First index=row, second=column.
  ## pixelChunk <- lapply( strsplit( rowChunk, split = '  '), function(x) lapply(strsplit(x, split=' '), as.integer)) 
  pixels <- as.integer(unlist(strsplit( unlist(strsplit( rowChunk, split = '  ')),
				        split=' ')))
  N <- length(pixels)
  vecRed <- pixels[1:N %% 3 == 0]
  vecGreen <- pixels[1:N %% 3 == 1]
  vecBlue <- pixels[1:N %% 3 == 2]
  write.table(vecRed, redFile, sep=";")
  write.table(vecGreen, greenFile, sep=";")
  write.table(vecBlue, blueFile, sep=";")
}
  

## Note: to save memory, the type is char. However, bigmemory does not seem to support unsigned char, so everytime a negative value is seen, 256 must be added, which sucks. 
redMat <- read.big.matrix(filename = "data/smallRed.txt", sep = ' ', type = "short", backingpath = "./data/", backingfile = "smallRed.bin", descriptorfile = "smallRed.desc") 
greenMat <- read.big.matrix(filename = "data/smallGreen.txt", sep = ' ', type = "short", backingpath = "./data/", backingfile = "smallGreen.bin", descriptorfile = "smallGreen.desc") 
blueMat <- read.big.matrix(filename = "data/smallBlue.txt", sep = ' ', type = "short", backingpath = "./data/", backingfile = "smallBlue.bin", descriptorfile = "smallBlue.desc") 


redMat <- attach.big.matrix("data/smallRed.desc")
greenMat <- attach.big.matrix("data/smallGreen.desc")
blueMat <- attach.big.matrix("data/smallBlue.desc")
			 



