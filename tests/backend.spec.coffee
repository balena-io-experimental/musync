_ = require('lodash')
chai = require('chai')
expect = chai.expect
backend = require('../lib/backend')

describe 'Backend:', ->

	describe 'given a found backend', ->

		beforeEach ->
			@backend = 'grooveshark'

		it 'should return an object with a search function', ->
			result = backend.get(@backend)
			expect(_.isFunction(result.search)).to.be.true

	describe 'given a not found backend', ->

		beforeEach ->
			@backend = 'foobar'

		it 'should throw an error', ->
			expect =>
				backend.get(@backend)
			.to.throw("Invalid backend: #{@backend}")
