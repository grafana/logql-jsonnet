local absentOverTime = import 'absent-over-time.libsonnet';
local bytesOverTime = import 'bytes-over-time.libsonnet';
local bytesRate = import 'bytes-rate.libsonnet';
local countOverTime = import 'count-over-time.libsonnet';
local rate = import 'rate.libsonnet';

absentOverTime + bytesOverTime + bytesRate + countOverTime + rate
