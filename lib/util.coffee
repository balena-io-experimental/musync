_ = require('lodash')

exports.playlistToString = (playlist) ->

	if not playlist?
		throw new Error('Missing playlist argument')

	return if _.isEmpty(playlist.songs)

	result = []
	for song, index in playlist.songs
		songString = "#{index + 1}. #{song.artist} - #{song.title}"
		songString += ' *' if index is playlist.current
		result.push(songString)
	return result.join('\n')

exports.getPlayStartInformation = (playStart) ->

	if not playStart?
		throw new Error('Missing playStart argument')

	if not _.isNumber(playStart)
		throw new Error('Invalid playStart argument: should be a number')

	timeDelta = new Date(playStart) - new Date()
	timeDeltaSeconds = timeDelta / 1000

	if timeDeltaSeconds < 0
		return "#{timeDeltaSeconds * -1} seconds ago"
	else if timeDeltaSeconds > 0
		return "in #{timeDeltaSeconds} seconds"
	else
		return 'now'
