source("PROBO/makeMBOInfillCritGLCB.R")
source("PROBO/initCrit.InfillCritGLCB.R")

fun <- smoof::makeAckleyFunction(1)
parameter_set <- ParamHelpers::getParamSet(fun)
design <- generateDesign(n = 10L, par.set = parameter_set, fun = lhs::randomLHS)
iters = 5L

# set Control Argument of BO 
ctrl = makeMBOControl(propose.points = 1L)
ctrl = setMBOControlTermination(ctrl, iters = iters)
infill_crit = makeMBOInfillCritGLCB()
#infill_crit = makeMBOInfillCritCB()
ctrl = setMBOControlInfill(ctrl, crit = infill_crit, opt = "focussearch")#,
                           #opt.focussearch.points = 200, opt.focussearch.maxit = 1)

lrn = makeLearner("regr.km", covtype = "powexp", predict.type = "se", optim.method = "gen", 
                          control = list(trace = FALSE), config = list(on.par.without.desc = "warn"))
# ensure numerical stability in km {DiceKriging} cf. github issue and recommendation by Bernd Bischl 
y = apply(design, 1, fun)
Nuggets = 1e-8*var(y)
lrn = setHyperPars(learner = lrn, nugget=Nuggets)

mbo(fun = fun, design = design, control = ctrl, learner = lrn)


