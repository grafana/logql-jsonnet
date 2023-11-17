local avgOverTime = import 'avg-over-time.libsonnet';
local firstOverTime = import 'first-over-time.libsonnet';
local lastOverTime = import 'last-over-time.libsonnet';
local maxOverTime = import 'max-over-time.libsonnet';
local quantileOverTime = import 'quantile-over-time.libsonnet';
local rateCounter = import 'rate-counter.libsonnet';
local stdDevOverTime = import 'stddev-over-time.libsonnet';
local stdVarOverTime = import 'stdvar-over-time.libsonnet';
local sumOverTime = import 'sum-over-time.libsonnet';

avgOverTime + firstOverTime + lastOverTime + maxOverTime + quantileOverTime + rateCounter + stdDevOverTime + stdVarOverTime + sumOverTime
