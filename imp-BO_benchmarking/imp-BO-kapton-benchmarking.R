

source("data/make-kapton-rf.R")
source("imprecise-bayes-opt-plug-in/makeMBOInfillCritGLCB.R")
source("imprecise-bayes-opt-plug-in/initCrit.InfillCritGLCB.R")

source("imprecise-bayes-opt-parallel/imp_BO_univariate.R")
source("imprecise-bayes-opt-parallel/imp_BO_univariate_batch.R")

# save console output of experiments here
#sink("imp-BO_benchmarking/results/console-output-imp-BO-tests-init-10-budget-90-n-60-funs1-15.txt")

# globally only one target fun
fun <- kapton_fun_rf
# define sample size (number of BO runs per test function)
n <- 40
# define total Budget of evaluations per BO run
budget <- 90   
# define initial design size
init_design <- 10
# list that is used inside foreach
results_list <- list()

# # parallelize over functions WARNING only tested on linux  
# cl <- parallel::makeCluster(number_of_funs)
# doParallel::registerDoParallel(cl)
# 
# results_list <- foreach::foreach(i = 1:number_of_funs, 
#                                  .packages = c("mlrMBO", "smoof", "DiceKriging", "soobench")) %dopar% {


for (i in 1:2) {
  print(Sys.time())
  results_one_design <- list()
  for (j in 1:n) {
    print(j)
    
    ## same design for all approaches
    # unbiased (1) or biased (2) sample
    if(i == 1)
      design <- generateDesign(n = 10L, par.set = parameter_set, fun = lhs::randomLHS)
    # biased sample
    if(i == 2){ # biased design
      parameter_set_biased = makeParamSet(makeNumericParam("x", lower = 12000, upper = 15000))
      design <- generateDesign(n = 10L, par.set = parameter_set_biased, fun = lhs::randomLHS)
      }
    # set Control Argument of BO 
    ctrl <- makeMBOControl(propose.points = 1L)
    # iters = budget for classic bo
    ctrl <- setMBOControlTermination(ctrl, iters = budget)
    #use EI globally as infill crit (expect for GLCB of course)
    ctrl <- setMBOControlInfill(ctrl, crit = makeMBOInfillCritCB(cb.lambda = 1), opt = "focussearch",
                                opt.focussearch.points = 200, opt.focussearch.maxit = 2)
    
    ## classic bo with classic GP with powexp
    lrn_classic <- makeLearner("regr.km", covtype = "powexp", predict.type = "se", optim.method = "gen",
                               control = list(trace = FALSE), config = list(on.par.without.desc = "warn"))
    # ensure numerical stability in km {DiceKriging} cf. github issue and recommendation by Bernd Bischl
    y = fun(design)
    Nuggets = 1e-8*var(y)
    lrn_classic = setHyperPars(learner = lrn_classic, nugget=Nuggets)
    #start classic bo with LCB and lambda = 1
    cl_bo_res_lcb <- mbo(fun, design, ctrl, learner = lrn_classic, show.info = FALSE)
    # start classic BO with EI
    ctrl = setMBOControlInfill(ctrl, crit = makeMBOInfillCritEI())
    cl_bo_res_ei <- mbo(fun, design, ctrl, learner = lrn_classic, show.info = FALSE)
    
    # parallel bo with one imprecision degree
    imprecision_degree <- 50
    ctrl <- setMBOControlTermination(ctrl, iters = floor(budget/3))
      parallel_imp_bo_res <- imp_BO_univariate(fun = fun, design = design, control = ctrl, 
                                               base_kernel = "powexp", imprecision_degree = imprecision_degree)

    # batch bo with multiple imprecision degrees and 3 batches
    imprecision_degree <- c(1,10,100) 
    number_of_batches <- 3
    number_of_models_batch_1 <- 2 * length(imprecision_degree) + 1
    number_of_models_batch_2 <- (number_of_models_batch_1 - 1)/2
    number_of_models_batch_3 <- (number_of_models_batch_2 - 1)/2
    number_of_models_per_batch <- c(number_of_models_batch_1, 
                                    number_of_models_batch_2, 
                                    number_of_models_batch_3)
    # set iterations 
    #max_iters_per_batch <- floor(budget/(number_of_models_per_batch)) 
    # decide for # of iters in each batch
    iters_per_batch_per_model <- c(6,10,18)
    # check whether setting is allowed
    total_iters <- sum(number_of_models_per_batch * iters_per_batch_per_model) 
    if(total_iters <= budget){
      #print("budget met")
    }else
      warning("budget not met")
    
    
    batch_imp_bo_res <- imp_BO_univariate_batch(fun = fun, design = design, control = ctrl, 
                                                  base_kernel = "powexp", imprecision_degree = imprecision_degree,
                                                  number_of_batches = number_of_batches, 
                                                  iters_per_batch_per_model = iters_per_batch_per_model)
    # plug-in-bo with Generalized Lower Confidence Bound
    # set Control Argument of BO
    ctrl <- setMBOControlInfill(ctrl, crit = makeMBOInfillCritGLCB(imprecision = 50)) # defaults to lambda=1, rho = 1
    ctrl <- setMBOControlTermination(ctrl, iters = budget) # no parallelization
    glcb_bo_res <- mbo(fun, design, ctrl, learner = NULL, show.info = FALSE)
    
    opt_paths_raw <- list(getOptPathY(cl_bo_res_lcb[["opt.path"]]), getOptPathY(cl_bo_res_ei[["opt.path"]]), parallel_imp_bo_res$opt_path_y,
                          batch_imp_bo_res$opt_path_y_global, getOptPathY(glcb_bo_res[["opt.path"]]))
    # ATTENTION only for minimization (no problem here, since we restrict our tests to it)
    # opt_paths <- lapply(opt_paths_raw, function(proposals){
    #   for (o in 2:length(proposals)) {
    #     if(proposals[o] > proposals[o - 1])
    #       proposals[o] = proposals[o - 1]
    #   }
    #   proposals
    # })
    # This one for maximization
    opt_paths <- lapply(opt_paths_raw, function(proposals){
      for (o in 2:length(proposals)) {
        if(proposals[o] < proposals[o - 1])
          proposals[o] = proposals[o - 1]
      }
      proposals
    })
    
    
    results_one_design[[j]] <- opt_paths
    
  }
  
  
  results_list[[i]] <- results_one_design 
}
#stopCluster(cl)

