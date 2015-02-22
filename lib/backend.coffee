exports.get = (backend) ->
	try
		return require("musync-backend-#{backend}")
	catch
		throw new Error("Invalid backend: #{backend}")
