plotMonitoring <- function(monitor, evaluation = NULL, sdrange = 1.0) {

   # plot different evaluations contained in the monitor in one grid
   evaluations <- extractEvaluations(monitor, evaluation, sdrange)
   if (length(evaluations) != 0) {
      plots <- lapply(evaluations, singleEvaluationPlot)
      grid.arrange(grobs = plots)
   }
   return(invisible())
}


PLOT_TITLES <- list(
   "reconstructionerror" = "Mean reconstruction error",
   "logproblowerbound" = "Average lower bound of log probability",
   "loglikelihood" = "Average log-likelihood",
   "meandiff" = "L²-difference between means \nof generated and original data",
   "exactloglikelihood" = "Average of exact log-likelihood",
   "weightsnorm" = "L²-norm of weights",
   "sd" = "Standard deviation parameters of visible units",
   "cordiff" = "L²-difference between correlation matrices \nof generated and original data",
   "freeenergy" = "Free energy")


AIS_EVALUATION_KEYS <- c("loglikelihood", "logproblowerbound")


singleEvaluationPlot <- function(plotdata) {
   plottitle <- PLOT_TITLES[[plotdata$Evaluation[1]]]
   if (is.null(plotdata$rangemin)) {
      return(ggplot(data = plotdata) +
         geom_line(aes(x = Epoch, y = Value, color = Dataset)) +
         ggtitle(plottitle) + theme_light())

   } else {
      return(ggplot(data = plotdata, aes(x = Epoch, y = Value, color = Dataset,
                                         ymin = rangemin, ymax = rangemax)) +
                geom_line() +
            ggtitle(plottitle) +
            theme_light() +
            geom_ribbon(aes(x= Epoch, ymin = rangemin, ymax = rangemax),
                        linetype = 0,
                        alpha = 0.1))
   }
}


isMonitor <- function(x) {
   jltype <- attr(x, "JLTYPE")
   return(!is.null(jltype) && (
             jltype == "Array{BoltzmannMachines.MonitoringItem,1}" ||
             jltype == "Array{MonitoringItem,1}"))
}


# returns a list of data frames each containing the data for one plot
extractEvaluations <- function(monitor, evaluation, sdrange) {
   if (!is.list(monitor) || length(monitor) == 0) {
      return(list())
   }

   jltype = attr(monitor, "JLTYPE")
   if (isMonitor(monitor)) {
      return(extractEvaluationsFromSingleMonitor(monitor, evaluation, sdrange))
   } else {
      return(unlist(lapply(monitor, function(m) {extractEvaluations(m, evaluation, sdrange)}),
             recursive = FALSE))
   }

   return(list())
}


extractEvaluationsFromSingleMonitor <- function(monitor, evaluation, sdrange) {
   plotdata <- do.call(rbind, monitor)
   plotdata <- data.frame(Epoch = unlist(plotdata[, "epoch"]),
                          Value = unlist(plotdata[, "value"]),
                          Dataset = unlist(plotdata[, "datasetname"]),
                          Evaluation = unlist(plotdata[, "evaluation"]),
                          stringsAsFactors = FALSE)
   isAisInfo <- plotdata$Evaluation %in% c("aisstandarddeviation", "aislogr")
   aisinfo <- plotdata[isAisInfo, ]
   plotdata <- plotdata[!isAisInfo, ]
   if (!is.null(evaluation)) {
      plotdata <- plotdata[plotdata$Evaluation %in% evaluation, ]
   }
   evaluations <- split(plotdata, plotdata$Evaluation)
   aisinfo <- split(aisinfo, aisinfo$Evaluation)
   aisevaluationIdx <- Position(function(x) { x$Evaluation[[1]] %in% AIS_EVALUATION_KEYS },
                                evaluations)
   if (!is.na(aisevaluationIdx)) { # Data for uncertainty of estimation is extracted
      if (length(aisevaluationIdx) == 1) {
         aisSd <- Filter(function(x) {x$Evaluation[[1]] == "aisstandarddeviation"}, aisinfo)
         aisSd <- aisSd$aisstandarddeviation$Value
         aisLogr <- Filter(function(x) {x$Evaluation[[1]] == "aislogr"}, aisinfo)
         aisLogr <- aisLogr$aislogr$Value
         aisevaluation <- evaluations[[aisevaluationIdx]]
         # sorting to reuse subtraction below for each monitoring data set
         aisevaluation <- aisevaluation[order(aisevaluation$Dataset, aisevaluation$Epoch), ]
         bottom_top <- aisPrecision(aisLogr, aisSd, sdrange)
         aisevaluation$rangemin <- aisevaluation$Value - bottom_top[[1]]
         aisevaluation$rangemax <- aisevaluation$Value - bottom_top[[2]]
         evaluations[[aisevaluationIdx]] <- aisevaluation
      }
      else if (length(aisevaluationIdx) > 1) {
         warning("Plotting of uncertainty not supported for more than one AIS evaluation")
      }
   }
   evaluations
}


aisPrecision <- function(logr, aissd, sdrange) {
   t <- sdrange * aissd * exp(-logr)
   expdiffbottom <- 1 - t
   expdiffbottom[expdiffbottom <= 0] <- 0 # prevents NaN
   diffbottom <- log(expdiffbottom)
   difftop <- log(1 + t)
   list(diffbottom, difftop)
}
