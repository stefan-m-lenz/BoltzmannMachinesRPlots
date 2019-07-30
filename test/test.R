

library(JuliaConnectoR)
juliaUsing("BoltzmannMachines")
result <- monitored_fitrbm(barsandstripes(10L, 4L),
                          monitoring = juliaExpr("monitorexactloglikelihood!"))
plotMonitoring(result)
result <- monitored_fitrbm(barsandstripes(10L, 4L),
                          monitoring = juliaExpr("[monitorexactloglikelihood!, monitorreconstructionerror!]"))
plotMonitoring(result)

result <- monitored_fitdbm(barsandstripes(100L, 4L), learningratepretraining = 0.001,
                          monitoring = juliaExpr("monitorexactloglikelihood!"),
                          monitoringpretraining = juliaExpr("monitorreconstructionerror!"))
plotMonitoring(result)

plotMonitoring(result, "reconstructionerror")
plotMonitoring(result, c("reconstructionerror", "exactloglikelihood"))

