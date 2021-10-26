library(mlrMBO)
library(mlr3)
library(smoof)
library(rgenoud)
library(DiceKriging)

source("imprecise-bayes-opt/imp_BO.R")


obj.fun <- smoof::makeAckleyFunction(1)

parameter_set <- getParamSet(obj.fun)
design <- generateDesign(n=10L, par.set = parameter_set, fun = lhs::randomLHS)

iters = 20L
# set Control Argument of BO 
ctrl = makeMBOControl(propose.points = 1L)
ctrl = setMBOControlTermination(ctrl, iters = iters)
ctrl = setMBOControlInfill(ctrl, crit = makeMBOInfillCritEI(),
                           opt = "focussearch")
imp_BO_univariate(fun = obj.fun, design = design, 
                  base_kernel = "gauss", imp_degree = 1,
                  control = ctrl, M = 10000, h = 1)




