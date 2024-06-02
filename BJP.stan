

data {
  int<lower=0> n;
  matrix[n,2]  Y;
  matrix[n,2]  Z;
  matrix[n,2] coef;
  #vector[4] param;
  vector[2] m_Z;
  cov_matrix[2] cov_Z;
   }
  

parameters {
  vector[2] mu;
  vector <lower=0>[2]  sigma;
  real <lower=-1, upper=1> rho;
}

transformed parameters {
  matrix[2, 2] P = to_matrix([1, rho, rho, 1],2 ,2); 
  cov_matrix[2] SIGMA = diag_matrix(sigma) * P * diag_matrix(sigma);
}


model {
  mu  ~ multi_normal_lpdf(m_Z, SIGMA);
  SIGMA  ~ inv_wishart_lpdf(6, 1.5*cov_Z );
  for ( i in 1:n){
       target += coef[i,1]+ coef[i,2] + multi_normal_lpdf( Z[i,]| mu, SIGMA); 
    
  }
    }
    
    

