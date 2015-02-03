var path              = require("path");
global.chai           = require('chai');
global.expect         = chai.expect
global.srcDir         = path.resolve(__dirname, "../src");

process.env.NODE_ENV = "test";
global.injector = require(path.join(__dirname,"fixtures","injector.coffee"));

process.setMaxListeners(1000);