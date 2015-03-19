# spur-mongoosemanager

A very simple node module that gives a generic mongoose manager.

The project is still a work in progress. We are in the middle of making adjustments and are starting to dogfood the module in our own applications.

[![NPM version](https://badge.fury.io/js/spur-mongoosemanager.png)](http://badge.fury.io/js/spur-mongoosemanager)
[![Build Status](https://travis-ci.org/opentable/spur-mongoosemanager.png?branch=master)](https://travis-ci.org/opentable/spur-mongoosemanager)

## Installing

```bash
$ npm install spur-mongoosemanager --save
```

## Usage

### src/injector.js

```javascript
var spur = require("spur-ioc");
var spurMongoosemanager = require("spur-mongoosemanager");
var spurCommon = require("spur-common");

module.exports = function(){
  // define a  new injector
  var ioc = spur.create("demo");

  // register already constructed objects such as globals
  ioc.registerDependencies({
    ...
  });

  // register folders in your project to be autoinjected
  ioc.registerFolders(__dirname, [
    "demo"
  ]);

  // THIS IS THE IMPORTANT PART: Merge the spur-mongoosemanager dependencies to your local container
  ioc.merge(spurCommon())
  ioc.merge(spurMongoosemanager())

  return ioc;
}
```

### start.js

```javascript
injector = require "./src/injector"

injector().inject (MongooseManager)->

  Logger.info "Starting app..."

  MongooseManger.connect()

  // Enabled the UncaughtHander
  UncaughtHander.listen()
```

