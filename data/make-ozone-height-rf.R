source("imprecise-bayes-opt-plug-in/makeMBOInfillCritGLCB.R")
source("imprecise-bayes-opt-plug-in/initCrit.InfillCritGLCB.R")
source("read-data-kapton.R")
library(dplyr)
library(mlrMBO)
library(ggplot2)
library(mlbench)
data(Ozone)
summary(Ozone)
# Description: 1Month: 1 = January, ..., 12 = December2Day of month3Day of week: 1 = Monday, ..., 7 = Sunday4Daily maximum one-hour-average ozone reading5500 millibar pressure height (m) measured at Vandenberg AFB6Wind speed (mph) at Los Angeles International Airport (LAX)7Humidity (%) at LAX8Temperature (degrees F) measured at Sandburg, CA9Temperature (degrees F) measured at El Monte, CA10Inversion base height (feet) at LAX11Pressure gradient (mm Hg) from LAX to Daggett, CA12Inversion base temperature (degrees F) at LAX13Visibility (miles) measured at LAkapton_data <- select(kapton_data, c(ratio, time))

Ozone = select(Ozone, V4, V10)
Ozone = drop_na(Ozone)
cov_range = c(min(Ozone[,2]), max(Ozone[,2]))
names(Ozone) = c("Ozone_reading", "Height")
ground_truth = train(makeLearner("regr.randomForest"), 
                     makeRegrTask(data = Ozone, target = "Ozone_reading"))

fun = function(x) {
  df = data.frame("Height" = x)
  # df$gas = factor(df$gas, levels = levels(data$gas))
  return(getPredictionResponse(predict(ground_truth, newdata = df)))
}

parameter_set = makeParamSet(
  #makeIntegerParam("power", lower = 10, upper = 5555)#,
  makeNumericParam("Height", lower = cov_range[1], upper = cov_range[2])#,
  #makeDiscreteParam("gas", values = c("Nitrogen", "Air", "Argon")),
  #makeIntegerParam("pressure", lower = 0, upper = 1000)
)

ozone_fun_rf = makeSingleObjectiveFunction(
  name = "Ozone",
  fn = fun,
  par.set = parameter_set,
  has.simple.signature = FALSE,
  minimize = FALSE
)
# visualize ground truth
grid <- data.frame("Height" = seq(cov_range[1], cov_range[2], length.out = 10000))
# # langsam: plot(apply(grid, 1, fun), type = "l")
# #schneller:
plot(fun(grid), type = "l")

# schöner:
ozone_hum_df = cbind(grid, fun(grid))
names(ozone_hum_df) = c("Height", "ozone_reading")
graph_ozone_hum_plot =  qplot(data = ozone_hum_df, x=ozone_hum_df$"Height", y=ozone_hum_df$"ozone_reading", 
                              geom = "line", xlab = "Height", ylab = "ozone_reading",
                              main = "Ozone-Height target function (Random Forest)")

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







