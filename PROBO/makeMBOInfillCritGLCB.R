# make Infill Criterion (Acquistion Function) Generalized Lower Confidence Bound


makeMBOInfillCritGLCB = function(cb.lambda = NULL, 
                                 cb.rho = NULL, 
                                 base_kernel= NULL, 
                                 imprecision= NULL) {
  
  # input checking
  assertNumber(cb.lambda, lower = 0, null.ok = TRUE)
  force(cb.lambda)
  assertNumber(cb.rho, lower = 0, null.ok = TRUE)
  force(cb.rho)
  assert_character(base_kernel, null.ok = TRUE)
  force(base_kernel)
  assertNumber(imprecision, lower = 0, null.ok = TRUE)
  force(imprecision)

  # create function
  makeMBOInfillCrit(
    fun = function(points, models, control, par.set, designs, iter, progress, attributes = FALSE) {
      model <- models[[1L]]
      theta <- models[[1]]$learner.model@covariance@range.val
      nugget <- models[[1]]$learner.model@covariance@nugget
      design <- models[[1]]$learner.model@X
      response <- models[[1]]$learner.model@y
      var <- models[[1]]$learner.model@covariance@sd2
      base_kernel_fun <- get_base_kernel(base_kernel)
      if (base_kernel == "powexp")
        power <- models[[1]]$learner.model@covariance@shape.val
      
      # compute Kernel Matrix and sum_rows and sum_all
      design_dist_matrix <- as.matrix(dist(design, upper = TRUE))
      if (base_kernel == "powexp")
        Kernel_matrix <- base_kernel_fun(design_dist_matrix, theta = theta, var = var, p = power) else
          Kernel_matrix <- base_kernel_fun(design_dist_matrix, theta = theta, var = var)
      Kernel_matrix_n <- Kernel_matrix + diag(nugget, nrow(Kernel_matrix))
      Kernel_matrix_n_inverse <- solve(Kernel_matrix_n)
      sum_rows_k <- solve(Kernel_matrix_n) %*% rep(1, nrow(Kernel_matrix_n))
      sum_all_k <- rep(1, nrow(Kernel_matrix_n)) %*% solve(Kernel_matrix_n) %*% rep(1, nrow(Kernel_matrix_n))
      sum_all_k <- as.double(sum_all_k) # seems necessary
      model_imprecision_scalar <- function(scalar) {
        # compute kernel vectors and matrices required for formulas in Theorem 3 
        # in Mangili (2015). Notation follows the theorem.
        distance <- abs(design - rep(scalar,nrow(design)))
        if(base_kernel == "powexp")
          kernel_vector <- base_kernel_fun(distance, theta, var = var, p = power) else
            kernel_vector <- base_kernel_fun(distance, theta, var = var)
          
          # compute model imprecision as defined in master thesis
          if (abs(t(sum_rows_k) %*% response / sum_all_k) <= 1 + imprecision/sum_all_k){
            model_imprecision_scalar <- 2 * imprecision * abs(1 - t(kernel_vector) %*% sum_rows_k)/sum_all_k
          }
          
          if (abs(t(sum_rows_k) %*% response / sum_all_k) > 1 + imprecision/sum_all_k){
            model_imprecision_scalar <-  (1 - t(kernel_vector) %*% sum_rows_k) *
              ((t(sum_rows_k) %*% response + imprecision)/sum_all_k - 
                t(sum_rows_k) %*% response/(imprecision + sum_all_k))
          } 
          model_imprecision_scalar
      }
      
      model_imprecision_fun <- function(newdata) {
        apply(newdata, 1, model_imprecision_scalar)
      }
      
      model_imprecision <- model_imprecision_fun(points)
      maximize.mult = if (control$minimize) 1 else -1
      p = predict(model, newdata = points)$data
      res = maximize.mult * p$response - cb.lambda * p$se - cb.rho * model_imprecision
      if (attributes) {
        res = setAttribute(res, "crit.components",
                           data.frame(se = p$se, mean = p$response, 
                                      lambda = cb.lambda, rho = cb.rho, 
                                      imprecision = model_imprecision))
      }
      return(res)
    },
    name = "Generalized Lower Confidence bound",
    id = "glcb",
    components = c("se", "mean", "lambda", "rho", "imprecision"),
    params = list(cb.lambda = cb.lambda, cb.rho = cb.rho, imprecision = imprecision),
    opt.direction = "objective",
    requires.se = TRUE
  )
}


# helper function to get base kernel
get_base_kernel <- function(base_kernel){
  switch(base_kernel,
         "gauss" = {base_kernel <- function(dist, theta, var){var * exp(-1/2*(dist/theta)^2)}},
         "exp" = {base_kernel <- function(dist, theta, var){var * exp(-dist/theta)}},
         "matern3_2" = {base_kernel <- function(dist, theta, var){var * (1+sqrt(3)*dist/theta)*exp(-sqrt(3)*dist/theta)}},
         "matern5_2" = {base_kernel <- function(dist, theta, var){var * (1+sqrt(5)*dist/theta+(1/3)*5*(dist/theta)^2)*exp(-sqrt(5)*dist/theta)}},
         "powexp" = {base_kernel <- function(dist, theta, p, var){var * exp(-(dist/theta)^p)}}
  )
  base_kernel
}



