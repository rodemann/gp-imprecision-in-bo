library(scales)
source("imp-BO_benchmarking/draw_plot.R")
source("imp-BO_benchmarking/draw_plot_boot.R")
source("imp-BO_benchmarking/draw_plot_boot_facet.R")

source("imp-BO_benchmarking/draw_legend_kapton.R")
#source("data/make-kapton-rf.R")

# load results list:
#load("imp-BO_benchmarking/results/results-imp-BO-kapton-glcb-unbiased-and-biased")
load("imp-BO_benchmarking/results/results-imp-BO-kapton-glcb-5")
#load("imp-BO_benchmarking/results/results-imp-BO-kapton-init-10-budget-90-n-40-paralell-fixed")

# select palette
#pal <- wes_palette("Zissou1", 5)
#pal <- c("steelblue", "magenta", "forestgreen", "darkred", "orange1")
#pal <- brewer.pal(5, "Oranges")
pal <- pal_ucscgb("default")(9)

safe_colorblind_palette <- c("#88CCEE", "#CC6677", "#DDCC77", "#117733", "#332288", "#AA4499", 
                             "#44AA99", "#999933", "#882255")
cbbPalette <- c("#000000", "#E69F00", "#56B4E9", "#009E73", "#F0E442", "#0072B2", "#D55E00", "#CC79A7")

pal <- safe_colorblind_palette
#pal = c(pal[4], pal[1:3])
#pal <- pal_tron("legacy")(9)
#pal <- viridis(9)
#pal <- c()

optimum_col = "#ff00f7"


# set pal globally for comparison
pal = pal[1:4]


configs = c("LCB", "ALCB", "EI", "AEI", "EQI", "SE", "GLCB-1-50", "GLCB-1-100", "GLCB-10-100")
configs_indices = c(3,7,8,9)

plots = list()
for (fun in 1:1) {
  
  #fun_name <- getName(synth_test_functions[[fun]])
  # store all mops (mean opt paths) here
  #BO_paths_all_mops <- matrix(nrow = budget, ncol = configs)
  plot = draw_plot_boot_facet(fun = fun, results_list = results_list, bench = "EI",
                              initial_design_size = 10, pal = pal, configs = configs, configs_indices = configs_indices) +
    labs(x = "Evaluations", y = "Mean Best Target Value", col = "Acquisition Function") 
  plots[[fun]] = plot
}


plots_ei <- plots[[1]] #+ theme_update() + scale_color_manual(values = cbbPalette)   #+scale_color_manual()






configs = c("LCB", "ALCB", "EI", "AEI", "EQI", "SE", "GLCB-1-50", "GLCB-1-100", "GLCB-10-100")
configs_indices = c(1,7,8,9)

plots = list()
for (fun in 1:1) {
  
  #fun_name <- getName(synth_test_functions[[fun]])
  # store all mops (mean opt paths) here
  #BO_paths_all_mops <- matrix(nrow = budget, ncol = configs)
  plot = draw_plot_boot_facet(fun = fun, results_list = results_list, bench = "LCB",
                              initial_design_size = 10, pal = pal, configs = configs, configs_indices = configs_indices) +
    labs(x = "Evaluations", y = "Mean Best Target Value", col = "Acquisition Function") 
  plots[[fun]] = plot
}


plots_lcb <- plots[[1]] #+ theme_update() + scale_color_manual(values = cbbPalette)   #+scale_color_manual()






configs = c("LCB", "ALCB", "EI", "AEI", "EQI", "SE", "GLCB-1-50", "GLCB-1-100", "GLCB-10-100")
configs_indices = c(2,7,8,9)

plots = list()
for (fun in 1:1) {
  
  #fun_name <- getName(synth_test_functions[[fun]])
  # store all mops (mean opt paths) here
  #BO_paths_all_mops <- matrix(nrow = budget, ncol = configs)
  plot = draw_plot_boot_facet(fun = fun, results_list = results_list, bench = "ALCB",
                              initial_design_size = 10, pal = pal, configs = configs, configs_indices = configs_indices) +
    labs(x = "Evaluations", y = "Mean Best Target Value", col = "Acquisition Function")
  plots[[fun]] = plot
}


