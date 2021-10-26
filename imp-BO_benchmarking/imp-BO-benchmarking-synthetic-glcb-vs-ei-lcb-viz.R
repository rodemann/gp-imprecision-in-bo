library(ggpubr)
source("univariate-benchmark-functions/univariate-test-functions-smoof.R")
source("univariate-benchmark-functions/univariate-test-functions-soobench.R")
source("univariate-benchmark-functions/get-synthetic-benchmark-funs-for-minimization.R")

source("imp-BO_benchmarking/draw_plot.R")
source("imp-BO_benchmarking/draw_plot_boot.R")
source("imp-BO_benchmarking/draw_plot_boot_facet.R")

#source("imp-BO_benchmarking/draw_legend_kapton.R")
#source("data/make-kapton-rf.R")

# load results list:
load("imp-BO_benchmarking/results/results-imp-BO-tests-init-10-budget-90-n-40-funs-1-5-glcb-only")

# these functions are used: 
synth_test_functions <- all_benchmark_funs[c(1:4,31)]


# some palettes to choose from
pal <- pal_ucscgb("default")(9)
safe_colorblind_palette <- c("#88CCEE", "#CC6677", "#DDCC77", "#117733", "#332288", "#AA4499", 
                             "#44AA99", "#999933", "#882255")
cbbPalette <- c("#000000", "#E69F00", "#56B4E9", "#009E73", "#F0E442", "#0072B2", "#D55E00", "#CC79A7")
# select palette
pal <- safe_colorblind_palette

# loop over functions
pub_pages = list()
for (fun in 1:5) {

# set pal globally for comparison
pal = pal[1:6]

# list(getOptPathY(cl_bo_res_lcb[["opt.path"]]), getOptPathY(cl_bo_res_ei[["opt.path"]]), 
#      getOptPathY(glcb_1_100_bo_res[["opt.path"]]),
#      getOptPathY(glcb_5_100_bo_res[["opt.path"]]), getOptPathY(glcb_1_50_bo_res[["opt.path"]]),
#      getOptPathY(glcb_5_50_bo_res[["opt.path"]]))

configs = c("LCB", "EI", "GLCB-1-100", "GLCB-5-100", "GLCB-1-50", "GLCB-5-50")
configs_indices = c(1,3,4,5,6)

plots = list()

#fun_name <- getName(synth_test_functions[[fun]])
# store all mops (mean opt paths) here
#BO_paths_all_mops <- matrix(nrow = budget, ncol = configs)
plot = draw_plot_boot_facet(fun = fun, results_list = results_list, bench = "LCB",
                            initial_design_size = 10, pal = pal, configs = configs, configs_indices = configs_indices) +
  labs(x = "Evaluations", y = "Mean Best Target Value", col = "Acquisition Function") 

plots_lcb <- plot + xlim(0,20) #+ theme_update() + scale_color_manual(values = cbbPalette)   #+scale_color_manual()





configs = c("LCB", "EI", "GLCB-1-100", "GLCB-5-100", "GLCB-1-50", "GLCB-5-50")
configs_indices = c(2,3,4,5,6)

plots = list()
#fun_name <- getName(synth_test_functions[[fun]])
# store all mops (mean opt paths) here
#BO_paths_all_mops <- matrix(nrow = budget, ncol = configs)
plot = draw_plot_boot_facet(fun = fun, results_list = results_list, bench = "EI",
                            initial_design_size = 10, pal = pal, configs = configs, configs_indices = configs_indices) +
  labs(x = "Evaluations", y = "Mean Best Target Value", col = "Acquisition Function") 
plots[[fun]] = plot

plots_ei <- plot + xlim(0,20) #+ theme_update() + scale_color_manual(values = cbbPalette)   #+scale_color_manual()




configs_lcb = configs[c(1,3,4,5,6)]
configs_ei = configs[c(2,3,4,5,6)]

# plots_lcb <- plots_lcb + theme_update() + scale_color_manual(values = cbbPalette, breaks = configs_lcb)  
# plots_ei <- plots_ei + theme_update() + scale_color_manual(values = cbbPalette, breaks = configs_ei)  
# plots_alcb <- plots_alcb + theme_update() + scale_color_manual(values = cbbPalette)


pal = cbbPalette
pal[c(1,3)] <- pal[c(3,1)]
pal[4] <- "grey85"

# 
# pal[c(1,4)] <- pal[c(4,1)]
# show_col(pal)
# pal[1] = "black"
# pal[c(2,3)] <- pal[c(3,2)]
# pal[c(3,4)] <- pal[c(4,3)]
pal[c(1,4)] <- pal[c(4,1)]
pal[c(1,5)] <- pal[c(5,1)]

plots_lcb_pub = plots_lcb + scale_color_manual(values=pal, breaks = configs_lcb)
pal[c(1,4)] <- pal[c(4,1)]
pal[c(2,3)] <- pal[c(3,2)]
pal[c(3,4)] <- pal[c(4,3)]
pal[c(2,3)] <- pal[c(3,2)]
pal[c(3,4)] <- pal[c(4,3)]
pal[c(1,5)] <- pal[c(5,1)]

plots_ei_pub = plots_ei + scale_color_manual(values=pal, breaks = configs_ei) 

pub_page = ggarrange(plots_ei_pub, plots_lcb_pub,
                     ncol = 1, nrow = 2)
pub_pages[[fun]] = pub_page

}

##Optional: annotate figure
pub_pages_notes =  list()
for (fun in 1:5) {
  name = getName(synth_test_functions[[fun]])
  pub_pages_notes[[fun]] = annotate_figure(pub_pages[[fun]],
                  top = text_grob(paste("GLCB vs. EI and LCB (", name,")", sep=""), color = "black", face = "bold", size = 14),
                  bottom = text_grob(paste("Bayesian optimization of", name, "
40 runs per Acquisition Function with 90 evaluations (20 shown) and initial sample size 10 each
Error bars represent bootstrapped 0.95-CI of incumbent mean best target value
EI = Expected Improvement, LCB = Lower Confidence Bound
GLCB-1-100 means rho = 1 and c = 100. tau = 1 for all GLCBs and for LCB."), 
                                     color = "black", face = "bold", size = 10))
}

pub_pages_notes





