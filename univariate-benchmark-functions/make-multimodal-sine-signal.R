library(smoof)



fun = function(x) {
  df = data.frame("x" = x)
  apply(df, 1, function(x){
    0.3*sin(x)+0.7*cos(x)-0.5*sin(1.2*x)*0.3*sin(x) + 1.3*cos(0.5*x)
    })
}
cov_range = c(0,100)
parameter_set = makeParamSet(
  #makeIntegerParam("power", lower = 10, upper = 5555)#,
  makeNumericParam("x", lower = cov_range[1], upper = cov_range[2])#,
  #makeDiscreteParam("gas", values = c("Nitrogen", "Air", "Argon")),
  #makeIntegerParam("Humidity", lower = 0, upper = 1000)
)

signal_fun_rf = makeSingleObjectiveFunction(
  name = "Signal",
  fn = fun,
  par.set = parameter_set,
  has.simple.signature = FALSE,
  minimize = FALSE
)
# visualize ground truth
grid <- data.frame("Humidity" = seq(cov_range[1], cov_range[2], length.out = 10000))
# # langsam: plot(apply(grid, 1, fun), type = "l")
# #schneller:
plot(fun(grid), type = "l")

# schöner:
signal_hum_df = cbind(grid, fun(grid))
names(signal_hum_df) = c("Humidity", "Wind")
graph_signal_hum_plot =  qplot(data = signal_hum_df, x=signal_hum_df$"Humidity", y=signal_hum_df$"Wind", 
                              geom = "line", xlab = "Humidity", ylab = "Wind",
                              main = "Wind-speed-Humidity target function (Random Forest)")