plots_alcb <- plots[[1]] #+ theme_update() + scale_color_manual(values = cbbPalette)   #+scale_color_manual()



configs = c("LCB", "ALCB", "EI", "AEI", "EQI", "SE", "GLCB-1-50", "GLCB-1-100", "GLCB-10-100")
configs_indices = c(4,7,8,9)

plots = list()
for (fun in 1:1) {
  
  #fun_name <- getName(synth_test_functions[[fun]])
  # store all mops (mean opt paths) here
  #BO_paths_all_mops <- matrix(nrow = budget, ncol = configs)
  plot = draw_plot_boot_facet(fun = fun, results_list = results_list, bench = "AEI",
                              initial_design_size = 10, pal = pal, configs = configs, configs_indices = configs_indices) +
    labs(x = "Evaluations", y = "Mean Best Target Value", col = "Acquisition Function") 
  plots[[fun]] = plot
}


plots_aei <- plots[[1]] #+ theme_update() + scale_color_manual(values = cbbPalette)   #+scale_color_manual()



configs = c("LCB", "ALCB", "EI", "AEI", "EQI", "SE", "GLCB-1-50", "GLCB-1-100", "GLCB-10-100")
configs_indices = c(5,7,8,9)

plots = list()
for (fun in 1:1) {
  
  #fun_name <- getName(synth_test_functions[[fun]])
  # store all mops (mean opt paths) here
  #BO_paths_all_mops <- matrix(nrow = budget, ncol = configs)
  plot = draw_plot_boot_facet(fun = fun, results_list = results_list, bench = "EQI",
                              initial_design_size = 10, pal = pal, configs = configs, configs_indices = configs_indices) +
    labs(x = "Evaluations", y = "Mean Best Target Value", col = "Acquisition Function") 
  plots[[fun]] = plot
}


plots_eqi <- plots[[1]] #+ theme_update() + scale_color_manual(values = cbbPalette)   #+scale_color_manual()



configs = c("LCB", "ALCB", "EI", "AEI", "EQI", "SE", "GLCB-1-50", "GLCB-1-100", "GLCB-10-100")
configs_indices = c(6,7,8,9)

plots = list()
for (fun in 1:1) {
  
  #fun_name <- getName(synth_test_functions[[fun]])
  # store all mops (mean opt paths) here
  #BO_paths_all_mops <- matrix(nrow = budget, ncol = configs)
  plot = draw_plot_boot_facet(fun = fun, results_list = results_list, bench = "SE",
                              initial_design_size = 10, pal = pal, configs = configs, configs_indices = configs_indices) +
    labs(x = "Evaluations", y = "Mean Best Target Value", col = "Acquisition Function") 
  plots[[fun]] = plot
}


plots_se <- plots[[1]] #+ theme_update() + scale_color_manual(values = cbbPalette)   #+scale_color_manual()






show_col(pal)

configs_lcb = c("LCB", "ALCB", "EI", "AEI", "EQI", "SE", "GLCB-1-50", "GLCB-1-100", "GLCB-10-100")[c(1,7,8,9)]
configs_ei = c("LCB", "ALCB", "EI", "AEI", "EQI", "SE", "GLCB-1-50", "GLCB-1-100", "GLCB-10-100")[c(3,7,8,9)]
configs_alcb = c("LCB", "ALCB", "EI", "AEI", "EQI", "SE", "GLCB-1-50", "GLCB-1-100", "GLCB-10-100")[c(2,7,8,9)]
configs_aei = c("LCB", "ALCB", "EI", "AEI", "EQI", "SE", "GLCB-1-50", "GLCB-1-100", "GLCB-10-100")[c(4,7,8,9)]
configs_eqi = c("LCB", "ALCB", "EI", "AEI", "EQI", "SE", "GLCB-1-50", "GLCB-1-100", "GLCB-10-100")[c(5,7,8,9)]
configs_se = c("LCB", "ALCB", "EI", "AEI", "EQI", "SE", "GLCB-1-50", "GLCB-1-100", "GLCB-10-100")[c(6,7,8,9)]


