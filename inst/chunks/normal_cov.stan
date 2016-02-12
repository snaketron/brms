  /* multi-normal log-PDF for special residual covariance structures 
   * currently only ARMA effects of order 1 are implemented 
   * Args: 
   *   y: response vector 
   *   eta: linear predictor 
   *   squared_se: square of the user defined standard errors 
   *               will be set end zero if non are defined 
   *   N_tg: number of groups 
   *   begin: indicates the first observation in each group 
   *   end: indicates the last observation in each group 
   *   nrows: number of observations in each group 
   *   res_cov_matrix: AR1, MA1, or ARMA1 covariance matrix; 
   * Returns: 
   *   sum of the log-PDF values of all observations 
   */ 
   real normal_cov_log(vector y, vector eta, vector squared_se,  
                       int N_tg, int[] begin, int[] end, int[] nrows, 
                       matrix res_cov_matrix) { 
     vector[N_tg] lp; 
     for (i in 1:N_tg) { 
       matrix[nrows[i], nrows[i]] Sigma; 
       Sigma <- res_cov_matrix[1:nrows[i], 1:nrows[i]] 
                + diag_matrix(squared_se[begin[i]:end[i]]); 
       Sigma <- cholesky_decompose(Sigma); 
       lp[i] <- multi_normal_cholesky_log(y[begin[i]:end[i]], 
                                          eta[begin[i]:end[i]], Sigma); 
     }                        
     return sum(lp); 
   }
