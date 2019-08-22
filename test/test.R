

library(JuliaConnectoR)
juliaUsing("BoltzmannMachines")
result <- monitored_fitrbm(barsandstripes(10L, 4L),
                          monitoring = juliaExpr("monitorexactloglikelihood!"))
plotMonitoring(result) # one graph
result <- monitored_fitrbm(barsandstripes(10L, 4L),
                          monitoring = juliaExpr("[monitorexactloglikelihood!, monitorreconstructionerror!]"))
plotMonitoring(result) # two graphs

result <- monitored_fitdbm(barsandstripes(100L, 4L), learningratepretraining = 0.001,
                          monitoring = juliaExpr("monitorexactloglikelihood!"),
                          monitoringpretraining = juliaExpr("monitorreconstructionerror!"))
plotMonitoring(result) # 3 graphs
plotMonitoring(result, "reconstructionerror") # 2 graphs
plotMonitoring(result, c("reconstructionerror", "exactloglikelihood")) # 3 graphs


result <- monitored_fitrbm(barsandstripes(10L, 4L),
                           monitoring = juliaExpr("monitorloglikelihood!"))
plotMonitoring(result) # one graph with ribbon

xtrain <- barsandstripes(50L, 4L)
xtest <- barsandstripes(20L, 4L)
result <- monitored_fitrbm(xtrain,
                           monitoring = juliaExpr("monitorloglikelihood!"),
                           monitoringdata = juliaLet('DataDict("Training data" => xtrain, "Test data" => xtest)',
                                                     xtrain = xtrain, xtest = xtest))
plotMonitoring(result) # one graph with two curves with ribbons

result <- monitored_fitdbm(barsandstripes(10L, 4L),
                           monitoringpretraining = juliaExpr("monitorloglikelihood!"),
                           monitoring = juliaExpr("monitorlogproblowerbound!"),
                           pretraining = list(TrainPartitionedLayer(list(TrainLayer(nvisible = 2L, nhidden =2L),
                                                                         TrainLayer(nvisible = 2L, nhidden = 2L))),
                                              TrainLayer(nhidden = 3L)))
plotMonitoring(result[[1]]) # 4 graphs
plotMonitoring(result)
# possible datashield results
plotMonitoring(list(server1 = result[[1]]))
plotMonitoring(list(server1 = result))
plotMonitoring(list(server1 = result), evaluation = "logproblowerbound")# one graph


# no monitoring of pretraining
result <- monitored_fitdbm(barsandstripes(10L, 4L),
                           monitoring = juliaExpr("monitorexactloglikelihood!"))
plotMonitoring(result) # one graph
