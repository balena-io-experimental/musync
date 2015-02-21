musync
------

[![dependencies](https://david-dm.org/resin-io/musync.png)](https://david-dm.org/resin-io/musync.png)
[![Build Status](https://travis-ci.org/resin-io/musync.svg?branch=master)](https://travis-ci.org/resin-io/musync)

Play your favourite music in sync with your Raspberry Pis.

Requirements
------------

You'll need:

- A [Resin.io](https://resin.io) account.
- Raspberry Pi (2 or more).
- Speakers (one for each Pi).
- Wifi dongles (one for each Pi).
- A [Firebase](https://www.firebase.com) application.
- The MuSync Frontend application.

Installation
------------

- Register to [Resin.io](https://resin.io), create a Raspberry Pi application, and initialize all your MuSync clients with resin.
- Clone this project:

```sh
$ git clone https://github.com/resin-io/musync.git
```

- Add your resin application's git remote to the musync repo.
- Push to resin.io:

```sh
$ git push resin
```

- Make sure you also install the MuSync Frontend to control your devices.

How it works
------------

[Firebase](https://www.firebase.com) syncs the list of songs to play, which one is the current song, and the start time for the current song (in milliseconds).

This data is modified by the MuSync frontend and propagated to the MuSync clients to play accordingly.

When the MuSync clients receive a song to play, they search for that song in [Grooveshark](http://grooveshark.com) (see the Customisation section to learn how to change the backend) and play it accordingly.

MuSync includes an audio skew correction mechanism to ensure the song is played in sync between all your clients.


Customisation
-------------

You can customise the following aspects of MuSync with their corresponding environment variables. 

### MAXIMUM_SKEW

*Defaults to 250.*

The maximum skew, in milliseconds, between track time and expected time in the track.

### FIREBASE_URL

*Defaults to https://musync.firebaseio.com.*

The [Firebase](https://www.firebase.com) URL.

### GRACE

*Defaults to 5000.*

Delay, in milliseconds, before starting to play to allow devices to synchronise.

### SETUP_GRACE

*Defaults to 8000.*

The time given for initial playback to be setup, preventing the track from starting behind schedule.

### BACKEND

*Defaults to grooveshark.*

MuSync currently works with [Grooveshark](http://grooveshark.com), but you can easily change the backend to get the audio streams from another sources.

To do this, you must create a CoffeeScript file within `lib/backend` that exposes a `search()` function that returns a readable stream to the callback:

#### search(Object song, Function callback)

- `song` is an object containing an `artist` and a `title`.
- `callback` is a function callback with either an error, or an audio stream.

After you have your backend setup, you can change the `BACKEND` environment variable to match your backend CoffeeScript file name, without the `.coffee` extension.

Caveats
-------

- A good and stable internet connection is required for the application to work reliably.
- The application requires all clients, and the frontend to run within the same timezone.

Tests
-----

Run the test suite by doing:

```sh
$ gulp test
```

Contribute
----------

- Issue Tracker: [github.com/resin-io/musync/issues](https://github.com/resin-io/musync/issues)
- Source Code: [github.com/resin-io/musync](https://github.com/resin-io/musync)

Before submitting a PR, please make sure that you include tests, and that [coffeelint](http://www.coffeelint.org/) runs without any warning:

```sh
$ gulp lint
```

Support
-------

If you're having any problem, please [raise an issue](https://github.com/resin-io/musync/issues/new) on GitHub.

License
-------

The project is licensed under the MIT license.