#results_list

save(results_list, file = paste(getwd(),"/imp-BO_benchmarking/results/results-imp-BO-kapton-init-10-budget-90-n-40-paralell-fixed" ,sep=""))

# look at older console output
#rstudioapi::writeRStudioPreference("console_max_lines", 300)

#results_one_fun[[1]]


# 
# # Mean Optimization Paths (mop)
# w_paths_mop <- list()
# uw_paths_mop <- list()
# w_paths_mop_sd <- list()
# uw_paths_mop_sd <- list()
# 
# 
# # weighted 
# for (i in 1:length(funs_to_test)) {
#   BO_paths_all_means <- matrix(nrow = iters, ncol = length(funs_to_test))
#   
#   BO_paths <- global_res_weightedML[[i]]
#   
#   BO_paths <- matrix(unlist(BO_paths), ncol = length(BO_paths))
#   BO_paths <- as.data.frame(BO_paths)
#   
#   # remove initial design
#   BO_paths_initial <- BO_paths %>% dplyr::slice_head(n = init_design)
#   BO_paths_optim <- BO_paths %>% dplyr::slice_tail(n = nrow(BO_paths) - init_design)
#   
#   # log scale
#   #BO_paths_optim <- log(BO_paths_optim) 
#   
#   # get lower bound/upper bound/mean per iteration:
#   BO_paths_sd <- apply(BO_paths_optim, 1, sd)
#   BO_paths_mean_per_iter <- apply(BO_paths_optim, 1, mean)
#   
#   w_paths_mop[[i]] <- BO_paths_mean_per_iter
#   w_paths_mop_sd[[i]] <- BO_paths_sd
# }

# results_df <- data.frame(
#   "Standard BO" = mean_optima[1],
#   "Parallel imprecise BO" = mean_optima[2],
#   "Batch imprecise BO" = mean_optima[3],
#   "GLCB" = mean_optima[4]
# )



