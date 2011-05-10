# Twitter API Client for Node

This client library let's you access the [Twitter API][twitter-api] from Node.


## Installation

    git clone git@github.com:gasi/node-twitter2.git twitter2
    cd twitter2
    npm install


## Development

    git clone git@github.com:gasi/node-twitter2.git twitter2
    cd twitter2
    npm link


## Usage

    var assert = require('assert');
    var sys = require('sys');
    var Twitter = require('twitter2');


    var twitter = new Twitter({
        // Get: https://dev.twitter.com/apps
        consumerKey: 'CONSUMER_KEY',
        consumerSecret: 'CONSUMER_SECRET',
        accessTokenKey: 'ACCESS_TOKEN',
        accessTokenSecret: 'ACCESS_TOKEN_SECRET'
    });


    twitter.createFriendship({screen_name: 'gasi'}, function (err, user) {
        console.log(err || user);
    });

    twitter.existsFriendship('gasi', 'aseemk', function (err, data) {
        assert.ifError(err);
        assert.strictEqual(data, true, '@gasi MUST follow @aseemk');
    });

    twitter.existsFriendship('gasi', 'canon', function (err, data) {
        assert.ifError(err);
        assert.strictEqual(data, false, '@gasi MUST NOT follow @canon');
    });


## License

This library is licensed under the [Apache License, Version 2.0][license].


## Reporting Issues

If you encounter any bugs or other issues, please file them in the
[issue tracker][issue-tracker].


[twitter-api]: http://dev.twitter.com/pages/api_overview
[issue-tracker]: https://github.com/gasi/node-twitter2/issues
[license]: http://www.apache.org/licenses/LICENSE-2.0.html
