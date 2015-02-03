mongoomise = require "mongoomise"

module.exports = (mongoose, config, Logger, Promise, SpurErrors)->
  new class MongooseManager

    init:()->
      @dbTimeout = config.Mongo?.ConnectionTimeoutMS or 5000
      @connectionUrl = config.Mongo?.ConnectionUrl
      unless @connectionUrl
        throw new Error("Missing mongodb connection url")
      @connectionOptions =
        server:
          socketOptions:
            connectTimeoutMS: @dbTimeout
        mongos: true,
        replset:
          strategy: 'ping'

    connect:()->
      @init()
      Logger.info 'Attempting to connect to mongo'
      dummySchema = mongoose.Schema({
        name: String
      })

      dummy = mongoose.model('dummy', dummySchema)
      @promisifyAll()

      connectPromise = Promise.promisify(mongoose.connect, mongoose)(@connectionUrl)
        .tap ()->
          Logger.info "Connected to mongodb"
        .catch (e)->
          Logger.error("Mongodb connection error", e)
          Promise.reject(e)

    promisifyAll:()->
      mongoomise.promisifyAll(mongoose, {
        lift:true
        promise:(resolver)=>
          new Promise(resolver).catch(@errorTranslator)
      })

    errorTranslator:(e)->
      if e.code in [11000, 11001]
        return Promise.reject(SpurErrors.AlreadyExistsError.create("Entity already exists", e))
      else if e.name is "ValidationError"
        return Promise.reject(SpurErrors.ValidationError.create(e.message).setData(e.errors))
      else
        return Promise.reject(e)

    disconnect:()->
      Promise.promisify(mongoose.disconnect, mongoose)()
        .tap ()->
          Logger.info "Disconnected from mongodb"
        .catch (e)->
          Logger.error "Error disconnecting from mongodb", e
          Promise.reject(e)
