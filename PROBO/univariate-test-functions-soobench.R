library(soobench)

# get all soobench test functions that allow 1 dimension 
soobench_objects <- ls("package:soobench")
soobench_funs<- lapply(soobench_objects, function(name){
  if(grepl("generate_", name) == FALSE)
      name <- NULL
      name
})
# drop NULLs
soobench_funs <- soobench_funs[!sapply(soobench_funs, is.null)]
# add dimension argument to strings
soobench_funs <- lapply(soobench_funs, paste, "(dimension = 1)", sep = "")
#expressions
soobench_funs_expr <- lapply(soobench_funs, parse, file = "", n = NULL, prompt = "?",
       keep.source = getOption("keep.source"), srcfile,
       encoding = "unknown")

# call all functions in package that allow one dimension
eval_or_skip <- function (expr) {
  return(tryCatch(eval(expr), error=function(e) NULL))
}
soobench_all_funs<- lapply(soobench_funs_expr, eval_or_skip)
# drop NULLs
soobench_all_funs <- soobench_all_funs[!sapply(soobench_all_funs, is.null)]

# drop funs with infinite domain
soobench_infinite_funs <- list(soobench_all_funs[[5]], soobench_all_funs[[6]], soobench_all_funs[[7]],
                               soobench_all_funs[[8]])
soobench_all_funs_not_inf <- soobench_all_funs[-c(5,6,7,8)]


# let's take a look at all of these guys
lapply(soobench_all_funs_not_inf, plot_1d_soo_function)




