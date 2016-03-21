#include <iostream>
#include <RcppArmadillo.h>
// [[Rcpp::depends(RcppArmadillo)]]

using namespace Rcpp;
using namespace arma;
using namespace std;

/***
 * In this version of randomized low-rank svd, we assume that the matrix can be loaded in memory
 */

imat readBigMatrix(string fname, int nr, int nc){
  int i, j;
  short nnz_val;
  size_t one = 1;
  FILE *fp;
  imat A;

  fp = fopen(fname.c_str(),"r");
  printf("initializing A of size %d by %d\n", nr, nc);
  A = imat(nr,nc,fill::eye);
  printf("A is initalized\n");

  printf("Reading in M\n");
  // Armadillo and bigmemory are column-dominant.
  for(j=0; j<nc; j++){
    for(i=0; i<nr; i++){
      fread(&nnz_val,sizeof(short),one,fp); //read nnz
      A(i,j) = nnz_val;
    }
  }
  fclose(fp);
  printf("A read in\n");
  return A;
}


// [[Rcpp::export]]
SEXP rsvd(SEXP sfname, SEXP snr, SEXP snc, SEXP sk){
  string fname = Rcpp::as<string>(sfname);
  int nr = Rcpp::as<int>(snr);
  int nc = Rcpp::as<int>(snc);
  int k = Rcpp::as<int>(sk);
  mat Qb, R, Q, U, V;
  vec s;
  int p = 3;
  mat W = randn(nc,k+p);
  imat A = readBigMatrix(fname, nr, nc);
  Q = orth(A * W);
  qr_econ(Qb, R, A.t() * Q);
  svd(U, s, V, R);
  return List::create(
      Named("U") = Q * V,
      Named("s") = s,
      Named("V") = Qb * U);
}

