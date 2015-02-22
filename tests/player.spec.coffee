_ = require('lodash')
sinon = require('sinon')
chai = require('chai')
chai.use(require('sinon-chai'))
expect = chai.expect
MockRes = require('mock-res')
Player = require('../lib/player')

describe 'Player:', ->

	beforeEach ->
		@format =
			sampleRate: 44100
			channels: 1
			bitDepth: 16

	describe '#constructor()', ->

		it 'should throw an error if no stream', ->
			expect =>
				new Player(null, new MockRes(), @format)
			.to.throw('Missing stream argument')

		it 'should throw an error if stream is not a readable stream', ->
			expect =>
				new Player({}, new MockRes(), @format)
			.to.throw('Invalid stream argument: not a readable stream')

		it 'should throw an error if no decoder', ->
			expect =>
				new Player(new MockRes(), null, @format)
			.to.throw('Missing decoder argument')

		it 'should throw an error if no format', ->
			expect ->
				new Player(new MockRes(), new MockRes(), null)
			.to.throw('Missing format argument')

	describe '#play()', ->

		it 'should emit a play event', ->
			player = new Player(new MockRes(), new MockRes(), @format)
			spy = sinon.spy()
			player.on('play', spy)
			player.play()
			expect(spy).to.have.been.calledOnce

	describe '#pause()', ->

		it 'should emit a pause event', ->
			player = new Player(new MockRes(), new MockRes(), @format)
			spy = sinon.spy()
			player.on('pause', spy)
			player.pause()
			expect(spy).to.have.been.calledOnce

	describe '#stop()', ->

		it 'should emit a stop event', ->
			player = new Player(new MockRes(), new MockRes(), @format)
			spy = sinon.spy()
			player.on('stop', spy)
			player.stop()
			expect(spy).to.have.been.calledOnce

	describe '#onFinish()', ->

		it 'should emit a finish event', ->
			player = new Player(new MockRes(), new MockRes(), @format)
			spy = sinon.spy()
			player.on('finish', spy)
			player.onFinish()
			expect(spy).to.have.been.calledOnce

	describe '.createFromSong()', ->

		beforeEach ->
			@song = { artist: 'Taylor Swift', title: 'Shake It Off' }

		it 'should throw an error if no song', ->
			expect ->
				Player.createFromSong(null, { search: _.noop }, _.noop)
			.to.throw('Missing song argument')

		it 'should throw an error if no backend', ->
			expect =>
				Player.createFromSong(@song, null, _.noop)
			.to.throw('Missing backend argument')

		it 'should throw an error if backend is missing the search function', ->
			expect =>
				Player.createFromSong(@song, {}, _.noop)
			.to.throw('Invalid backend argument: no search function')

		it 'should throw an error if backend.search is not a function', ->
			expect =>
				Player.createFromSong(@song, { search: [ _.noop ] }, _.noop)
			.to.throw('Invalid backend argument: search is not a function')
