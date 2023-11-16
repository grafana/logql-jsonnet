local logql = import "logql.libsonnet";

local aggregations = import "tests/aggregations.libsonnet";
local basic = import "tests/basic.libsonnet";
local bytes = import "tests/bytes.libsonnet";
local durations = import "tests/durations.libsonnet";
local formatting = import "tests/formatting.libsonnet";
local labelFilters = import "tests/label-filters.libsonnet";
local lineFilters = import "tests/line-filters.libsonnet";
local operators = import "tests/operators.libsonnet";
local parsers = import "tests/parsers.libsonnet";
local unwrap = import "tests/unwrap.libsonnet";
local unwrappedRangeFunctions = import "tests/unwrapped-range-functions.libsonnet";


aggregations + basic + bytes + durations + formatting + labelFilters + lineFilters + operators + parsers + unwrap + unwrappedRangeFunctions
