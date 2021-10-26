library(smoof)

# get all smoof test functions that allow 1 dimension 
smoof_objects <- ls("package:smoof")
smoof_funs <- lapply(smoof_objects, function(name){
  if(grepl("make", name) == FALSE)
    name <- NULL
  name
})

# drop NULLs
smoof_funs <- smoof_funs[!sapply(smoof_funs, is.null)]
# add dimension argument to strings
smoof_funs <- lapply(smoof_funs, paste, "(dimension = 1)", sep = "")
#expressions
smoof_funs_expr <- lapply(smoof_funs, parse, file = "", n = NULL, prompt = "?",
                             keep.source = getOption("keep.source"), srcfile,
                             encoding = "unknown")

# call all functions in package that allow one dimension
eval_or_skip <- function (expr) {
  return(tryCatch(eval(expr), error = function(e) NULL))
}
smoof_all_funs<- lapply(smoof_funs_expr, eval_or_skip)

# drop NULLs
smoof_all_funs <- smoof_all_funs[!sapply(smoof_all_funs, is.null)]


# drop functions that throw errors for one dimension
do_or_die <- function (fun) {
  return(tryCatch(do.call(fun, args = list(1)), error = function(e) NULL))
}
smoof_all_funs_called <- lapply(smoof_all_funs, do_or_die)

# # drop NULLs
# nulls_and_nas <- lapply(smoof_all_funs_called, function(x) is.null(x) | is.na(x))
# (is.null(smoof_all_funs_called))
# smoof_all_funs <- smoof_all_funs[]
# # drop NAs
# smoof_all_funs <- smoof_all_funs[!sapply(smoof_all_funs_called, is.na)]

#do.call(smoof_all_funs[[1]], list(1))

# drop by hand
smoof_all_funs <- smoof_all_funs[-c(4, 5, 6, 10, 17, 19, 20)]


# let's take a look at all of these guys
#lapply(smoof_all_funs, plot)


