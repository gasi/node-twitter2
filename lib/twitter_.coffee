$ = require 'underscore'
oauth = require 'oauth'
qs = require 'querystring'
status = require 'http-status'


VERSION = '0.0.2'


class Twitter

    constructor: (options) ->

        @defaults =
            consumerKey: null
            consumerSecret: null
            accessTokenKey: null
            accessTokenSecret: null

            headers:
                'Accept': '*/*'
                'Connection': 'close'
                'User-Agent': "node-twitter2/#{VERSION}"

            requestTokenURL: 'https://api.twitter.com/oauth/request_token'
            accessTokenURL: 'https://api.twitter.com/oauth/access_token'
            authenticateURL: 'https://api.twitter.com/oauth/authenticate'
            authorizeURL: 'https://api.twitter.com/oauth/authorize'

            apiBaseURL: 'https://api.twitter.com/1'


        @options = $.defaults options, @defaults
        @oauth = new oauth.OAuth @options.requestTokenURL,
                                 @options.accessTokenURL,
                                 @options.consumerKey,
                                 @options.consumerSecret,
                                 '1.0',
                                 null,          # authorizeCallback
                                 'HMAC-SHA1',   # signatureMethod
                                 null,          # nonceSize
                                 @options.headers


    get: (url, params, _) ->
        try
            data = @oauth.get "#{@options.apiBaseURL}#{url}?#{qs.stringify(params)}",
                                 @options.accessTokenKey,
                                 @options.accessTokenSecret,
                                 _
        catch err
            error = new Error "HTTP Error #{err.statusCode}: #{status[err.statusCode]}"
            error.statusCode = err.statusCode
            error.data = err.data
            throw error

        json = JSON.parse data
        return json


    post: (url, content, contentType, _) ->
        # Workaround: OAuth & Booleans -> broken signatures
        if content? and typeof content is 'object'
            Object.keys(content).forEach (key) ->
                value = content[key]
                if typeof value is 'boolean'
                    content[key] = value.toString()
        try
            data = @oauth.post "#{@options.apiBaseURL}#{url}",
                                  @options.accessTokenKey,
                                  @options.accessTokenSecret,
                                  content,
                                  contentType,
                                  _
        catch err
            error = new Error "HTTP Error #{err.statusCode}: #{status[err.statusCode]}"
            error.statusCode = err.statusCode
            error.data = err.data
            throw error

        json = JSON.parse data
        return json


    # Friendship

    existsFriendship: (userA, userB, _) ->

        params =
            user_a: userA,
            user_b: userB

        @get '/friendships/exists.json', params, _


    createFriendship: (params, _) ->

        ensureUser params

        params = $.defaults params,
                        follow: true
                        include_entities: true

        @post '/friendships/create.json', params, null, _


    # Direct message

    newDirectMessage: (params, _) ->

        ensureUser params

        @post '/direct_messages/new.json', params, null, _


# Exports

module.exports = Twitter


# Helpers

ensureUser = (params) ->

        if not params? or not (params.user_id or params.screen_name)
            throw new Error 'You must specify either `user_id` or `screen_name`.'

        if params.user_id? and params.screen_name?
            throw new Error '''You can't specify both `user_id` and `screen_name`.'''
