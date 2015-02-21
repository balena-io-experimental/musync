http = require('http')
async = require('async')
_ = require('lodash')
GS = require('grooveshark-streaming')

exports.getSongId = (song, callback) ->

	if not song?
		throw new Error('Missing song argument')

	GS.Tinysong.getSongInfo song.title, song.artist, (error, songInfo) ->
		return callback(error) if error?

		if not songInfo?
			return callback(new Error("Unknown song: #{song.artist} - #{song.title}"))

		return callback(null, songInfo.SongID)

exports.getStreamingUrl = (songId, callback) ->

	if not songId?
		throw new Error('Missing song id argument')

	if not _.isNumber(songId)
		throw new Error("Invalid song id argument: #{songId}")

	GS.Grooveshark.getStreamingUrl songId, (error, streamingUrl) ->
		return callback(error) if error?

		if not streamingUrl?
			return callback(new Error("Unknown song id: #{songId}"))

		return callback(null, streamingUrl)

exports.getStreamFromUrl = (url, callback) ->

	if not url?
		throw new Error('Missing url argument')

	# TODO: Find a way to test this
	request = http.get(url)
	request.on('error', callback)
	request.on 'response', (stream) ->
		return callback(null, stream)

# Can't assign async.compose result directly to exports.search
# as Sinon doesn't mock correctly the composed functions in that case.
exports.search = (song, callback) ->
	async.compose(
		exports.getStreamFromUrl
		exports.getStreamingUrl,
		exports.getSongId
	).apply(null, arguments)
