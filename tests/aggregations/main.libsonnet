local avg = import 'avg.libsonnet';
local count = import 'count.libsonnet';
local max = import 'max.libsonnet';
local min = import 'min.libsonnet';
local stddev = import 'stddev.libsonnet';
local stdvar = import 'stdvar.libsonnet';
local sum = import 'sum.libsonnet';

avg + count + max + min + stddev + stdvar + sum
