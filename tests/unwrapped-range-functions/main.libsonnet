local avgOverTime = import 'avg-over-time.libsonnet';
local firstOverTime = import 'first-over-time.libsonnet';
local lastOverTime = import 'last-over-time.libsonnet';
local maxOverTime = import 'max-over-time.libsonnet';
local quantileOverTime = import 'quantile-over-time.libsonnet';
local rateCounter = import 'rate-counter.libsonnet';
local stddevOverTime = import 'stddev-over-time.libsonnet';
local stdvarOverTime = import 'stdvar-over-time.libsonnet';
local sumOverTime = import 'sum-over-time.libsonnet';

avgOverTime + firstOverTime + lastOverTime + maxOverTime + quantileOverTime + rateCounter + stddevOverTime + stdvarOverTime + sumOverTime
