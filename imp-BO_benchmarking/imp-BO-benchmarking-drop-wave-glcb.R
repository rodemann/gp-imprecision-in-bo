library(mlrMBO)

source("univariate-benchmark-functions/univariate-test-functions-smoof.R")
source("univariate-benchmark-functions/univariate-test-functions-soobench.R")
source("univariate-benchmark-functions/get-synthetic-benchmark-funs-for-minimization.R")
source("imprecise-bayes-opt-plug-in/makeMBOInfillCritGLCB.R")
source("imprecise-bayes-opt-plug-in/initCrit.InfillCritGLCB.R")

source("imprecise-bayes-opt-parallel/imp_BO_univariate.R")
source("imprecise-bayes-opt-parallel/imp_BO_univariate_batch.R")

# globally only one target fun
fun <- all_benchmark_funs[[9]] # drop-wave-function
parameter_set <- getParamSet(fun)

# define sample size (number of BO runs per test function)
n <- 60
# define total Budget of evaluations per BO run
budget <- 60   
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


for (i in 1:1) {
  print(Sys.time())
  results_one_design <- list()
  for (j in 1:n) {
    print(j)
    print(Sys.time())
    
    ## same design for all approaches
    # unbiased (1) or biased (2) sample
    if(i == 1)
      design <- generateDesign(n = 10L, par.set = parameter_set, fun = lhs::randomLHS)
    # # biased sample
    # if(i == 2){ # biased design
    #   parameter_set_biased = makeParamSet(makeNumericParam("x", lower = 12000, upper = 15000))
    #   design <- generateDesign(n = 10L, par.set = parameter_set_biased, fun = lhs::randomLHS)
    # }
    # set Control Argument of BO 
    ctrl <- makeMBOControl(propose.points = 1L)
    # iters = budget for classic bo
    ctrl <- setMBOControlTermination(ctrl, iters = budget)
    #set control globally 
    ctrl <- setMBOControlInfill(ctrl, crit = makeMBOInfillCritCB(cb.lambda = 1), opt = "focussearch",
                                opt.focussearch.points = 1000, opt.focussearch.maxit = 5)
    
    ## classic bo with classic GP with powexp
    lrn_classic <- makeLearner("regr.km", covtype = "powexp", predict.type = "se", optim.method = "gen",
                               control = list(trace = FALSE), config = list(on.par.without.desc = "warn"))
    # ensure numerical stability in km {DiceKriging} cf. github issue and recommendation by Bernd Bischl
    y = apply(design, 1, fun)
    Nuggets = 1e-8*var(y)
    lrn_classic = setHyperPars(learner = lrn_classic, nugget=Nuggets)
    #start classic bo with LCB and lambda = 1
    cl_bo_res_lcb <- mbo(fun, design, ctrl, learner = lrn_classic, show.info = FALSE)
    
    # bo with adaptive LCB    
    ctrl <- setMBOControlInfill(ctrl, crit = makeMBOInfillCritAdaCB())
    cl_bo_res_alcb <-mbo(fun, design, ctrl, learner = lrn_classic, show.info = FALSE)
    
    # bo with EI    
    ctrl <- setMBOControlInfill(ctrl, crit = makeMBOInfillCritEI())
    cl_bo_res_ei <-mbo(fun, design, ctrl, learner = lrn_classic, show.info = FALSE)
    
    # bo with augmented EI    
    ctrl <- setMBOControlInfill(ctrl, crit = makeMBOInfillCritAEI())
    cl_bo_res_aei <-mbo(fun, design, ctrl, learner = lrn_classic, show.info = FALSE)
    
    # bo with infill crit = expected quantile improvement    
    ctrl <- setMBOControlInfill(ctrl, crit = makeMBOInfillCritEQI())
    cl_bo_res_eqi <-mbo(fun, design, ctrl, learner = lrn_classic, show.info = FALSE)
    
    # bo with infill crit = se    
    ctrl <- setMBOControlInfill(ctrl, crit = makeMBOInfillCritStandardError())
    cl_bo_res_se <-mbo(fun, design, ctrl, learner = lrn_classic, show.info = FALSE)
    
    
    # plug-in-bo with Generalized Lower Confidence Bound
    # set Control Argument of BO
    ctrl <- setMBOControlInfill(ctrl, crit = makeMBOInfillCritGLCB(imprecision = 50, cb.rho = 1, base_kernel = "powexp")) 
    glcb_1_50_bo_res <- mbo(fun, design, ctrl, learner = lrn_classic, show.info = FALSE)
    
    ctrl <- setMBOControlInfill(ctrl, crit = makeMBOInfillCritGLCB(imprecision = 100, cb.rho = 1, base_kernel = "powexp")) 
    glcb_1_100_bo_res <- mbo(fun, design, ctrl, learner = lrn_classic, show.info = FALSE)
    
    ctrl <- setMBOControlInfill(ctrl, crit = makeMBOInfillCritGLCB(imprecision = 100, cb.rho = 10, base_kernel = "powexp")) 
    glcb_10_100_bo_res <- mbo(fun, design, ctrl, learner = lrn_classic, show.info = FALSE)
    
    
    
    opt_paths_raw <- list(getOptPathY(cl_bo_res_lcb[["opt.path"]]), getOptPathY(cl_bo_res_alcb[["opt.path"]]),
                          getOptPathY(cl_bo_res_ei[["opt.path"]]), getOptPathY(cl_bo_res_aei[["opt.path"]]),
                          getOptPathY(cl_bo_res_eqi[["opt.path"]]), 
                          getOptPathY(cl_bo_res_se[["opt.path"]]), getOptPathY(glcb_1_50_bo_res[["opt.path"]]),
                          getOptPathY(glcb_1_100_bo_res[["opt.path"]]), getOptPathY(glcb_10_100_bo_res[["opt.path"]]))
    
    
    # ATTENTION only for minimization (no problem here, since we restrict our tests to it)
    opt_paths <- lapply(opt_paths_raw, function(proposals){
      for (o in 2:length(proposals)) {
        if(proposals[o] > proposals[o - 1])
          proposals[o] = proposals[o - 1]
      }
      proposals
    })
    # This one for maximization
    # opt_paths <- lapply(opt_paths_raw, function(proposals){
    #   for (o in 2:length(proposals)) {
    #     if(proposals[o] < proposals[o - 1])
    #       proposals[o] = proposals[o - 1]
    #   }
    #   proposals
    # })
    
    
    results_one_design[[j]] <- opt_paths
    
  }
  
  results_list[[i]] <- results_one_design 
  print(Sys.time())
}
#stopCluster(cl)

#results_list

save(results_list, file = paste(getwd(),"/imp-BO_benchmarking/results/results-imp-BO-synthetic-glcb-drop-wave" ,sep=""))

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



