_ = require('lodash')
sinon = require('sinon')
chai = require('chai')
chai.use(require('sinon-chai'))
expect = chai.expect
GS = require('grooveshark-streaming')
MockRes = require('mock-res')
stream = require('stream')
grooveshark = require('../../lib/backend/grooveshark')

describe 'Grooveshark:', ->

	describe '.getSongId()', ->

		it 'should throw an error if no song', ->
			expect ->
				grooveshark.getSongId(null, _.noop)
			.to.throw('Missing song argument')

		describe 'given a valid song', ->

			beforeEach ->
				@song =
					artist: 'Queen'
					title: 'Love of My Life'

				@getSongInfoStub = sinon.stub(GS.Tinysong, 'getSongInfo')
				@getSongInfoStub.yields null,
					SongID: 1234
					SongName: @song.title
					ArtistID: 0
					ArtistName: @song.artist
					AlbumID: 0
					AlbumName: ''

			afterEach ->
				@getSongInfoStub.restore()

			it 'should return the id', (done) ->
				grooveshark.getSongId @song, (error, songId) ->
					expect(error).to.not.exist
					expect(songId).to.equal(1234)
					done()

		describe 'given a not found song', ->

			beforeEach ->
				@song =
					artist: 'Foo bar'
					title: 'Baz'

				@getSongInfoStub = sinon.stub(GS.Tinysong, 'getSongInfo')
				@getSongInfoStub.yields(null, null)

			afterEach ->
				@getSongInfoStub.restore()

			it 'should return an error', (done) ->
				grooveshark.getSongId @song, (error, songId) ->
					expect(error).to.be.an.instanceof(Error)
					expect(error.message).to.equal('Unknown song: Foo bar - Baz')
					expect(songId).to.not.exist
					done()

	describe '.getStreamingUrl()', ->

		it 'should throw an error if no song id', ->
			expect ->
				grooveshark.getStreamingUrl(null, _.noop)
			.to.throw('Missing song id argument')

		it 'should throw an error if song id is not a number', ->
			expect ->
				grooveshark.getStreamingUrl('1234', _.noop)
			.to.throw('Invalid song id argument: 1234')

		describe 'given a valid song id', ->

			beforeEach ->
				@id = 41982880
				@url = 'http://stream168b.grooveshark.com/stream.php'

				@getStreamingUrlStub = sinon.stub(GS.Grooveshark, 'getStreamingUrl')
				@getStreamingUrlStub.yields(null, @url)

			afterEach ->
				@getStreamingUrlStub.restore()

			it 'should return an error', (done) ->
				grooveshark.getStreamingUrl @id, (error, streamingUrl) =>
					expect(error).to.not.exist
					expect(streamingUrl).to.equal(@url)
					done()

		describe 'given a not found song id', ->

			beforeEach ->
				@id = 12345

				@getStreamingUrlStub = sinon.stub(GS.Grooveshark, 'getStreamingUrl')
				@getStreamingUrlStub.yields(null, undefined)

			afterEach ->
				@getStreamingUrlStub.restore()

			it 'should return an error', (done) ->
				grooveshark.getStreamingUrl @id, (error, streamingUrl) =>
					expect(error).to.be.an.instanceof(Error)
					expect(error.message).to.equal("Unknown song id: #{@id}")
					expect(streamingUrl).to.not.exist
					done()

	describe '.getStreamFromUrl()', ->

		it 'should throw an error if no url', ->
			expect ->
				grooveshark.getStreamFromUrl(null, _.noop)
			.to.throw('Missing url argument')

	describe '.search()', ->

		it 'should throw an error if no song', ->
			expect ->
				grooveshark.search(null, _.noop)
			.to.throw('Missing song argument')

		describe 'given a not found song', ->

			beforeEach ->
				@getSongIdStub = sinon.stub(grooveshark, 'getSongId')
				@getSongIdStub.yields(new Error('Unknown song: Foo - Bar'))

			afterEach ->
				@getSongIdStub.restore()

			it 'should return the streaming url', (done) ->
				grooveshark.search @song, (error, stream) ->
					expect(error).to.be.an.instanceof(Error)
					expect(error.message).to.equal('Unknown song: Foo - Bar')
					expect(stream).to.not.exist
					done()

		describe 'given a valid song', ->

			beforeEach ->
				@song =
					artist: 'Taylor Swift'
					title: 'Shake It Off'

				@getSongIdStub = sinon.stub(grooveshark, 'getSongId')
				@getSongIdStub.yields(null, 1234)

				@url = 'http://stream168b.grooveshark.com/stream.php'
				@getStreamingUrlStub = sinon.stub(grooveshark, 'getStreamingUrl')
				@getStreamingUrlStub.yields(null, @url)

				@getStreamFromUrlStub = sinon.stub(grooveshark, 'getStreamFromUrl')
				@getStreamFromUrlStub.yields(null, new MockRes())

			afterEach ->
				@getSongIdStub.restore()
				@getStreamingUrlStub.restore()
				@getStreamFromUrlStub.restore()

			it 'should return the song stream', (done) ->
				grooveshark.search @song, (error, songStream) ->
					expect(error).to.not.exist
					expect(songStream).to.be.an.instanceof(stream.Readable)
					done()
