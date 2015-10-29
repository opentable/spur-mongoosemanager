describe "findOneOrCreatePlugin", ->

  beforeEach ()->
    injector().inject (@findOneOrCreatePlugin, @MongooseManager, @mongoose, @Promise, @config)=>

    @MongooseManager.connect(@config.Mongo.ConnectionUrl)

  afterEach ()->
    @MongooseManager.disconnect()

  it "should exist", ->
    expect(@findOneOrCreatePlugin).to.exist

  describe "db tests", ->

    beforeEach ->
      @Schema = new @mongoose.Schema({
        name:String
        description:String
      })

      @Schema.plugin(@findOneOrCreatePlugin)
      @Model = @mongoose.model "find-or-create", @Schema
      @MongooseManager._promisifyAll()

      @Model.removeAsync().then ()=>
        @Model.createAsync({name:"first", description:"original"})

    it "findOneOrCreatePlugin - get existing", (done)->

      @Model.findOneOrCreateAsync(
        {name:"first"}
        {name:"first", description:"first item"}
      ).done (result)=>
        expect(result.description).to.equal "original"
        done()

    it "findOneOrCreatePlugin - create new", (done)->

      @Model.findOneOrCreateAsync(
        {name:"second"}
        {name:"second", description:"second item"}
      ).done (result)=>
        expect(result.description).to.equal "second item"
        done()