# plots_lcb <- plots_lcb + theme_update() + scale_color_manual(values = cbbPalette, breaks = configs_lcb)  
# plots_ei <- plots_ei + theme_update() + scale_color_manual(values = cbbPalette, breaks = configs_ei)  
# plots_alcb <- plots_alcb + theme_update() + scale_color_manual(values = cbbPalette)


pal = cbbPalette
show_col(pal)
pal[c(1,4)] <- pal[c(4,1)]
pal[4] <- "grey85"

# 
# pal[c(1,4)] <- pal[c(4,1)]
# show_col(pal)
# pal[1] = "black"
# pal[c(2,3)] <- pal[c(3,2)]
# pal[c(3,4)] <- pal[c(4,3)]

plots_lcb_pub = plots_lcb + scale_color_manual(values=pal, breaks = configs_lcb)
pal[c(1,4)] <- pal[c(4,1)]
pal[c(2,3)] <- pal[c(3,2)]
pal[c(3,4)] <- pal[c(4,3)]
pal[c(2,3)] <- pal[c(3,2)]
pal[c(3,4)] <- pal[c(4,3)]

plots_ei_pub = plots_ei + scale_color_manual(values=pal, breaks = configs_ei) 
plots_aei_pub = plots_aei + scale_color_manual(values=pal, breaks = configs_aei) 
plots_alcb_pub = plots_alcb + scale_color_manual(values=pal, breaks = configs_alcb) 
plots_eqi_pub = plots_eqi + scale_color_manual(values=pal, breaks = configs_eqi) 

#pal = cbbPalette
#pal[1] = "black"
pal[c(2,3)] <- pal[c(3,2)]
pal[c(1,4)] <- pal[c(4,1)]
pal[c(1,3)] <- pal[c(3,1)]
#show_col(pal)

plots_se_pub = plots_se + scale_color_manual(values=pal, breaks = configs_se)




library(ggpubr)
pub_page = ggarrange(plots_ei_pub, plots_lcb_pub, plots_aei_pub, 
                     ncol = 1, nrow = 3)

annotate_figure(pub_page,
                top = text_grob("GLCB vs. Classic Acquisition Functions", color = "black", face = "bold", size = 14),
                bottom = text_grob("Bayesian optimization of graphene quality depending on laser irradiation time
60 runs per Acquisition Function with 90 evaluations and initial sample size 10 each
Error bars represent bootstrapped 0.95-CI of incumbent mean best target value
EI = Expected Improvement, LCB = Lower Confidence Bound, AEI = Augmented Expected Improvement, 
GLCB-1-100 means rho = 1 and c = 100. tau = 1 for all GLCBs and for LCB.
", color = "black", face = "bold", size = 10))




pub_page_2 = ggarrange(
  plots_alcb_pub, plots_eqi_pub, plots_se_pub, 
  ncol = 1, nrow = 3)

annotate_figure(pub_page_2,
                top = text_grob("GLCB vs. Classic Acquisition Functions", color = "black", face = "bold", size = 14),
                bottom = text_grob("Bayesian optimization of graphene quality depending on laser irradiation time
60 runs per Acquisition Function with 90 evaluations and initial sample size 10 each
Error bars represent bootstrapped 0.95-CI of incumbent mean best target value
ALCB = Adaptive Lower Confidence Bound, EQI = Expected Quantile Improvement, SE = Standard Error
GLCB-1-100 means rho = 1 and c = 100. tau = 1 for all GLCBs. Adaptive LCB uses different values for tau
", color = "black", face = "bold", size = 10))







