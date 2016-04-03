#include <iostream>
#include <RcppArmadillo.h>
// [[Rcpp::depends(RcppArmadillo)]]

using namespace Rcpp;
using namespace arma;
using namespace std;

/***
 * In this version of randomized low-rank svd, we assume that the matrix can be loaded in memory
 */

// Loads big.matrix into an arma::mat.
mat readBigMatrix(string fname, int nr, int nc){
  int i, j;
  short nnz_val;
  size_t one = 1;
  FILE *fp;
  mat A;

  fp = fopen(fname.c_str(),"r");
  cerr << "initializing A of size " << nr << " by " << nc << endl;
  A = mat(nr,nc,fill::eye);
  cerr << "Reading in M of size " << nr << " by " << nc << " from dead memory\n";
  // Armadillo and bigmemory are column-dominant.
  for(j=0; j<nc; j++){
    for(i=0; i<nr; i++){
      fread(&nnz_val,sizeof(short),one,fp); //read nnz
      A(i,j) = nnz_val;
    }
  }
  fclose(fp);
  cerr << "A loaded in memory\n";
  return A;
}


// [[Rcpp::export]]
List myrsvd(S4 bigmat, int k, int p){
  mat Qb, R, Q, U, V, tmp;
  vec s;

  List desc = bigmat.slot("description");
  string fname = desc["filename"];
  fname = "data/" + fname;
  int nr = desc["nrow"];
  int nc = desc["ncol"];

  mat A = readBigMatrix(fname, nr, nc);
  mat W = randn(nc,k+p);
  cerr << "Computing the ortho basis for approximate range\n";
  qr_econ(Q,tmp, A * W);
  cerr << "Computing the QR decomposition\n";
  qr_econ(Qb, R, A.t() * Q);
  cerr << "Computing the SVD of low-rank\n";
  svd(U, s, V, R);
  cerr << "Returning the values to R\n";
  mat Uf = Q * V; Uf = Uf.cols(1,k);
  mat Vf = Qb * U; Vf = Vf.cols(1,k);
  s = s.subvec(1,k);
  return List::create(
      Named("u") = Uf,
      Named("d") = s,
      Named("v") = Vf);
}

