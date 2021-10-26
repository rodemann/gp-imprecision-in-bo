library(scales)
source("imp-BO_benchmarking/draw_plot.R")
source("imp-BO_benchmarking/draw_plot_boot.R")
source("imp-BO_benchmarking/draw_legend_kapton.R")
source("data/make-kapton-rf.R")

# load results list:
#load("imp-BO_benchmarking/results/results-imp-BO-kapton-glcb-unbiased-and-biased")
load("imp-BO_benchmarking/results/results-imp-BO-kapton-glcb-3")

# select palette
#pal <- wes_palette("Zissou1", 5)
#pal <- c("steelblue", "magenta", "forestgreen", "darkred", "orange1")
#pal <- brewer.pal(5, "Oranges")
pal <- pal_ucscgb("default")(8)
#pal <- pal_tron("legacy")(2)
#pal <- viridis(5)
#pal <- c()

optimum_col = "#ff00f7"

#pal = pal[c(1,2,5)]

#  create legend
draw_legend_kapton_final(pal)

# load results to environment
#load("")



plots = list()
for (fun in 1:1) {
  
  #fun_name <- getName(synth_test_functions[[fun]])
  # store all mops (mean opt paths) here
  #BO_paths_all_mops <- matrix(nrow = budget, ncol = configs)
  plot = draw_plot_boot(fun = fun, results_list = results_list, 
                        initial_design_size = 10, pal = pal, configs = c(1,2,5)) +
    labs(x = "Evaluations", y = "Mean Best Target Value") +
    # geom_hline(yintercept = global.opt, linetype = "dashed",  color = optimum_col) + 
    labs(title = paste("Bayesian Optimization of Kapton Production"), 
         subtitle = "40 runs per method with a budget of 90 evaluations and an initial sample of size n=10 each. 
         Error bars represent bootstrapped 0.95-CI of incumbent mean best target value.
         Generalized Lower Confidence Bound (GLCB) systematically outperforms LCB after 
         evaluation 40 and Expected Improvement (EI) after evaluation 72.
         Simliar results were achieved with other Acquisition Functions.") #+
  #ylim(c(3.2,3.8))
  
  plots[[fun]] = plot
}

plots

config_names <- c("Parallel", "Classical")
legend("top", legend =config_names, pch=16, pt.cex=3, cex=1.5, bty='n',
       col = pal)
mtext("Optimization Method", at=0.5, cex=2)

# plots[[1]]  +   labs(title = paste("Bayesian Optimization of Kapton Production"), 
#                     subtitle = "40 BO runs per Acquisition Function with a budget of 90 evaluations and an initial sample \n
#          of size n=10 each. Error Bars represent bootstrapped 0.95-CI of mean best target value.")
# 






