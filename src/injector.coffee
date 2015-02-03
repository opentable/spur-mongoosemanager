spur = require "spur-ioc"

module.exports = ()->

  ioc = spur.create("core-mongo")


  ioc.registerDependencies {
    "mongooseSchema"    : require("mongoose").Schema
    "mongooseTimestamp" : require "mongoose-timestamp"
  }

  ioc.registerFolders __dirname, [
    "mongoose"
  ]

  ioc
