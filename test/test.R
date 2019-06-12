

library(JuliaConnectoR)
juliaUsing("BoltzmannMachines")
result = monitored_fitrbm(barsandstripes(10L, 4L),
                          monitoring = juliaExpr("monitorexactloglikelihood!"))
monitor = result[[1]]
plotEvaluation(monitor)
result = monitored_fitrbm(barsandstripes(10L, 4L),
                          monitoring = juliaExpr("[monitorexactloglikelihood!, monitorreconstructionerror!]"))
monitor = result[[1]]
plotEvaluation(monitor)

plotEvaluation(monitor, "reconstructionerror")
plotEvaluation(monitor, c("reconstructionerror", "exactloglikelihood"))
