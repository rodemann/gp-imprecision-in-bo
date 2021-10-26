library(scales)
source("imp-BO_benchmarking/draw_plot.R")
source("imp-BO_benchmarking/draw_plot_boot.R")
source("imp-BO_benchmarking/draw_plot_boot_facet.R")

source("imp-BO_benchmarking/draw_legend_kapton.R")
#source("data/make-kapton-rf.R")

# load results list:
#load("imp-BO_benchmarking/results/results-imp-BO-kapton-glcb-unbiased-and-biased")
#load("imp-BO_benchmarking/results/results-imp-BO-kapton-glcb-5")
load("imp-BO_benchmarking/results/results-imp-BO-tests-init-4-budget-40-n-40-fun29-rastrigin")

pal <- pal_ucscgb("default")(9)

safe_colorblind_palette <- c("#88CCEE", "#CC6677", "#DDCC77", "#117733", "#332288", "#AA4499", 
                             "#44AA99", "#999933", "#882255")
pal <- safe_colorblind_palette

optimum_col = "#ff00f7"

# choose function
fun = 1

# set pal globally for comparison
pal = pal[1:4]

## parallel hedging only has 39 entries (3 models), thus add non-informative 40th entry (=39th entry)
par_hedge_results = lapply(lapply(results_list[[fun]], "[[", 3), function(x){c(x,x[length(x)])})
for(iter in 1:40){
results_list[[fun]][[iter]][[3]] = par_hedge_results[[iter]]
}
# lapply(results_list[[fun]], function(x){
#   x[[3]] = par_hedge_results
#   })



configs = c("LCB", "Classic BO", "Parallel Hedging", "Batch-Wise Speed Up", "glcb1", "glcb2", "glcb3")
configs_indices = c(2,3,4)

  #fun_name <- getName(synth_test_functions[[fun]])
  # store all mops (mean opt paths) here
  #BO_paths_all_mops <- matrix(nrow = budget, ncol = configs)
  plot = draw_plot_boot_facet(fun = fun, results_list = results_list, bench = "Classic BO",
                              initial_design_size = 4, pal = pal, configs = configs, configs_indices = configs_indices) +
    labs(x = "Evaluations", y = "Mean Best Target Value", col = "Acquisition Function") +
    labs(subtitle =  "Rastrigin Function")

pal = cbbPalette
show_col(pal)
pal[1] = "black"
pal[c(2,3)] <- pal[c(3,2)]
pal[c(3,4)] <- pal[c(4,3)]
pal[c(1,3)] = pal[c(3,1)]
pal[c(2,4)] = pal[c(4,2)]
pal[c(2,3)] = pal[c(3,2)]
pal[c(1,3)] = pal[c(3,1)]

plot_rastr = plot + theme_update() + scale_color_manual(values = pal, breaks = configs[c(2,3,4)])   #+scale_color_manual()



##################################################################


load("imp-BO_benchmarking/results/results-imp-BO-tests-init-4-budget-40-n-40-fun26-happycat")

pal <- pal_ucscgb("default")(9)

safe_colorblind_palette <- c("#88CCEE", "#CC6677", "#DDCC77", "#117733", "#332288", "#AA4499", 
                             "#44AA99", "#999933", "#882255")
pal <- safe_colorblind_palette

optimum_col = "#ff00f7"

# choose function
fun = 1

# set pal globally for comparison
pal = pal[1:4]

## parallel hedging only has 39 entries (3 models), thus add non-informative 40th entry (=39th entry)
par_hedge_results = lapply(lapply(results_list[[fun]], "[[", 3), function(x){c(x,x[length(x)])})
for(iter in 1:40){
  results_list[[fun]][[iter]][[3]] = par_hedge_results[[iter]]
}
# lapply(results_list[[fun]], function(x){
#   x[[3]] = par_hedge_results
#   })



configs = c("LCB", "Classic BO", "Parallel Hedging", "Batch-Wise Speed Up", "glcb1", "glcb2", "glcb3")
configs_indices = c(2,3,4)

#fun_name <- getName(synth_test_functions[[fun]])
# store all mops (mean opt paths) here
#BO_paths_all_mops <- matrix(nrow = budget, ncol = configs)
plot = draw_plot_boot_facet(fun = fun, results_list = results_list, bench = "Classic BO",
                            initial_design_size = 4, pal = pal, configs = configs, configs_indices = configs_indices) +
  labs(x = "Evaluations", y = "Mean Best Target Value", col = "Acquisition Function")  +
  labs(subtitle =  "Happycat Function")
pal = cbbPalette
show_col(pal)
pal[1] = "black"
pal[c(2,3)] <- pal[c(3,2)]
pal[c(3,4)] <- pal[c(4,3)]
pal[c(1,3)] = pal[c(3,1)]
pal[c(2,4)] = pal[c(4,2)]
pal[c(2,3)] = pal[c(3,2)]
pal[c(1,3)] = pal[c(3,1)]

plot_happycat = plot + theme_update() + scale_color_manual(values = pal, breaks = configs[c(2,3,4)])   #+scale_color_manual()

##################################################################

load("imp-BO_benchmarking/results/results-imp-BO-tests-init-4-budget-40-n-40-fun25-griewank")

