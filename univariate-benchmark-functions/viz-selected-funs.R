library(smoof)
funs= all_benchmark_funs[c(3,4,6,8,27,31)]
plots = lapply(funs, FUN = plot)
ggpubr::ggarrange(plotlist = plots)

