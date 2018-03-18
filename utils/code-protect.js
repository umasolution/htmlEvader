#!/usr/bin/env node

const path = require('path')
const program = require('commander')

var esprima = require('esprima');
var fs = require('fs');
var toString = require('escodegen').generate;
var confusion = require('confusion');
var uglifyJS = require("uglify-js");




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
}).then((data) => {

  var ast = esprima.parse(data);
  var obfuscated = confusion.transformAst(ast, confusion.createVariableName);
  var unreadCode = '';
  unreadCode = toString(obfuscated);
  /*
  if (paramObj.uglify) {
      unreadCode = uglifyJS.minify(unreadCode, {fromString: true}).code;
  }
  fs.writeFile(destinationPath, unreadCode, function (err) {
          var status = filePath + ' -> ' + destinationPath;
          if (err) {
              done(err);
          } else {
              if (paramObj.debug) {
                  console.log(status);
              }
              done(null, status);
          }
      });
  }
  */
  if (program.args.length > 1) {
    fs.writeFile(program.args[1], unreadCode, (err) => {
      if (err) throw err
    })
  } else {
    console.log(unreadCode)
  }
})

