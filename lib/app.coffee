_ = require('lodash')
FirebaseSync = require('./sync/firebase')
Player = require('./player')
settings = require('./settings')
backend = require('./backend')
util = require('./util')

manager = new FirebaseSync(settings.firebaseUrl)

currentPlayer = null
currentSong = {}

manager.on 'playlist:update', (playlist) ->
	console.log('PLAYLIST UPDATE ==============================')
	if playlist.playStart?
		console.log("PLAY START: #{util.getPlayStartInformation(playlist.playStart)}")
	console.log(util.playlistToString(playlist))

	if _.isEqual(playlist.currentSong, currentSong)
		return
	else
		currentPlayer?.stop()

		if not playlist.currentSong?
			console.info('Nothing to play')
			return

	Player.createFromSong playlist.currentSong, backend, (error, player) ->

		if error?
			console.error('Error loading current song, skipping.')
			console.error(error.message)
			return manager.playNext(playlist.current)

		currentSong = playlist.currentSong

		currentPlayer?.stop()
		currentPlayer = player

		currentPlayer.on 'skew', (skew, maximumSkew) ->
			console.warn("Error: Exceeds maximum skew of #{skew} (#{maximumSkew}ms.)")

		currentPlayer.on 'finish', ->
			manager.playNext(playlist.current)

		if playlist.playStart?
			currentPlayer.play(new Date(playlist.playStart))
		else
			currentPlayer.play()
