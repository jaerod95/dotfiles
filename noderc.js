global.pbcopy = function pbcopy(string) {
  const proc = require("child_process").spawn("pbcopy")
  proc.stdin.write(string)
  proc.stdin.end()
  return string
}

global.readJson = function loadJson(path) {
  return JSON.parse(require("fs").readFileSync(path, "utf8"))
}

global.writeJson = function saveJson(path, obj) {
  require("fs").writeFileSync(path, JSON.stringify(obj, null, 2))
}

global.parseCsv = function parseCsv(csv) {
  const rows = csv.trim().split("\n")
  const headers = rows[0].split(",").map((header) => header.trim())

  return rows.slice(1).map((row) => {
    const values = row.split(",")
    return headers.reduce((obj, header, idx) => {
      obj[header] = values[idx].trim().replace(/^"(.+)"$/, "$1")
      return obj
    }, {})
  })
}

global.parseCsvFile = function parseCsvFile(path) {
  return parseCsv(require("fs").readFileSync(path, "utf8"))
}

global.writeCsvFile = function writeCsvFile(path, rows) {
  return require("fs").writeFileSync(path, rows.map((row) => row.join(",")).join("\n"))
}

global.reload = function reload() {
  Object.keys(require.cache).forEach(function (key) {
    delete require.cache[key]
  })
}