library(ggplot2)
library(tidyverse)
library(RColorBrewer)
library(ggsci)
library(boot)


draw_plot_boot_facet <- function(fun, results_list, initial_design_size, bench, pal, configs, configs_indices){
  BO_paths_fun <- results_list[[fun]]
  
  paths <- data.frame(iter = vector(), "Upper CB" = vector(), 
                      "Lower CB" = vector(), "Mean Target Value" = vector(),
                      "Configuration" = character())
  
  for (k in configs_indices) {
    BO_paths_fun_config <- lapply(BO_paths_fun, "[[", k)
    
    #BO_paths_global_min <- lapply(BO_paths, min)
    BO_paths_fun_config <- matrix(unlist(BO_paths_fun_config), ncol = length(BO_paths_fun_config)) %>% as.data.frame()
    #remove initial design
    BO_paths_initial <- BO_paths_fun_config %>% slice_head(n = initial_design_size)
    BO_paths_optim <- BO_paths_fun_config %>% slice_tail(n = nrow(BO_paths_fun_config) - initial_design_size)
    #get lower bound/upper bound/mean per iteration:
    BO_paths_sd <- apply(BO_paths_optim, 1, sd)
    BO_paths_mop <- apply(BO_paths_optim, 1, mean)
    #BO_paths_ub_per_iter <- BO_paths_mop + qnorm(.975) * BO_paths_sd/sqrt(ncol(BO_paths_optim))
    #BO_paths_lb_per_iter <- BO_paths_mop - qnorm(.975) * BO_paths_sd/sqrt(ncol(BO_paths_optim))
    
    BO_paths_ub_per_iter <- apply(BO_paths_optim, 1, function(optima){
      boot_means <- boot(data=optima, statistic=Bmean, R=1000)
      upper <- boot.ci(boot_means, type="basic")[["basic"]][5]
      upper
    })
    BO_paths_lb_per_iter <- apply(BO_paths_optim, 1, function(optima){
      boot_means <- boot(data=optima, statistic=Bmean, R=1000)
      lower <- boot.ci(boot_means, type="basic")[["basic"]][4]
      lower
    })
    
    
    paths_k <- data.frame(iter = 1:nrow(BO_paths_optim), "Upper CB" = BO_paths_ub_per_iter, 
                          "Lower CB" = BO_paths_lb_per_iter,
                          "Mean Target Value" = BO_paths_mop,
                          "Configuration" = configs[k])
    paths <- rbind(paths, paths_k)
  }
  #browser()
  paths_only_bench <- dplyr::filter(paths, Configuration == bench)
  #paths_only_bench <- transform(paths_only_bench, Configuration = NULL)
  paths_no_bench <- dplyr::filter(paths, Configuration != bench)
  names(paths_only_bench) <- lapply(names(paths_only_bench), paste, ".bench", sep = "")
  paths_plot <- cbind(paths_no_bench, paths_only_bench)
  names(paths_plot)
  
    plot <- ggplot(data = paths_plot, group = Configuration) + 
    geom_point(aes(x = iter, y = Mean.Target.Value, colour = Configuration))  + 
    geom_line(aes(x = iter, y = Mean.Target.Value, colour = Configuration)) +
    geom_errorbar(aes(x = iter, ymin = Lower.CB, 
                                    ymax = Upper.CB, colour = Configuration)) +
    geom_point(aes(x = iter.bench, y = Mean.Target.Value.bench, colour = Configuration.bench))  + 
    geom_line(aes(x = iter.bench, y = Mean.Target.Value.bench, colour = Configuration.bench)) +
    geom_errorbar(aes(x = iter.bench, ymin = Lower.CB.bench, 
                                    ymax = Upper.CB.bench, colour = Configuration.bench)) +
      scale_color_discrete(breaks = configs[configs_indices], labels = configs[configs_indices]) # TODO ensure same order in all plots
  #plot <- plot + scale_color_discrete(name = "Kernel", labels = kernel_names)
  plot <- plot + theme(panel.background = element_rect(fill = "#575656")) + 
    theme(legend.position="right") +
    scale_color_manual(values=pal, breaks = configs[configs_indices]) +
    facet_wrap(vars(Configuration)) +
    scale_color_discrete(breaks = configs[configs_indices], labels = configs[configs_indices])  # TODO ensure same order in all plots
    
  return(plot)
}



# function to obtain the mean in bootstrapping
Bmean <- function(data, indices) {
  d <- data[indices] # allows boot to select sample 
  return(mean(d))
} 


