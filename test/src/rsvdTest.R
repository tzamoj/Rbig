## Configurations
require(bigmemory)
require(Rcpp)
require(RcppArmadillo)
require(microbenchmark)
require(snow)

setwd("/home/zamoj/Documents/doc/ensai/Rbig/project/test")
nbcores <- 7
cl <- makeCluster(nbcores, type = "SOCK")

## Data
redMat <- attach.big.matrix("data/smallRed.desc")
greenMat <- attach.big.matrix("data/smallGreen.desc")
blueMat <- attach.big.matrix("data/smallBlue.desc")

redDesc <- describe(redMat)
greenDesc <- describe(greenMat)
blueDesc <- describe(blueMat)

## Functions
source(orthoRange)


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

for( i in 1:nbcores){


listB <- clusterApply(cl, computeB, redMat, 
