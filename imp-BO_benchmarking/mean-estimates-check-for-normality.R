library(boot) 

# check for normality of mean estimates 
# load results list here
# load()

BO_path <- results_list[[1]]

k = 5
  BO_paths_fun_config <- lapply(BO_paths_fun, "[[", k)
  
  #BO_paths_global_min <- lapply(BO_paths, min)
  
  BO_paths_fun_config <- matrix(unlist(BO_paths_fun_config), ncol = length(BO_paths_fun_config)) %>% as.data.frame()
  #remove initial design
  BO_paths_initial <- BO_paths_fun_config %>% slice_head(n = init_design)
  BO_paths_optim <- BO_paths_fun_config %>% slice_tail(n = nrow(BO_paths_fun_config) - init_design)
  
  as.matrix(BO_paths_optim)[40,] %>% hist(breaks = seq(2.5,4,0.1))
  as.matrix(BO_paths_optim)[25,] %>% plot
  # all historgramms
  apply(as.matrix(BO_paths_optim), 1, hist, breaks = seq(2.5,4,0.1))
  
  #get lower bound/upper bound/mean per iteration:
  BO_paths_sd <- apply(BO_paths_optim, 1, sd)
  BO_paths_mop <- apply(BO_paths_optim, 1, mean)
  
  
  wilcox.test(as.matrix(BO_paths_optim)[40,], conf.int = TRUE, conf.level = 0.95)
  
  
  ## bootstrap CIs
  optima = as.matrix(BO_paths_optim)[15,]
  hist(optima) # Histogram of the data
  
  
  
  # bootstrapping with 1000 replications 
  results <- boot(data=optima, statistic=Bmean, R=1000)
  
  # view results
  results 
  plot(results)
  
  # get 95% confidence interval 
  lower <- boot.ci(results, type=c("norm", "basic", "perc", "bca"))[["basic"]][4]
  upper <- boot.ci(results, type=c("norm", "basic", "perc", "bca"))[["basic"]][5]
  
  
  
  
  
  
  