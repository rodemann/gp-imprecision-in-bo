source("imprecise-bayes-opt-plug-in/makeMBOInfillCritGLCB.R")
source("imprecise-bayes-opt-plug-in/initCrit.InfillCritGLCB.R")
source("data/read-data-kapton.R")
library(dplyr)
library(mlrMBO)

library(ggplot2)

kapton_data <- data
kapton_data <- select(kapton_data, c(ratio, power))
colnames(kapton_data) <- c("y","x")

ground_truth = train(makeLearner("regr.randomForest"), 
                     makeRegrTask(data = kapton_data, target = "y"))

fun = function(x) {
  df = data.frame("x" = x)
  # df$gas = factor(df$gas, levels = levels(data$gas))
  return(getPredictionResponse(predict(ground_truth, newdata = df)))
}

parameter_set = makeParamSet(
  makeIntegerParam("x", lower = 10, upper = 5555)#,
  #makeNumericParam("x", lower = 500, upper = 21000)#,
  #makeDiscreteParam("gas", values = c("Nitrogen", "Air", "Argon")),
  #makeIntegerParam("pressure", lower = 0, upper = 1000)
)

kapton_fun_rf_power = makeSingleObjectiveFunction(
  name = "Kapton",
  fn = fun,
  par.set = parameter_set,
  has.simple.signature = FALSE,
  minimize = FALSE
)
# visualize ground truth
grid <- data.frame("x" = seq(10, 5555, 0.01))
# langsam: plot(apply(grid, 1, fun), type = "l")
#schneller:
power_df = cbind(grid, fun(grid))
names(power_df) = c("power", "graphene quality")
graph_power_plot = qplot(data = power_df, x=power_df$"power", y=power_df$"graphene quality", 
      geom = "line", xlab = "power", ylab = "graphene quality",
      main = "Graphene-power target function (Random Forest)" )




# # set up BO 
# iters = 15L
# # set Control Argument of BO 
# ctrl = makeMBOControl(propose.points = 1L)
# ctrl = setMBOControlTermination(ctrl, iters = iters)
# # plug in GLCB
# infill_crit = makeMBOInfillCritGLCB(cb.lambda = 1, cb.rho = 100)
# infill_crit = makeMBOInfillCritCB(cb.lambda = 1)
# ctrl = setMBOControlInfill(ctrl, crit = infill_crit, opt = "focussearch")#,
# #opt.focussearch.points = 200, opt.focussearch.maxit = 1)
# 
# lrn = makeLearner("regr.km", covtype = "powexp", predict.type = "se", optim.method = "gen", 
#                   control = list(trace = FALSE), config = list(on.par.without.desc = "warn"))
# # ensure numerical stability in km {DiceKriging} cf. github issue and recommendation by Bernd Bischl 
# y = obj_fun(design_biased)
# Nuggets = 1e-8*var(y)
# lrn = setHyperPars(learner = lrn, nugget=Nuggets)
# initial_opt = max(y)
# 
# 
# res_mbo = mbo(fun = obj_fun, design = design_biased, control = ctrl)
# 
# as.data.frame(res_mbo$opt.path)
# c( res_mbo$y, res_mbo$best.ind)
# initial_opt







