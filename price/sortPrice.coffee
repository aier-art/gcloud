#!/usr/bin/env coffee

> zx/globals:
  @w5/yml/Yml
  @w5/uridir
  path > join
  @w5/read

ROOT = uridir(import.meta)

yml = Yml read join ROOT, 'pricing.yml'

console.log yml.about



