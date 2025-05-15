#------------------------------------------ plot_vars ------------------------------------------
#' Creates different kind of plots for variables within a dataset using ggplot2
#'
#' This function creates histograms for numeric values and barcharts for character or factor variables
#' In case there are more then 10 unique values it will list the first 10 unique values in a 'text' plot
#'
#' @param dfrm data frame that should be plotted
#' @param ppp number plots per page
#' @param vars character vector with the variables for which plots should be generated
#' @param ... additional arguments passed to [patchwork::wrap_plots()] (e.g. ncol/nrow)
#' @keywords misc
#' @export
#' @return a ggplot/patchwork object with all variables plotted visualized
#' @author Richard Hooijmaijers
#' @examples
#'
#' plot_vars(Theoph)
plot_vars <- function(dfrm, vars=names(dfrm), ppp=16,...){
  plts <- lapply(vars,function(var){
    if(is.numeric(dfrm[,var])){
      pldat <- data.frame(plvar = dfrm[,var])
      subt  <- paste0("Mean: ", formatC(mean(dfrm[,var],na.rm=TRUE),digits=3,format="g"),
                      ", SD: ", formatC(stats::sd(dfrm[,var],na.rm=TRUE),digits=3,format="g"),
                      ", NA: ", length(dfrm[,var]) - length(stats::na.omit(as.numeric(dfrm[,var]))),"%")
      pl <- ggplot2::ggplot(pldat, ggplot2::aes(x=.data$plvar)) + 
        ggplot2::geom_histogram(color="black",fill="grey") +
        ggplot2::labs(title=paste(var,"(Num)"), subtitle=subt, x="") + ggplot2::theme_bw() 
    }else{
      tb   <- data.frame(table(dfrm[,var]))
      tb   <- tb[order(tb$Freq, decreasing = TRUE),]
      subt <- paste0("Number of cat.: ",nrow(tb))
      if(nrow(tb)>=10){
        tb$Var1 <- as.character(tb$Var1)
        tb$Var1[10:nrow(tb)] <-"oth."
        tb <- dplyr::summarise(tb,count=sum(.data$Freq),.by = .data$Var1)
        tb$Var1 <- factor(tb$Var1, levels=tb$Var1)
      }else{
        tb$Var1  <- factor(tb$Var1, levels=tb$Var1)
        tb$count <- tb$Freq
      }
      pl <- ggplot2::ggplot(tb, ggplot2::aes(x=.data$Var1,y=.data$count)) + 
        ggplot2::geom_bar(stat="identity",color="black",fill="grey") +
        ggplot2::labs(title=paste(var,ifelse(is.factor(dfrm[,var]),"(Fact)","(Char)")),subtitle=subt,x="") + ggplot2::theme_bw() 
    }
    return(pl)
  })
  tot   <- length(vars)
  nums  <- sum(sapply(vars,function(x) is.numeric(dfrm[,x])))
  facs  <- sum(sapply(vars,function(x) is.factor(dfrm[,x])))
  chars <- sum(sapply(vars,function(x) is.character(dfrm[,x])))
  titl  <- paste0(tot," number of variables (",nums," numeric, ",facs," factor, ",chars," character)")
  pltn  <- split(1:length(plts),rep(1:ceiling(length(plts)/ppp),each=ppp)[1:length(plts)])
  lapply(pltn,function(x){
    patchwork::wrap_plots(plts[x], axis_titles = "collect_y", ...) +
       patchwork::plot_annotation(title = titl, theme = ggplot2::theme(plot.title = ggplot2::element_text(hjust = 0.5)))
  })
}
