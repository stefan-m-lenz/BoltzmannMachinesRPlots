plotEvaluation <- function(monitor, evaluation = NULL) {

   if (length(monitor) == 0) {
      return()
   }

   if (attr(monitor[[1]], "JLTYPE") == "MonitoringItem") {
      plotdata <- do.call(rbind, monitor)
      plotdata <- data.frame(Epoch = unlist(plotdata[, "epoch"]),
                             Value = unlist(plotdata[, "value"]),
                             Dataset = unlist(plotdata[, "datasetname"]),
                             Evaluation = unlist(plotdata[, "evaluation"]),
                             stringsAsFactors = FALSE)

      singleEvaluationPlot <- function(plotdata) {
         ggplot(data = plotdata, aes(x = Epoch, y = Value, color = Dataset)) +
            geom_line()
      }

      if (!is.null(evaluation)) {
         plotdata <- plotdata[plotdata$Evaluation %in% evaluation, ]
      }

      plots <- lapply(split(plotdata, plotdata$Evaluation), singleEvaluationPlot)
      grid.arrange(grobs = plots)
   } else {
      # list of lists
   }

}

