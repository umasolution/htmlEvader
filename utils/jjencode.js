#!/usr/bin/env node

const fs = require('fs')
const path = require('path')
const program = require('commander')

var JE = require('jencrypt');

program
  .option('-o, --output', 'set output filename')
  .parse(process.argv)

if (program.args.length === 0) {
  program.help()
  process.exit(1)
}



const file = path.resolve(program.args[0])
new Promise((resolve, rejected) => {
  fs.readFile(file, (err, buffer) => {
    if (err) throw err
    resolve(buffer.toString())
  })
}).then((str) => {
  var sEncodeStr = JE.encode(str);
  if (program.args.length > 1) {
    fs.writeFile(program.args[1], sEncodeStr, (err) => {
      if (err) throw err
    })
  } else {
    console.log(sEncodeStr)
  }
})

