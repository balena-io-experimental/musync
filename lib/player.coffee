_ = require('lodash')
Speaker = require('speaker')
Lame = require('lame')
EventEmitter2 = require('eventemitter2').EventEmitter2
ReadableStream = require('stream').Readable
audioCorrection = require('audio-correction')
settings = require('./settings')

class Player extends EventEmitter2

	constructor: (@stream, @decoder, @format) ->

		if not @stream?
			throw new Error('Missing stream argument')

		if @stream not instanceof ReadableStream
			throw new Error('Invalid stream argument: not a readable stream')

		if not @decoder?
			throw new Error('Missing decoder argument')

		if not @format?
			throw new Error('Missing format argument')

		@decoder.on('end', _.bind(@onFinish, this))

	# TODO: Check that there is a loaded song
	play: (date = new Date()) ->
		@speaker = new Speaker(@format)

		@decoder
			.pipe audioCorrection.skew
				start: date
				format: @format
				maximumSkew: settings.maximumSkew
				onSkew: (skew, maximumSkew) =>
					@emit('skew', skew, maximumSkew)
			.pipe(@speaker)

		@emit('play')

	pause: ->
		@decoder?.unpipe()
		@speaker?.end()
		@emit('pause')

	stop: ->
		@decoder?.unpipe()
		@speaker?.end()
		@emit('stop')
		@removeAllListeners()

	onFinish: ->
		@decoder?.unpipe()
		@speaker?.end()
		@emit('finish')

Player.createFromSong = (song, backend, callback) ->

	if not song?
		throw new Error('Missing song argument')

	if not backend?
		throw new Error('Missing backend argument')

	if not backend.search?
		throw new Error('Invalid backend argument: no search function')

	if not _.isFunction(backend.search)
		throw new Error('Invalid backend argument: search is not a function')

	backend.search song, (error, stream) ->
		return callback?(error) if error?

		decoder = new Lame.Decoder()
		stream.pipe(decoder)
		decoder.on 'format', (format) ->
			player = new Player(stream, decoder, format)
			return callback?(null, player)

module.exports = Player
