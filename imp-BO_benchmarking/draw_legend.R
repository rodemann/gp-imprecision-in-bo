draw_legend <- function(pal){ 
  kernel_names <- c("BO with EI","Imprecise BO (Parallel)", "Imprecise BO (Batch)", 
                    "BO with GLCB")
  plot(NULL ,xaxt='n',yaxt='n',bty='n',ylab='',xlab='', xlim=0:1, ylim=0:1)
  legend("top", legend =kernel_names, pch=16, pt.cex=3, cex=1.5, bty='n',
         col = pal)
  mtext("Optimizer", at=0.2, cex=2)
}