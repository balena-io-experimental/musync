settings = require('./settings')

try
	module.exports = require("musync-backend-#{settings.backend}")
catch
	console.error("Invalid backend: #{settings.backend}")
	process.exit(1)
