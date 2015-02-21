_ = require('lodash')

module.exports =

	maximumSkew: _.parseInt(process.env.MAXIMUM_SKEW) or 250
	firebaseUrl: process.env.FIREBASE_URL or 'https://musync.firebaseio.com'
	grace: _.parseInt(process.env.GRACE) or 5000
	setupGrace: _.parseInt(process.env.SETUP_GRACE) or 8000
	backend: process.env.BACKEND or 'grooveshark'
