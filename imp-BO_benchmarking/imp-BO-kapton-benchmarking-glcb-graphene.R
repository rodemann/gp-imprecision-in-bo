# this file runs a simulation of n = 60 BO runs with a Budget
# of 90 evaluations and initial design of size 10
# a detailed description of the experiment can be found in the 
# thesis in section 6.6.1

library(mlrMBO)
library(rgenoud)
library(BBmisc)
library(DiceKriging)
library(ggplot2)
library(ggpubr)

# set seed
set.seed(628496)
 
# source graphene (kapton) data and respective RF as target function (including visualization)
source("data/make-kapton-rf.R") # time
# source files that integrate GLCB into mlrMBO
source("imprecise-bayes-opt-plug-in/makeMBOInfillCritGLCB.R")
source("imprecise-bayes-opt-plug-in/initCrit.InfillCritGLCB.R")


# globally only one target fun
fun <- kapton_fun_rf
# define sample size (number of BO runs per test function)
n <- 60
# define total Budget of evaluations per BO run
budget <- 90   
# define initial design size
init_design <- 10
# list that is used inside foreach
results_list <- list()

# # OPTIONAL parallelize over functions WARNING only tested on linux  
# cl <- parallel::makeCluster(number_of_funs)
# doParallel::registerDoParallel(cl)
# results_list <- foreach::foreach(i = 1:number_of_funs, 
#                                  .packages = c("mlrMBO", "smoof", "DiceKriging", "soobench")) %dopar% {


for (i in 1:1) { # allows for assessing more than one function or more than one initial sampling strategies
  results_one_design <- list()
  for (j in 1:n) {
    print(j)
    print(Sys.time())
    
    ## same design for all approaches, sampled anew each iteration of 1:n
    design <- generateDesign(n = 10L, par.set = parameter_set, fun = lhs::randomLHS)

    # set Control Argument of BO 
    ctrl <- makeMBOControl(propose.points = 1L)
    # iters = budget 
    ctrl <- setMBOControlTermination(ctrl, iters = budget)
    #set control globally 
    ctrl <- setMBOControlInfill(ctrl, crit = makeMBOInfillCritCB(cb.lambda = 1), opt = "focussearch",
                                opt.focussearch.points = 1000, opt.focussearch.maxit = 5)
    
    ## classic bo with classic GP with powexp kernel
    lrn_classic <- makeLearner("regr.km", covtype = "powexp", predict.type = "se", optim.method = "gen",
                               control = list(trace = FALSE), config = list(on.par.without.desc = "warn"))
    # ensure numerical stability in km {DiceKriging} cf. github issue and recommendation by Bernd Bischl
    y = fun(design)
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
    

    
    opt_paths_raw <- list(getOptPathY(cl_bo_res_lcb[["opt.path"]]), 
                          getOptPathY(cl_bo_res_alcb[["opt.path"]]),
                          getOptPathY(cl_bo_res_ei[["opt.path"]]),
                          getOptPathY(cl_bo_res_aei[["opt.path"]]),
                          getOptPathY(cl_bo_res_eqi[["opt.path"]]),
                          getOptPathY(cl_bo_res_se[["opt.path"]]),
                          getOptPathY(glcb_1_50_bo_res[["opt.path"]]),
                          getOptPathY(glcb_1_100_bo_res[["opt.path"]]), 
                          getOptPathY(glcb_10_100_bo_res[["opt.path"]]))
                 
    
    # ATTENTION only for minimization (no problem here, since we restrict our tests to it)
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
  print(Sys.time())
}



# save results in repo so that it can be accessed and visualized later
save(results_list, file = paste(getwd(),"/imp-BO_benchmarking/results/results-imp-BO-graphene-glcb" ,sep=""))
 
