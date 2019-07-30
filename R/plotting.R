plotEvaluation <- function(monitor, evaluation = NULL) {

   if (!is.list(monitor) || length(monitor) == 0 || is.null(attr(monitor, "JLTYPE"))) {
      return()
   }

   if (startsWith(attr(monitor, "JLTYPE"), "Array{MonitoringItem")) {
      # plot different evaluations contained in the monitor in one grid
      evaluations <- extractEvaluations(monitor, evaluation)
      plots <- lapply(evaluations, singleEvaluationPlot)
      grid.arrange(grobs = plots)
   } else if (startsWith(attr(monitor, "JLTYPE"), "Array{Array{MonitoringItem")) {
      # plot all monitoring results from monitoring a DBM or DBN in a grid
      evaluations <- unlist(lapply(monitor, function(m) {extractEvaluations(m, evaluation)}),
                            recursive = FALSE)
      plots <- lapply(evaluations, singleEvaluationPlot)
      grid.arrange(grobs = plots)
   } else if (is.list(monitor)) {
      # this is, e.g., the case when monitor is bundled with a Boltzmann machines,
      # as in the output of monitored_fitdbm
      for (el in monitor) {
         plotEvaluation(el, evaluation)
      }
   }
}


singleEvaluationPlot <- function(plotdata) {
   ggplot(data = plotdata, aes(x = Epoch, y = Value, color = Dataset)) +
      geom_line()
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


