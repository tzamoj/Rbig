require(rsvd)
require(bigmemory)
require(Rcpp)
require(RcppArmadillo)
setwd("/home/zamoj/Documents/doc/ensai/Rbig/project/test")

## This is just testing that the algorithm does not throw us some errors on small matrices, and how the singular values are approximated. 
sourceCpp("src/rsvd.cpp")
A <- as.big.matrix(matrix(rpois(1000,5),nrow=10, ncol=100), type = 'short', backingfile = "randomMatrix.bin", backingpath = "data/", descriptorfile = "randomMatrix.desc")
ll <- myrsvd("data/randomMatrix.bin", nrow(A), ncol(A), 5) 
s <- mysvd("data/randomMatrix.bin", nrow(A), ncol(A)) 

norm(as.matrix(A)-ll$U %*% diag(as.numeric(ll$s)) %*% t(ll$V))
rr <- svd(as.matrix(A))

