draw_legend_kapton <- function(pal){ 
  config_names <- c("BO with LCB", "BO with EI", "Imprecise BO (Parallel)", "Imprecise BO (Batch)", 
                    "BO with GLCB")
  plot(NULL ,xaxt='n',yaxt='n',bty='n',ylab='',xlab='', xlim=0:1, ylim=0:1)
  legend("top", legend =config_names, pch=16, pt.cex=3, cex=1.5, bty='n',
         col = pal)
  mtext("Optimizer", at=0.2, cex=2)
}

draw_legend_kapton_glcb <- function(pal){ 
  config_names <- c("BO with LCB", "BO with EI", "BO with GLCB")
  plot(NULL ,xaxt='n',yaxt='n',bty='n',ylab='',xlab='', xlim=0:1, ylim=0:1)
  legend("top", legend =config_names, pch=16, pt.cex=3, cex=1.5, bty='n',
         col = pal)
  mtext("Optimization Method", at=0.5, cex=2)
}

draw_legend_kapton_par <- function(pal){ 
  config_names <- c("Parallel", "Classical")
  plot(NULL ,xaxt='n',yaxt='n',bty='n',ylab='',xlab='', xlim=0:1, ylim=0:1)
  legend("top", legend =config_names, pch=16, pt.cex=3, cex=1.5, bty='n',
         col = pal)
  mtext("Optimization Method", at=0.5, cex=2)
}