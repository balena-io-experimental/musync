exports.playlistToString = (playlist) ->
	result = []
	for song, index in playlist.songs
		songString = "#{index}. #{song.artist} - #{song.title}"
		songString += ' *' if index is playlist.current
		result.push(songString)
	return result.join('\n')

exports.getPlayStartInformation = (playStart) ->
	return if not playStart?

	timeDelta = new Date(playStart) - new Date()
	timeDeltaSeconds = timeDelta / 1000

	if timeDeltaSeconds < 0
		return "#{timeDeltaSeconds * -1} seconds ago"
	else
		return "in #{timeDeltaSeconds} seconds"
