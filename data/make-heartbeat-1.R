source("imprecise-bayes-opt-plug-in/makeMBOInfillCritGLCB.R")
source("imprecise-bayes-opt-plug-in/initCrit.InfillCritGLCB.R")
source("data/read-data-heartbeat-1.R")
library(dplyr)
library(mlrMBO)
library(ggplot2)

colnames(heartbeat_1) <- c("y","x")
heartbeat_1 = tidyr::drop_na(heartbeat_1)
cov_range = c(min(heartbeat_1[,2]), max(heartbeat_1[,2]))
ground_truth = train(makeLearner("regr.randomForest"), 
                     makeRegrTask(data = heartbeat_1, target = "y"))

fun = function(x) {
  df = data.frame("x" = x)
  # df$gas = factor(df$gas, levels = levels(data$gas))
  return(getPredictionResponse(predict(ground_truth, newdata = df)))
}

parameter_set = makeParamSet(
  #makeIntegerParam("power", lower = 10, upper = 5555)#,
  makeNumericParam("x", lower = cov_range[1], upper = cov_range[2])#,
  #makeDiscreteParam("gas", values = c("Nitrogen", "Air", "Argon")),
  #makeIntegerParam("pressure", lower = 0, upper = 1000)
)

heartbeat1_fun_rf = makeSingleObjectiveFunction(
  name = "heartbeat1",
  fn = fun,
  par.set = parameter_set,
  has.simple.signature = FALSE,
  minimize = FALSE
)
# visualize ground truth
grid <- data.frame("x" = seq(cov_range[1], cov_range[2], length.out = 10000))
# # langsam: plot(apply(grid, 1, fun), type = "l")
# #schneller:
plot(fun(grid), type = "l")

time_df = cbind(grid, fun(grid))
names(time_df) = c("time", "heartbeat rate")
hb_1_plot =  qplot(data = time_df, x=time_df$"time", y=time_df$"heartbeat rate", 
                         geom = "line", xlab = "time (0.5 sec)", ylab = "heartbeat rate",
                         main = "Heartbeat-rate target 1 (Random Forest)" )

#combine with power plot
#ggarrange(graph_time_plot, graph_power_plot, ncol = 2, nrow = 1)




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







