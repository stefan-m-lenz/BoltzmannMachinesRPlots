

library(JuliaConnectoR)
juliaUsing("BoltzmannMachines")
result <- monitored_fitrbm(barsandstripes(10L, 4L),
                          monitoring = juliaExpr("monitorexactloglikelihood!"))
plotEvaluation(result)
result <- monitored_fitrbm(barsandstripes(10L, 4L),
                          monitoring = juliaExpr("[monitorexactloglikelihood!, monitorreconstructionerror!]"))
plotEvaluation(result)

result <- monitored_fitdbm(barsandstripes(100L, 4L),
                          monitoring = juliaExpr("monitorexactloglikelihood!"),
                          monitoringpretraining = juliaExpr("monitorreconstructionerror!"))
plotEvaluation(result)

plotEvaluation(result, "reconstructionerror")
plotEvaluation(result, c("reconstructionerror", "exactloglikelihood"))