pal <- pal_ucscgb("default")(9)

safe_colorblind_palette <- c("#88CCEE", "#CC6677", "#DDCC77", "#117733", "#332288", "#AA4499", 
                             "#44AA99", "#999933", "#882255")
pal <- safe_colorblind_palette

optimum_col = "#ff00f7"

# choose function
fun = 1

# set pal globally for comparison
pal = pal[1:4]

## parallel hedging only has 39 entries (3 models), thus add non-informative 40th entry (=39th entry)
par_hedge_results = lapply(lapply(results_list[[fun]], "[[", 3), function(x){c(x,x[length(x)])})
for(iter in 1:40){
  results_list[[fun]][[iter]][[3]] = par_hedge_results[[iter]]
}
# lapply(results_list[[fun]], function(x){
#   x[[3]] = par_hedge_results
#   })



configs = c("LCB", "Classic BO", "Parallel Hedging", "Batch-Wise Speed Up", "glcb1", "glcb2", "glcb3")
configs_indices = c(2,3,4)

#fun_name <- getName(synth_test_functions[[fun]])
# store all mops (mean opt paths) here
#BO_paths_all_mops <- matrix(nrow = budget, ncol = configs)
plot = draw_plot_boot_facet(fun = fun, results_list = results_list, bench = "Classic BO",
                            initial_design_size = 4, pal = pal, configs = configs, configs_indices = configs_indices) +
  labs(x = "Evaluations", y = "Mean Best Target Value", col = "Acquisition Function")  +
  labs(subtitle =  "Griewank Function")
pal = cbbPalette
show_col(pal)
pal[1] = "black"
pal[c(2,3)] <- pal[c(3,2)]
pal[c(3,4)] <- pal[c(4,3)]
pal[c(1,3)] = pal[c(3,1)]
pal[c(2,4)] = pal[c(4,2)]
pal[c(2,3)] = pal[c(3,2)]
pal[c(1,3)] = pal[c(3,1)]

plot_griewank = plot + theme_update() + scale_color_manual(values = pal, breaks = configs[c(2,3,4)])   #+scale_color_manual()




##################################################################

load("imp-BO_benchmarking/results/results-imp-BO-tests-init-4-budget-40-n-40-fun31-weierstrass")

pal <- pal_ucscgb("default")(9)

safe_colorblind_palette <- c("#88CCEE", "#CC6677", "#DDCC77", "#117733", "#332288", "#AA4499", 
                             "#44AA99", "#999933", "#882255")
pal <- safe_colorblind_palette

optimum_col = "#ff00f7"

# choose function
fun = 1

# set pal globally for comparison
pal = pal[1:4]

## parallel hedging only has 39 entries (3 models), thus add non-informative 40th entry (=39th entry)
par_hedge_results = lapply(lapply(results_list[[fun]], "[[", 3), function(x){c(x,x[length(x)])})
for(iter in 1:40){
  results_list[[fun]][[iter]][[3]] = par_hedge_results[[iter]]
}
# lapply(results_list[[fun]], function(x){
#   x[[3]] = par_hedge_results
#   })



configs = c("LCB", "Classic BO", "Parallel Hedging", "Batch-Wise Speed Up", "glcb1", "glcb2", "glcb3")
configs_indices = c(2,3,4)

#fun_name <- getName(synth_test_functions[[fun]])
# store all mops (mean opt paths) here
#BO_paths_all_mops <- matrix(nrow = budget, ncol = configs)
plot = draw_plot_boot_facet(fun = fun, results_list = results_list, bench = "Classic BO",
                            initial_design_size = 4, pal = pal, configs = configs, configs_indices = configs_indices) +
  labs(x = "Evaluations", y = "Mean Best Target Value", col = "Acquisition Function")  +
  labs(subtitle =  "Weierstrass Function")


pal = cbbPalette
show_col(pal)
pal[1] = "black"
pal[c(2,3)] <- pal[c(3,2)]
pal[c(3,4)] <- pal[c(4,3)]
pal[c(1,3)] = pal[c(3,1)]
pal[c(2,4)] = pal[c(4,2)]
pal[c(2,3)] = pal[c(3,2)]
pal[c(1,3)] = pal[c(3,1)]

plot_weierstrass = plot + theme_update() + scale_color_manual(values = pal, breaks = configs[c(2,3,4)])   #+scale_color_manual()




pub_page = ggarrange(plot_rastr, plot_happycat, plot_griewank, plot_weierstrass,
                     ncol = 1, nrow = 4)

annotate_figure(pub_page,
                top = text_grob("Hedge and Batch vs. Classic BO", color = "black", face = "bold", size = 14),
                bottom = text_grob("Bayesian optimization of four synthetic functions
40 runs per method with 40 evaluations and initial sample size 4 each
Error bars represent bootstrapped 0.95-CI of incumbent mean best target value
Parallel hedging prior-robust BO with c = 50 (3 models, 30 evaluations each)
Batch-wise speed-up prior-robust BO with c = 1, 10, 100 (3 models, 30 evaluations each)
Same Configurations (AF, Infill Optimizers) for classic BO and both modifications
         ", 
                                   color = "black", face = "bold", size = 10))










