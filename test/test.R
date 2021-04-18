

library(JuliaConnectoR)
BMs <- juliaImport("BoltzmannMachines")
#juliaEval("using BoltzmannMachines")
result <- BMs$monitored_fitrbm(BMs$barsandstripes(10L, 4L),
                               monitoring = BMs$`monitorexactloglikelihood!`)
plotMonitoring(juliaGet(result)) # one graph
result <- BMs$monitored_fitrbm(BMs$barsandstripes(10L, 4L),
                          monitoring = c(BMs$`monitorexactloglikelihood!`,
                                         BMs$`monitorreconstructionerror!`))
plotMonitoring(juliaGet(result)) # two graphs

result <- BMs$monitored_fitdbm(BMs$barsandstripes(100L, 4L), learningratepretraining = 0.001,
                          monitoring = BMs$`monitorexactloglikelihood!`,
                          monitoringpretraining = BMs$`monitorreconstructionerror!`)
result <- juliaGet(result)
plotMonitoring(result) # 3 graphs
plotMonitoring(result, "reconstructionerror") # 2 graphs
plotMonitoring(result, c("reconstructionerror", "exactloglikelihood")) # 3 graphs


result <- BMs$monitored_fitrbm(BMs$barsandstripes(10L, 4L),
                               monitoring = BMs$`monitorloglikelihood!`)
plotMonitoring(juliaGet(result)) # one graph with ribbon

xtrain <- BMs$barsandstripes(50L, 4L)
xtest <- BMs$barsandstripes(20L, 4L)
result <- BMs$monitored_fitrbm(xtrain,
                           monitoring = BMs$`monitorloglikelihood!`,
                           monitoringdata = juliaLet('BoltzmannMachines.DataDict("Training data" => xtrain, "Test data" => xtest)',
                                                     xtrain = xtrain, xtest = xtest))
plotMonitoring(juliaGet(result)) # one graph with two curves with ribbons

result <- BMs$monitored_fitdbm(BMs$barsandstripes(10L, 4L),
                           monitoringpretraining = BMs$`monitorloglikelihood!`,
                           monitoring = BMs$`monitorlogproblowerbound!`,
                           pretraining = list(BMs$TrainPartitionedLayer(list(BMs$TrainLayer(nvisible = 2L, nhidden =2L),
                                                                             BMs$TrainLayer(nvisible = 2L, nhidden = 2L))),
                                              BMs$TrainLayer(nhidden = 3L)))
plotMonitoring(juliaGet(result[[1]])) # 4 graphs
plotMonitoring(juliaGet(result))
# possible datashield results
plotMonitoring(list(server1 = juliaGet(result[[1]])))
plotMonitoring(list(server1 = juliaGet(result)))
plotMonitoring(list(server1 = juliaGet(result)), evaluation = "logproblowerbound")# one graph


# no monitoring of pretraining
result <- BMs$monitored_fitdbm(BMs$barsandstripes(10L, 4L),
                               monitoring = BMs$`monitorexactloglikelihood!`)
plotMonitoring(juliaGet(result)) # one graph

