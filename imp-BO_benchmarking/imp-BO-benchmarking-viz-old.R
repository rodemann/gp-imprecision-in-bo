source("imp-BO_benchmarking/draw_plot.R")
source("imp-BO_benchmarking/draw_legend.R")
source("univariate-benchmark-functions/get-synthetic-benchmark-funs-for-minimization.R")

# load results list:
load("imp-BO_benchmarking/results/results-imp-BO-tests-init-10-budget-90-n-40-funs6-10")


  # select palette
  #pal <- wes_palette("Zissou1", 5)
  pal <- c("steelblue", "magenta", "forestgreen", "darkred", "orange1")
  pal <- brewer.pal(5, "Oranges")
  pal <- pal_ucscgb("default")(7)
  #pal <- pal_tron("legacy")(6)
  #pal <- viridis(4)
  
  optimum_col = "#ff00f7"
  
  #  create leegend
  draw_legend(pal)
  
  # load results to environment
  #load("")
  
  # load respective set of test functions
  synth_test_functions <- all_benchmark_funs[16:20]
  number_of_funs <- length(synth_test_functions)  
  
  
  ## OPTIONAL: cut off late evaluations
  #results_list_cut = lapply(results_list, function(x) lapply(x, function(x) lapply(x, head, -50)))
  #is.vector(results_list[[1]][[1]][[1]])
  
  
  plots = list()
  for (fun in 1:number_of_funs) {
    
    global.opt <- getGlobalOptimum(synth_test_functions[[fun]])[["value"]]
    fun_name <- getName(synth_test_functions[[fun]])
    # store all mops (mean opt paths) here
    #BO_paths_all_mops <- matrix(nrow = budget, ncol = configs)
    plot = draw_plot(fun = fun, results_list = results_list, 
                     initial_design_size = 4, pal = pal, configs = c(1,2,3,4)) +
      labs(x = "Iteration", y = "Mean Best Target Value") +
      geom_hline(yintercept = global.opt, linetype = "dashed",  color = optimum_col) + 
      labs(title = paste("Bayesian Optimization of", fun_name), 
           subtitle = "60 BO runs per Kernel Function with 20 iterations each. Dotted pink line: Global Optimum.
                       Error Bars represent 0.95-CI of best target value.") 
    plots[[fun]] = plot
  }
  
  plots
  
  
  
  
  