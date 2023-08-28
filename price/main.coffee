#!/usr/bin/env coffee

> zx/globals:
  @w5/yml > load
  @w5/uridir
  path > join
  @w5/read


run = (machine_type)=>
  {stdout} = (
    await $"gcloud compute machine-types list --filter=\"name=('#{machine_type}')\""
  )

  zone_id = new Map
  for i from stdout.split('\n').slice(1)
    i = i.replace(/\s+/g,' ').split(' ')
    zone = i[1]
    if zone
      pos = zone.lastIndexOf('-')
      id = zone.slice(pos+1)
      zone = zone.slice(0,pos)
      li = zone_id.get zone
      if li
        li.push id
      else
        li = [id]
        zone_id.set zone,li

  console.log zone_id
  process.exit()
  ROOT = uridir(import.meta)

  yml = load join ROOT, 'pricing.yml'

  {cost} = yml.compute.instance[machine_type]

  li = []
  for i from Object.keys(cost)
    li.push [i, cost[i].month_spot]

  li.sort (a,b)=>a[1]-b[1]

  for [zone,price] from li
    price = Math.round(price * 100)
    console.log zone,price/100
    for i from zone_id.get(zone)
      await $"./open.sh #{zone}-#{i} #{machine_type} #{price}"
    return
  return

for i from 'c2-standard-4 c2d-standard-4'.split(' ')
  await run i
