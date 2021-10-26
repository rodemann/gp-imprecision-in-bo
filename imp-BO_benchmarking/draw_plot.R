library(ggplot2)
library(tidyverse)
#library(wesanderson)
library(RColorBrewer)
library(ggsci)
library(ggshadow)



draw_plot <- function(fun, results_list, initial_design_size, pal, configs){
  plot <- ggplot()
  BO_paths_fun <- results_list[[fun]]
  
    for (k in configs) {
      BO_paths_fun_config <- lapply(BO_paths_fun, "[[", k)
      
      #BO_paths_global_min <- lapply(BO_paths, min)
      
      BO_paths_fun_config <- matrix(unlist(BO_paths_fun_config), ncol = length(BO_paths_fun_config)) %>% as.data.frame()
      #remove initial design
      BO_paths_initial <- BO_paths_fun_config %>% slice_head(n = init_design)
      BO_paths_optim <- BO_paths_fun_config %>% slice_tail(n = nrow(BO_paths_fun_config) - init_design)
      #get lower bound/upper bound/mean per iteration:
      BO_paths_sd <- apply(BO_paths_optim, 1, sd)
      BO_paths_mop <- apply(BO_paths_optim, 1, mean)
      BO_paths_ub_per_iter <- BO_paths_mop + BO_paths_sd #qnorm(.975) * BO_paths_sd/sqrt(ncol(BO_paths_optim))
      BO_paths_lb_per_iter <- BO_paths_mop - BO_paths_sd #qnorm(.975) * BO_paths_sd/sqrt(ncol(BO_paths_optim))
      
      paths <- data.frame(iter = 1:nrow(BO_paths_optim), "Upper CB" = BO_paths_ub_per_iter, 
                          "Lower CB" = BO_paths_lb_per_iter,
                          "Mean Target Value" = BO_paths_mop)
      
      plot <- plot + geom_point(data = paths, aes(x = iter, y = Mean.Target.Value),
                                color = pal[k], show.legend = FALSE) + 
        geom_line(data = paths, aes(x = iter, y = Mean.Target.Value), color = pal[k]) #+
        #geom_errorbar(data = paths, aes(x = iter, ymin = Lower.CB, 
        #                                ymax = Upper.CB), colour = pal[k]) 
      
    }
  #plot <- plot + scale_color_discrete(name = "Kernel", labels = kernel_names)
  plot <- plot + theme(panel.background = element_rect(fill = "#575656"))
  return(plot)
  }
  

  