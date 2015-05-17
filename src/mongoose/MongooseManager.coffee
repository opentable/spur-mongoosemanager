mongoomise = require "mongoomise"

module.exports = (mongoose, Logger, Promise, SpurErrors)->

  new class MongooseManager

    connect:(@connectionUrl, @connectionOptions = {})->
      @_verifyConnectionString()
      @_addDummySchemaToMongoose()
      @_makeConnection()
      @_promisifyAll()

    disconnect:()->
      Promise.promisify(mongoose.disconnect, mongoose)()
        .tap ()->
          Logger.log "MongooseManager: Disconnected from mongodb"
        .catch (e)->
          Logger.error "MongooseManager: Error disconnecting from mongodb", e
          Promise.reject(e)

    _verifyConnectionString:()->
      unless @connectionUrl
        throw new Error("MongooseManager: Missing mongodb connection url")

    _makeConnection:()->
      Logger.log 'MongooseManager: Attempting to connect to mongo'

      connectPromise = Promise.promisify(mongoose.connect, mongoose)(@connectionUrl, @connectionOptions)
        .tap ()->
          Logger.log("MongooseManager: Connected to mongodb")
        .catch (e)->
          Logger.error("MongooseManager: Mongodb connection error", e)
          Promise.reject(e)

    _addDummySchemaToMongoose:()->
      dummySchema = mongoose.Schema({
        name: String
      })

      dummy = mongoose.model('dummy', dummySchema)

    _promisifyAll:()->
      mongoomise.promisifyAll(mongoose, {
        lift:true
        promise:(resolver)=>
          new Promise(resolver).catch(@_errorTranslator)
      })

    _errorTranslator:(e)->
      if e.code in [11000, 11001]
        return Promise.reject(SpurErrors.AlreadyExistsError.create("Entity already exists", e))
      else if e.name is "ValidationError"
        return Promise.reject(SpurErrors.ValidationError.create(e.message).setData(e.errors))
      else
        return Promise.reject(e)
