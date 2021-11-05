source("PROBO/makeMBOInfillCritGLCB.R")
source("PROBO/initCrit.InfillCritGLCB.R")
source("data/read-data-kapton.R")
library(dplyr)
library(mlrMBO)
library(ggplot2)
kapton_data <- data
kapton_data <- select(kapton_data, c(ratio, time))
colnames(kapton_data) <- c("y","x")

ground_truth = train(makeLearner("regr.randomForest"), 
                     makeRegrTask(data = kapton_data, target = "y"))

fun = function(x) {
  df = data.frame("x" = x)
  # df$gas = factor(df$gas, levels = levels(data$gas))
  return(getPredictionResponse(predict(ground_truth, newdata = df)))
}

parameter_set = makeParamSet(
  #makeIntegerParam("power", lower = 10, upper = 5555)#,
  makeNumericParam("x", lower = 500, upper = 21000)#,
  #makeDiscreteParam("gas", values = c("Nitrogen", "Air", "Argon")),
  #makeIntegerParam("pressure", lower = 0, upper = 1000)
)

kapton_fun_rf = makeSingleObjectiveFunction(
  name = "Kapton",
  fn = fun,
  par.set = parameter_set,
  has.simple.signature = FALSE,
  minimize = FALSE
)
# visualize ground truth
 grid <- data.frame("x" = seq(0, 21000, 5))
# # langsam: plot(apply(grid, 1, fun), type = "l")
# #schneller:
 plot(fun(grid), type = "l")

 time_df = cbind(grid, fun(grid))
 names(time_df) = c("time", "graphene quality")
 graph_time_plot =  qplot(data = time_df, x=time_df$"time", y=time_df$"graphene quality", 
       geom = "line", xlab = "time", ylab = "graphene quality",
       main = "Graphene-time target function (Random Forest)" )
 graph_time_plot
 #combine with power plot
 #ggarrange(graph_time_plot, graph_power_plot, ncol = 2, nrow = 1)
 
 




