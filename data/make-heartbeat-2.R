source("imprecise-bayes-opt-plug-in/makeMBOInfillCritGLCB.R")
source("imprecise-bayes-opt-plug-in/initCrit.InfillCritGLCB.R")
source("data/read-data-heartbeat-2.R")
library(dplyr)
library(mlrMBO)
library(ggplot2)

colnames(heartbeat_2) <- c("y","x")
heartbeat_2 = tidyr::drop_na(heartbeat_2)
cov_range = c(min(heartbeat_2[,2]), max(heartbeat_2[,2]))
ground_truth = train(makeLearner("regr.randomForest"), 
                     makeRegrTask(data = heartbeat_2, target = "y"))

fun_hb_2 = function(x) {
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

heartbeat2_fun_rf = makeSingleObjectiveFunction(
  name = "heartbeat1",
  fn = fun_hb_2,
  par.set = parameter_set,
  has.simple.signature = FALSE,
  minimize = FALSE
)
# visualize ground truth
grid <- data.frame("x" = seq(cov_range[1], cov_range[2], length.out = 10000))
# # langsam: plot(apply(grid, 1, fun_hb_2), type = "l")
# #schneller:
plot(fun_hb_2(grid), type = "l")

time_df = cbind(grid, fun_hb_2(grid))
names(time_df) = c("time", "heartbeat rate")
hb_2_plot =  qplot(data = time_df, x=time_df$"time", y=time_df$"heartbeat rate", 
                         geom = "line", xlab = "time (0.5 sec)", ylab = "heartbeat rate",
                         main = "Heartbeat-rate target 2 (Random Forest)" )

#combine with other plot
#ggpubr::ggarrange(hb_1_plot_bla, hb_2_plot, ncol = 1, nrow = 2)




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







