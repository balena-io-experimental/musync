exports.playlistToString = (playlist) ->
	result = []
	for song, index in playlist.songs
		songString = "#{index}. #{song.artist} - #{song.title}"
		songString += ' *' if index is playlist.current
		result.push(songString)
	return result.join('\n')
