#! /usr/bin/env node

import fs from "fs"

const lines = fs
  .readFileSync(0, "utf-8")
  .split("\n")
  .filter((line) => line.trim() && !line.trim().startsWith("-"))

const headers = lines[0].split("|").map((header) => header.trim())
const data = lines.slice(1).map((line) => {
  const values = line.split("|").map((value) => value.trim())
  return Object.fromEntries(headers.map((header, i) => [header, values[i]]))
})

console.log(JSON.stringify(data, null, 2))
