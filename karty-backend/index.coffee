assert = require 'assert'

process.on 'exit', ->
	console.log 'App is being closed'


#
# APIs
#

global.userStore = require './stores/users'
global.gameStore = require './stores/games'
global.cardStore = require './stores/cards'

#
# Express
#


app = require('express')()
http = require('http').Server app
io = require('socket.io')(http)


endpoints =
	cards: require './endpoints/cards'
	games: require './endpoints/games'
	user: require './endpoints/user'

socketCount = 0

app.get '/', (req, res) ->
	res.send """
		<strong>CAH app backend is up and running :)</strong>
		<div>Amount of connected users: #{socketCount}</div>
	"""

global.getResponseCallback = (socket, endpoint) ->
	fn = (data) ->
		socket.emit 'data',
			endpoint: endpoint
			value: JSON.stringify data
	fn.broadcast = (data, ep = endpoint) ->
		io.emit 'data',
			endpoint: ep
			value: JSON.stringify data
	fn

io.on 'connection', (socket) ->
	socketCount++
	console.log 'Socket.io: a client connected'

	socketData =
		user: null

	socket.on 'data', (msg) ->
		console.log 'Socket.io message: ', msg
		return unless msg?.endpoint and typeof(msg.endpoint) is 'string'

		path = msg.endpoint.split '/'
		path.shift() if path[0].length is 0

		endpoints[path[0]]?[path[1]]? msg.value, getResponseCallback(socket, msg.endpoint), socketData, socket

	socket.on 'disconnect', ->
		socketCount--
		console.log 'Socket.io: a client disconnected'

http.listen 3000, ->
	console.log 'listening on *:3000'