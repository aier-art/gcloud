#!/usr/bin/env coffee

> zx/globals:
  @w5/yml > load
  @w5/uridir
  path > join
  @w5/read


run = (machine_type, disk_type)=>
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

  ROOT = uridir(import.meta)

  yml = load join ROOT, 'pricing.yml'

  {cost} = yml.compute.instance[machine_type]

  li = []
  for i from Object.keys(cost)
    li.push [i, cost[i].month_spot]

  li.sort (a,b)=>a[1]-b[1]

  for [zone,price] from li
    price = Math.round(price * 100)
    zone_li = zone_id.get(zone)
    if not zone_li
      continue
    console.log zone,price/100
    for i from zone_li
      try
        await $"./open.sh #{zone}-#{i} #{machine_type} #{price} #{disk_type}"
        return
      catch err
        console.error err._combined
        continue
  return

type_li = [
  # 'c3-standard-4 pd-balanced'
 'c2d-standard-4 pd-standard'
]
for i from type_li
  await run ... i.split(' ')
