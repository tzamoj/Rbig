require(bigmemory)
require(Rcpp)
require(RcppArmadillo)
require(rsvd)
require(ggplot2)

setwd("..")
## To benchmark computing time:
## ptm <- proc.time()
## command
## proc.time() - ptm

sourceCpp("src/myrsvd.cpp")

## On first reading, uncomment and run the following line instead of the next.
#A <- read.big.matrix(filename = "data/pizza.txt", sep = ' ', type = "short", backingpath = "./data/", backingfile = "pizza.bin", descriptorfile = "pizza.desc")
A <- attach.big.matrix("data/pizza.desc")

res <- svd(as.matrix(A))
rer <- rsvd(as.matrix(A),k=1000,p=10,q=0)
rem <- myrsvd(describe(A),1000,10)

## Recovering the image.
iM <- rem$u %*% diag(rem$d[,1]) %*% t(rem$v)
writeMatrixRow(iM, min(iM), max(iM), 'data/pizzaComp1000.bin') 

## Function to compute size of compressed image in MB
ss = function(k) (8278*k + 33114*k + k)/10^6

### Plotting the singular values
## A a data.frame or matrix, returns it in long format categorised by column names, or colLabels if provided.
df2Long <- function(A, timeAxis = NULL, colLabels = NULL){
  if(is.null(colLabels) && !is.null(colnames(A))) colLabels=colnames(A)
  if(is.null(timeAxis)) timeAxis = 1:nrow(A)
  Aframe <- data.frame(x = c(), y = c(), l = c())
  for(i in 1:ncol(A)){
    Aframe <- rbind(Aframe, data.frame(x = timeAxis, y = A[,i], l = colLabels[i]))
  }
  Aframe
}
## Plots multiple curves on one graphic using longFormat from df2Long.
plotCurves <- function(A, xStr, yStr, tStr, fname){
  pegg <- ggplot(data=A, aes(x=x, y=y, group=l))+
    geom_line(aes(colour=l))+
    xlab(xStr)+ylab(yStr)+ggtitle(tStr)+
    theme(plot.title=element_text(lineheight=0.8,face='bold'))
  png(fname)
  print(pegg)
  dev.off()
}

ind <- 5:50
svalues <- data.frame(svd=res$d[ind], rsvd=rer$d[ind], myrsvd=rem$d[ind,1])
plotCurves(df2Long(svalues, timeAxis = ind), 'index', 'Singular Values', 'Estimates of Singular Values', 'doc/sv.png')
