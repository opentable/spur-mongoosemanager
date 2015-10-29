describe "strictFindOnePlugin", ->

  beforeEach ()->
    injector().inject (@strictFindOnePlugin, @MongooseManager, @mongoose, @Promise, @config)=>

    @MongooseManager.connect(@config.Mongo.ConnectionUrl)

  afterEach ()->
    @MongooseManager.disconnect()

  it "should exist", ->
    expect(@strictFindOnePlugin).to.exist

  describe "db tests", ->

    beforeEach ->
      @Schema = new @mongoose.Schema({
        name:String
        description:String
      })

      @Schema.plugin(@strictFindOnePlugin)
      @Model = @mongoose.model "strict-find-one", @Schema
      @MongooseManager._promisifyAll()

      @Model.removeAsync().then ()=>
        @Model.createAsync({name:"first", description:"original"})

    it "strictFindOnePlugin - get existing", (done)->
      @Model.strictFindOneAsync(
        {name:"first"}
      ).done (result)=>
        expect(result.description).to.equal "original"
        done()

    it "strictFindOnePlugin - not found", (done)->
      @Model.strictFindOneAsync(
        {name:"second"}
      ).catch (e)=>
        expect(e.errorCode).to.equal "not_found_error"
        done()
