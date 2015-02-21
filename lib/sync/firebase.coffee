Firebase = require('firebase')
EventEmitter2 = require('eventemitter2').EventEmitter2
settings = require('../settings')

module.exports = class FirebaseSync extends EventEmitter2

	constructor: (@url) ->
		@firebase = new Firebase(@url)
		@playlist = {}

		@playlistModel = @firebase.child('playlist')
		@playlistModel.on 'value', (snapshot) =>
			@playlist = snapshot.val()
			@playlist.currentSong = @playlist.songs[@playlist.current]

			if @playlist.playStart?
				@playlist.playStart += settings.setupGrace
				@playlist.playStart += settings.grace

			@emit('playlist:update', @playlist)

	playNext: (index) ->

		# Prevent multiple equal modifications from various clients
		return if @playlist.current is index + 1

		@playlistModel.transaction (playlist) =>
			if @hasNext(@playlist.current)
				playlist.current = index + 1
				playlist.playStart = Date.now()
			else
				playlist.current = null
				playlist.playStart = null

			return playlist

	hasNext: (index) ->
		return index < @playlist.songs.length - 1
