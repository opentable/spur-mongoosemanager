spur = require "spur-ioc"
spurCommon = require "spur-common"
localInjector = require "../../src/injector"

module.exports = ()->

  ioc = spur.create("test-spur-mongoosemanager")

  ioc.merge(spurCommon())
  ioc.merge(localInjector())

  ioc.addDependency "config", {
    Mongo:
      ConnectionUrl:"mongodb://127.0.0.1/test-spur-mongoosemanager"
  }

  ioc
