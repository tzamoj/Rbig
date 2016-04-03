## Configurations
require(bigmemory)
require(Rcpp)
require(RcppArmadillo)
require(microbenchmark)
require(snow)

setwd("/home/zamoj/Documents/doc/ensai/Rbig/project/test")
nbcores <- 3
cl <- makeCluster(nbcores, type = "SOCK")

## Data
redMat <- attach.big.matrix("data/smallRed.desc")
greenMat <- attach.big.matrix("data/smallGreen.desc")
blueMat <- attach.big.matrix("data/smallBlue.desc")

redDesc <- describe(redMat)
greenDesc <- describe(greenMat)
blueDesc <- describe(blueMat)

## Functions
sourceCpp('src/myrsvd.cpp')
myrsvdWrap <- function(bigmat,k,p){
  fp <- attr(bigmemory::describe(bigmat),'description')$filename 
  myrsvd(paste0('data/',fp), nrow(bigmat), ncol(bigmat), k, p) 
}


#### Randomized Low-Rank SVD
## Reference to the implementation article of Voronin and Martinsson, we use the third version of the algorithm with possibly the second auto-rank version.
## That is: A approx QB with B = tQA. Use econ-QR decomp on B = Q'R' and run regular svd on R'. For autorank, we generate blocks of random vectors until the projection of A is close to A. 


## Parameters
maxRank <- 0.1 * min(nrow(redMat), ncol(redMat)) # max lowrank approx. 
TOL <- 0.1 # Tolerance for autorank
rBlockSize <- 25 # Generate 25 vectors at a time. 

listAW <- clusterCall(cl, rangeApprox, redMat, rBlockSize)
Q <- orthoRange(listAW) 
nc <- ncol(Q)


listBands <- list(redMat,greenMat,blueMat)
listFiles <- list('data/smallRed.bin', 'data/smallGreen.bin', 'data/smallBlue.bin')

listB <- clusterApply(cl, listFiles, myrsvd, nrow(redMat), ncol(redMat),500, 5)


## To do: microbenchmark svd, rsvd and myrsvd
