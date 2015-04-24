MuSync
------

[![dependencies](https://david-dm.org/resin-io/musync.png)](https://david-dm.org/resin-io/musync.png)

Play your favourite music in sync with your Raspberry Pis.

Requirements
------------

You'll need:

- A [Resin.io](https://resin.io) account.
- Raspberry Pi (2 or more).
- Speakers (one for each Pi).
- Wifi dongles (one for each Pi).
- A [Firebase](https://www.firebase.com) application.
- The [MuSync Frontend application](https://github.com/jviotti/musync-frontend).

Installation
------------

- Register to [Resin.io](https://resin.io), create a Raspberry Pi application, and initialize all your MuSync clients with resin.To do this follow our comprehensive [getting started guide](http://docs.resin.io/#/pages/installing/gettingStarted.md).

- Clone this project:

```sh
$ git clone https://github.com/resin-io/musync.git
```

- Add your resin application's git remote to the musync repo. You can find this in the top right of your resin.io application dashboard.

```sh
$ git remote add resin git@git.resin.io:USERNAME/APPNAME.git
```

- Push to resin.io:

```sh
$ git push resin
```

- While your code is downloading on your device install the [MuSync Frontend](https://github.com/jviotti/musync-frontend) which acts as the client that controls controls and updates the playlist on firebase and subsequently what plays on the devices. 

How it works
------------

![MuSync Frontend Screenshot](https://raw.githubusercontent.com/jviotti/musync-frontend/master/screenshots/screenshot.png)

The [MuSync Frontend](https://github.com/jviotti/musync-frontend) allows users to add a song by artist and song name, this is is synced to the [Firebase](https://www.firebase.com) datastore. The datastore holds the list of songs to play, which one is the current song, and the start time for the current song (in milliseconds).

Each devices watches the firebase datastore. When the MuSync clients receive a song to play, they search for that song in [Grooveshark](http://grooveshark.com) (see the Customisation section to learn how to change the backend) and play it accordingly.

MuSync includes an audio skew correction mechanism to ensure the song is played in sync between all your clients.

Customisation
-------------

You can customise the following aspects of MuSync with their corresponding environment variables. 

You are highly encouraged to specifically tweak `GRACE` and `SETUP_GRACE` to match your internet connection capabilities. The defaults are based on a fairly slow internet speed (less than 10mb/s). If you have a faster connection, decrease the values for improved performance. 

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

To do this, you must create an NPM package called `musync-backend-<your backend name>` that exposes a `search()` function that returns a readable stream to the callback:

#### search(Object song, Function callback)

- `song` is an object containing an `artist` and a `title`.
- `callback` is a function callback with either an error, or an audio stream.

After you have your backend module installed to your MuSync application, you can change the `BACKEND` environment variable to match your backend name, without the `musync-backend-` prefix.

Take a look at the default [musync-backend-grooveshark](https://github.com/resin-io/musync-backend-grooveshark) for an example.

Caveats
-------

- A good and stable internet connection is required for the application to work reliably.
- The application requires all clients and the frontend to run within the same timezone.

Tests
-----

Run the test suite by doing:

```sh
$ gulp test
```

TODO
----

- Improve unit testing in certain parts of the application.

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
