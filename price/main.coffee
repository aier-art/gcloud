#!/usr/bin/env coffee

> zx/globals:
  @w5/yml > load
  @w5/uridir
  path > join
  @w5/read

ROOT = uridir(import.meta)

yml = load join ROOT, 'pricing.yml'

machine_type = 'c2d-standard-4'

{cost} = yml.compute.instance[machine_type]

li = []
for i from Object.keys(cost)
  li.push [i, cost[i].month_spot]

li.sort (a,b)=>a[1]-b[1]

for [zone,price] from li
  console.log zone,price
  await $"./open.sh #{zone} #{machine_type}"
  break




