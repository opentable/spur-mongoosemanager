<img src="https://opentable.github.io/spur/logos/Spur-Mongoose-Manager.png?rand=1" width="100%" alt="Spur: Mongoose Manager" />

A mongoose manager wrapper that provides some common utilities and extends it to support promises.

[![NPM version](https://badge.fury.io/js/spur-mongoosemanager.png)](http://badge.fury.io/js/spur-mongoosemanager)
[![Build Status](https://travis-ci.org/opentable/spur-mongoosemanager.png?branch=master)](https://travis-ci.org/opentable/spur-mongoosemanager)

# About the Spur Framework

The Spur Framework is a collection of commonly used Node.JS libraries used to create common application types with shared libraries.

[Visit NPMJS.org for a full list of Spur Framework libraries](https://www.npmjs.com/browse/keyword/spur-framework) >>

# Quick start

## Installing

```bash
$ npm install spur-mongoosemanager --save
```

## Usage

#### `src/injector.js`

```coffeescript
spur                = require "spur-ioc"
spurCommon          = require"spur-common"
spurMongoosemanager = require "spur-mongoosemanager"

module.exports = ()->

  ioc = spur.create("demo")

  # register folders in your project to be autoinjected
  ioc.registerFolders __dirname, [
    "demo"
  ]

  ioc.merge(spurCommon())
  ioc.merge(spurMongoosemanager())

  ioc
```

#### `demo/DinerModel.coffee`

Definition of a MongoDB schemea for a diner.

```coffeescript
module.exports = (MongooseSchema, MongooseModel, config, MongooseManager, Moment)->

  new class DinerModel extends MongooseModel
    constructor:->
      super
      @_model = @createModel()

    createModel:()->
      # Define a schema
      schema = new MongooseSchema {
        _id:
          type: Number
          required: true
          unique: true
          index: true

        firstName:
          type: String
          trim: true

        lastName:
          type: String
          trim: true
      }

      schema.virtual("globalId").get ()->
        this._id

      schema.set 'toJSON', { virtuals: true }

      MongooseManager.model 'Diner', schema

    createObject: (globalId, firstName, lastName)->
      {
        GlobalId: globalId
        firstName: firstName
        lastName: lastName
      }

```

#### `demo/DinerService.coffee`

Service that uses the mongodb diner model created above.

```coffeescript
module.exports = (Diner, Promise) ->

  new class DinerService

    getDiner: (id)->
      Diner
        .findOneAsync({ _id: id })
        .then (diner)->
          diner
        .error (error)->
          Logger.error(error)
          {}
```

#### `start.coffee`

```coffeescript
injector = require "./src/injector"

injector().inject (MongooseManager)->

  UncaughtHander.listen()

  # Initiate the connection
  MongooseManger.connect()
```

# Contributing

## We accept pull requests

Please send in pull requests and they will be reviewed in a timely manner. Please review this [generic guide to submitting a good pull requests](https://github.com/blog/1943-how-to-write-the-perfect-pull-request). The only things we ask in addition are the following:

 * Please submit small pull requests
 * Provide a good description of the changes
 * Code changes must include tests
 * Be nice to each other in comments. :innocent:

## Style guide

The majority of the settings are controlled using an [EditorConfig](.editorconfig) configuration file. To use it [please download a plugin](http://editorconfig.org/#download) for your editor of choice.

## All tests should pass

To run the test suite, first install the dependancies, then run `npm test`

```bash
$ npm install
$ npm test
```

# License

[MIT](LICENSE)
