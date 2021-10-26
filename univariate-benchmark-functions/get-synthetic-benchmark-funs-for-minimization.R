source("univariate-benchmark-functions/univariate-test-functions-smoof.R")
source("univariate-benchmark-functions/univariate-test-functions-soobench.R")

# convert soobench objects to (S3) smoof objects (compatible with mlrMBO)
soobench_all_funs <- lapply(soobench_all_funs, function(fun){
       makeSingleObjectiveFunction(fn = fun, name = function_name(fun), 
                                   par.set = makeNumericParamSet("x", len = 1L,
                                             lower = lower_bounds(fun),
                                             upper = upper_bounds(fun)),
                                   global.opt.value = global_minimum(fun)$value,
                                   global.opt.params = global_minimum(fun)$par)
})

all_benchmark_funs <- c(smoof_all_funs, soobench_all_funs)

# guarantee minimization
all_benchmark_funs <- lapply(all_benchmark_funs, function (fun){
  if(shouldBeMinimized(fun) == FALSE)
    convertToMinimization(fun)
  else
    fun
})

# remove chained functions (globally 0, cause numerical trouble)
all_benchmark_funs <- all_benchmark_funs[-c(21,22,30)]

lapply(rev(all_benchmark_funs), plot)

