chai = require('chai')
expect = chai.expect
utils = require('../lib/util')

describe 'Util:', ->

	describe '.playlistToString()', ->

		it 'should throw an error if no playlist', ->
			expect ->
				utils.playlistToString()
			.to.throw('Missing playlist argument')

		describe 'given a playlist without songs', ->

			beforeEach ->
				@playlist =
					songs: []

			it 'should output nothing', ->
				result = utils.playlistToString(@playlist)
				expect(result).to.not.exist

		describe 'given a 1 song playlist with no current', ->

			beforeEach ->
				@playlist =
					songs: [
						{ artist: 'Foo', title: 'Bar' }
					]

			it 'should construct a correct playlist', ->
				result = utils.playlistToString(@playlist)
				expect(result).to.equal [
					'1. Foo - Bar'
				].join('\n')

		describe 'given a 3 song playlist with no current', ->

			beforeEach ->
				@playlist =
					songs: [
						{ artist: 'Foo', title: 'Bar' }
						{ artist: 'Bar', title: 'Baz' }
						{ artist: 'Baz', title: 'Qux' }
					]

			it 'should construct a correct playlist', ->
				result = utils.playlistToString(@playlist)
				expect(result).to.equal [
					'1. Foo - Bar'
					'2. Bar - Baz'
					'3. Baz - Qux'
				].join('\n')

		describe 'given a 3 song playlist with current', ->

			beforeEach ->
				@playlist =
					current: 1
					songs: [
						{ artist: 'Foo', title: 'Bar' }
						{ artist: 'Bar', title: 'Baz' }
						{ artist: 'Baz', title: 'Qux' }
					]

			it 'should mark the current one with an asterisk', ->
				result = utils.playlistToString(@playlist)
				expect(result).to.equal [
					'1. Foo - Bar'
					'2. Bar - Baz *'
					'3. Baz - Qux'
				].join('\n')

	describe '.getPlayStartInformation()', ->

		it 'should throw an error if no playStart', ->
			expect ->
				utils.getPlayStartInformation()
			.to.throw('Missing playStart argument')

		it 'should throw an error if playStart is not a number', ->
			expect ->
				utils.getPlayStartInformation([ Date.now() ])
			.to.throw('Invalid playStart argument: should be a number')

		describe 'given a negative delta', ->

			it 'should output seconds ago', ->
				result = utils.getPlayStartInformation(Date.now() - 6000)
				expect(result).to.equal('6 seconds ago')

		describe 'given a positive delta', ->

			it 'should output in x seconds', ->
				result = utils.getPlayStartInformation(Date.now() + 6000)
				expect(result).to.equal('in 6 seconds')

		describe 'given a zero delta', ->

			it 'should output now', ->
				result = utils.getPlayStartInformation(Date.now())
				expect(result).to.equal('now')
