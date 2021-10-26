library(scales)
source("imp-BO_benchmarking/draw_plot.R")
source("imp-BO_benchmarking/draw_plot_boot.R")
source("imp-BO_benchmarking/draw_plot_boot_facet.R")

source("imp-BO_benchmarking/draw_legend_kapton.R")
#source("data/make-kapton-rf.R")

# load results list:
#load("imp-BO_benchmarking/results/results-imp-BO-kapton-glcb-unbiased-and-biased")
#load("imp-BO_benchmarking/results/results-imp-BO-kapton-glcb-5")
load("imp-BO_benchmarking/results/results-imp-BO-kapton-init-10-budget-90-n-40-paralell-fixed")

# select palette
#pal <- wes_palette("Zissou1", 5)
#pal <- c("steelblue", "magenta", "forestgreen", "darkred", "orange1")
#pal <- brewer.pal(5, "Oranges")
pal <- pal_ucscgb("default")(9)

safe_colorblind_palette <- c("#88CCEE", "#CC6677", "#DDCC77", "#117733", "#332288", "#AA4499", 
                             "#44AA99", "#999933", "#882255")
pal <- safe_colorblind_palette
#pal = c(pal[4], pal[1:3])
#pal <- pal_tron("legacy")(9)
#pal <- viridis(9)
#pal <- c()

optimum_col = "#ff00f7"

# choose function


# set pal globally for comparison
pal = pal[1:4]


configs = c("LCB", "Classic BO", "Parallel Hedging", "Batch-Wise Speed Up", "glcb")
configs_indices = c(2,3,4)

plots = list()
for (fun in 1:1) {
  #fun_name <- getName(synth_test_functions[[fun]])
  # store all mops (mean opt paths) here
  #BO_paths_all_mops <- matrix(nrow = budget, ncol = configs)
  plot = draw_plot_boot_facet(fun = fun, results_list = results_list, bench = "Classic BO",
                              initial_design_size = 10, pal = pal, configs = configs, configs_indices = configs_indices) +
    labs(x = "Evaluations", y = "Mean Best Target Value", col = "Acquisition Function") +
    # geom_hline(yintercept = global.opt, linetype = "dashed",  color = optimum_col) + 
    labs(subtitle = 
           "Bayesian Optimization of Graphene Production
40 runs per method with 90 evaluations and initial sample size 10 each
Error bars represent bootstrapped 0.95-CI of incumbent mean best target value
Parallel hedging prior-robust BO with c = 50 (3 models, 30 evaluations each)
Batch-wise speed-up prior-robust BO with c = 1, 10, 100 (3 models, 30 evaluations each)
Same Configurations (AF, Infill Optimizers) for classic BO and both modifications
         ") +
    #Infill Optimization: Focus Search with 1000 points per iteration and 5 maximal restarts = 5") #+
    #ylim(c(3.2,3.8))
    scale_fill_discrete(name = "")
  
  plots[[fun]] = plot
}

pal = cbbPalette
show_col(pal)
pal[1] = "black"
pal[c(2,3)] <- pal[c(3,2)]
pal[c(3,4)] <- pal[c(4,3)]
pal[c(1,3)] = pal[c(3,1)]
pal[c(2,4)] = pal[c(4,2)]
pal[c(2,3)] = pal[c(3,2)]
pal[c(1,3)] = pal[c(3,1)]

plots[[1]] + theme_update() + scale_color_manual(values = pal, breaks = configs[c(2,3,4)])   #+scale_color_manual()



pub_page = ggarrange(plots_ei_pub, plots_lcb_pub,
                     ncol = 1, nrow = 2)

annotate_figure(pub_page,
                top = text_grob("GLCB vs. EI and LCB (Chung-Reynolds)", color = "black", face = "bold", size = 14),
                bottom = text_grob("Bayesian optimization of Chung-Reynolds Function
40 runs per Acquisition Function with 90 evaluations (20 shown) and initial sample size 10 each
Error bars represent bootstrapped 0.95-CI of incumbent mean best target value
EI = Expected Improvement, LCB = Lower Confidence Bound
GLCB-1-100 means rho = 1 and c = 100. tau = 1 for all GLCBs and for LCB.", 
                                   color = "black", face = "bold", size = 10))








