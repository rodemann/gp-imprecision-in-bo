# this file computes CIs and creates the figures for
# glcb benchmarking results as presented in the thesis


source("imp-BO_benchmarking/draw_plot.R")
source("imp-BO_benchmarking/draw_plot_boot.R")
source("imp-BO_benchmarking/draw_plot_boot_facet.R")
source("imp-BO_benchmarking/draw_legend_kapton.R")
# ggplot2 is loaded within these dependencies
library(ggpubr)

# select results
# load("imp-BO_benchmarking/results/results-imp-BO-kapton-power-glcb-complete")
# load("imp-BO_benchmarking/results/results-imp-BO-wind-humidity")
#load("imp-BO_benchmarking/results/results-imp-BO-heartbeat-2")
load("imp-BO_benchmarking/results/results-imp-BO-graphene-glcb")

# selection of color palettes
pal_ucs <- pal_ucscgb("default")(9)
safe_colorblind_palette <- c("#88CCEE", "#CC6677", "#DDCC77", "#117733", "#332288", "#AA4499", 
                             "#44AA99", "#999933", "#882255")
cbbPalette <- c("#000000", "#E69F00", "#56B4E9", "#009E73", "#F0E442", "#0072B2", "#D55E00", "#CC79A7")

# choose colorblind-friendly palette
pal <- safe_colorblind_palette
optimum_col = "#ff00f7"

# set pal globally for comparison
pal = pal[1:4]
# define configurations from the experiments
configs = c("LCB", "ALCB", "EI", "AEI", "EQI", "SE", "GLCB-1-50", "GLCB-1-100", "GLCB-10-100")


# draw plot and compute CIs for GLCB vs EI
configs_indices = c(3,7,8,9)
fun = 1
plots_ei = draw_plot_boot_facet(fun = fun, results_list = results_list, bench = "EI",
                              initial_design_size = 10, pal = pal, configs = configs, configs_indices = configs_indices) +
    labs(x = "Evaluations", y = "Mean Best Target Value", col = "Acquisition Function") 

  
# draw plot and compute CIs for GLCB vs LCB
configs_indices = c(1,7,8,9)

plots_lcb = draw_plot_boot_facet(fun = fun, results_list = results_list, bench = "LCB",
                              initial_design_size = 10, pal = pal, configs = configs, configs_indices = configs_indices) +
    labs(x = "Evaluations", y = "Mean Best Target Value", col = "Acquisition Function") 


# draw plot and compute CIs for GLCB vs AEI
configs_indices = c(4,7,8,9)
bench = "AEI"
plots_aei = draw_plot_boot_facet(fun = fun, results_list = results_list, bench = bench,
                                 initial_design_size = 10, pal = pal, configs = configs, configs_indices = configs_indices) +
  labs(x = "Evaluations", y = "Mean Best Target Value", col = "Acquisition Function") 

# draw plot and compute CIs for GLCB vs ALCB
configs_indices = c(2,7,8,9)
bench = "ALCB"
plots_alcb = draw_plot_boot_facet(fun = fun, results_list = results_list, bench = bench,
                                  initial_design_size = 10, pal = pal, configs = configs, configs_indices = configs_indices) +
  labs(x = "Evaluations", y = "Mean Best Target Value", col = "Acquisition Function") 


# draw plot and compute CIs for GLCB vs EQI
configs_indices = c(5,7,8,9)
bench = "EQI"
plots_eqi = draw_plot_boot_facet(fun = fun, results_list = results_list, bench = bench,
                                  initial_design_size = 10, pal = pal, configs = configs, configs_indices = configs_indices) +
  labs(x = "Evaluations", y = "Mean Best Target Value", col = "Acquisition Function") 



# draw plot and compute CIs for GLCB vs SE
configs_indices = c(6,7,8,9)
plots_se = draw_plot_boot_facet(fun = fun, results_list = results_list, bench = "SE",
                              initial_design_size = 10, pal = pal, configs = configs, configs_indices = configs_indices) +
    labs(x = "Evaluations", y = "Mean Best Target Value", col = "Acquisition Function") 


# change order of configs to get correct order of legend in ggplot
configs_lcb = configs[c(1,7,8,9)]
configs_ei = configs[c(3,7,8,9)]
configs_alcb = configs[c(2,7,8,9)]
configs_aei = configs[c(4,7,8,9)]
configs_eqi = configs[c(5,7,8,9)]
configs_se = configs[c(6,7,8,9)]


pal = cbbPalette
pal[c(1,4)] <- pal[c(4,1)]
pal[4] <- "grey85"

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

plots_lcb_pub
plots_ei_pub
plots_aei_pub
plots_alcb_pub
plots_eqi_pub
plots_se_pub


#Optional: get publication ready pages with multiple ggplot objects
pub_page = ggarrange(plots_ei_pub, plots_lcb_pub, plots_aei_pub,
                             ncol = 1, nrow = 3)
pub_page_2 = ggarrange(
  plots_alcb_pub, plots_eqi_pub, plots_se_pub,
  ncol = 1, nrow = 3)

pub_page
pub_page_2




# optional: annotate figures 

# annotate_figure(pub_page,
#                 top = text_grob("GLCB vs. Classic Acquisition Functions (Graphene-Time)", color = "black", face = "bold", size = 14),
#                 bottom = text_grob("Bayesian optimization of graphene quality depending on laser irradiation time
# 60 runs per Acquisition Function with 90 evaluations and initial sample size 10 each
# Error bars represent bootstrapped 0.95-CI of incumbent mean best target value
# EI = Expected Improvement, LCB = Lower Confidence Bound, AEI = Augmented Expected Improvement,
# GLCB-1-100 means rho = 1 and c = 100. tau = 1 for all GLCBs and for LCB.
# ", color = "black", face = "bold", size = 10))
# 
# 
# 
# annotate_figure(pub_page_2,
#                 top = text_grob("GLCB vs. Classic Acquisition Functions (Graphene-Time)", color = "black", face = "bold", size = 14),
#                 bottom = text_grob("Bayesian optimization of graphene quality depending on laser irradiation time
# 60 runs per Acquisition Function with 90 evaluations and initial sample size 10 each
# Error bars represent bootstrapped 0.95-CI of incumbent mean best target value
# ALCB = Adaptive Lower Confidence Bound, EQI = Expected Quantile Improvement, SE = Standard Error
# GLCB-1-100 means rho = 1 and c = 100. tau = 1 for all GLCBs. Adaptive LCB uses different values for tau
# ", color = "black", face = "bold", size = 10))



