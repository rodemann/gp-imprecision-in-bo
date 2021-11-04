source("PROBO/makeMBOInfillCritGLCB.R")

# this extends the method initCrit to the GLCB Infill Criterion 

initCrit.InfillCritGLCB = function(crit, fun, design, learner, control) {
  cb.lambda = crit$params$cb.lambda
  if (is.null(cb.lambda))
    cb.lambda = ifelse(mlrMBO:::isSimpleNumeric(getParamSet(fun)), 1, 2)
  cb.rho = crit$params$cb.rho
  if (is.null(cb.rho))
    cb.rho = 1
  imprecision = crit$params$imprecision
  if (is.null(imprecision))
    imprecision = 100
  base_kernel = learner$par.vals$covtype
  crit = makeMBOInfillCritGLCB(cb.lambda, cb.rho, base_kernel, imprecision)
  mlrMBO:::initCritOptDirection(crit, fun)
}