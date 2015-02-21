settings = require('../settings')

try
	module.exports = require("./#{settings.backend}")
catch
	console.error("Invalid backend: #{settings.backend}")
	process.exit(1)
