plotMonitoring <- function(monitor, evaluation = NULL) {

   if (!is.list(monitor) || length(monitor) == 0) {
      return(invisible())
   }

   if (!is.null(attr(monitor, "JLTYPE"))) {
      if (startsWith(attr(monitor, "JLTYPE"), "Array{MonitoringItem")) {
         # plot different evaluations contained in the monitor in one grid
         evaluations <- extractEvaluations(monitor, evaluation)
         plots <- lapply(evaluations, singleEvaluationPlot)
         grid.arrange(grobs = plots)
         return(invisible())
      } else if (startsWith(attr(monitor, "JLTYPE"), "Array{Array{MonitoringItem")) {
         # plot all monitoring results from monitoring a DBM or DBN in a grid
         evaluations <- unlist(lapply(monitor, function(m) {extractEvaluations(m, evaluation)}),
                               recursive = FALSE)
         plots <- lapply(evaluations, singleEvaluationPlot)
         grid.arrange(grobs = plots)
         return(invisible())
      }
   }

   for (el in monitor) {
      plotMonitoring(el, evaluation)
   }
}


plottitles = list(
   "reconstructionerror" = "Mean reconstruction error",
   "logproblowerbound" = "Average lower bound of log probability",
   "loglikelihood" = "Average log-likelihood",
   "meandiff" = "L²-difference between means \nof generated and original data",
   "exactloglikelihood" = "Average of exact log-likelihood",
   "weightsnorm" = "L²-norm of weights",
   "sd" = "Standard deviation parameters of visible units",
   "cordiff" = "L²-difference between correlation matrices \nof generated and original data",
   "freeenergy" = "Free energy")


singleEvaluationPlot <- function(plotdata) {

   ggplot(data = plotdata, aes(x = Epoch, y = Value, color = Dataset)) +
      geom_line() + ggtitle(plottitles[[plotdata$Evaluation[1]]])
   #if (isaisplot(plotdata))
   #geom_ribbon(aes(ymin = level - 1, ymax = level + 1)
}


# returns a list of data frames each contatining the data for one plot
extractEvaluations <- function(monitor, evaluation) {

   plotdata <- do.call(rbind, monitor)
   plotdata <- data.frame(Epoch = unlist(plotdata[, "epoch"]),
                          Value = unlist(plotdata[, "value"]),
                          Dataset = unlist(plotdata[, "datasetname"]),
                          Evaluation = unlist(plotdata[, "evaluation"]),
                          stringsAsFactors = FALSE)
   if (!is.null(evaluation)) {
      plotdata <- plotdata[plotdata$Evaluation %in% evaluation, ]
   }
   evaluations <- split(plotdata, plotdata$Evaluation)
   evaluations
}


aisprecision <- function(logr, aissd, sdrange = 1.0) {
   t <- sdrange * aissd * exp(-logr)
   if (1 - t <= 0) {# prevent domainerror
      diffbottom <- -Inf
   } else {
      diffbottom <- log(1 - t)
   }

   difftop <- log(1 + t)

   c(diffbottom, difftop)
}
