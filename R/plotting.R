plotEvaluation <- function(monitor) {
   if (length(monitor) == 0) {
      return()
   }

   if (attr(monitor[[1]], "JLTYPE") == "MonitoringItem") {
      plotdata <- do.call(rbind, monitor)
      plotdata <- data.frame(Epoch = unlist(plotdata[, "epoch"]),
                             Value = unlist(plotdata[, "value"]),
                             Dataset = unlist(plotdata[, "datasetname"]))
      ggplot(data = plotdata, aes(x = Epoch, y = Value, color = Dataset)) +
         geom_line()
   } else {
      # list of lists
   }

}


result = monitored_fitrbm(barsandstripes(10L, 4L), monitoring = juliaExpr("monitorexactloglikelihood!"))
monitor = result[[1]]
plotEvaluation(monitor)
