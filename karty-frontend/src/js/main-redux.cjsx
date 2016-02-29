React = require 'react'
ReactDOM = require 'react-dom'
io = require 'socket.io-client'
Highcharts = require 'highcharts-browserify'


window.app = app = {}

#
# Redux stuff
#
Provider = require('react-redux').Provider
Redux = require 'redux'
App = require './app'


cardActions = require './actions/cards'
userActions = require './actions/user'
gameActions = require './actions/games'

rootReducer = require './reducers'
app.store = store = Redux.createStore rootReducer, initialState = undefined

if module.hot
	module.hot.accept './reducers', ->
		nextReducer = require('./reducers')
		store.replaceReducer nextReducer

#
# Sockets
#

JSON.safeParse = (data) ->
	try
		return JSON.parse data
	catch e
		return null
	

storage = window.sessionStorage

app.socket = {}

app.socket = socket = io 'ws://192.168.1.40:3000', 'reconnectionAttempts': 3
socket.on 'connect', ->
	console.log 'Socket.io: connected to server'

	store.dispatch cardActions.requestCards()
	store.dispatch gameActions.requestGames()

	if session = storage.getItem 'session'
		loader.user = no
		store.dispatch userActions.sessionLogin session

loader =
	cards: no
	games: no
	user: yes
	isLoaded: ->
		@cards and @games and @user

socket.on 'reconnect_failed', ->
	store.dispatch userActions.failedLogin 'Spojení ztraceno'

socket.on 'data', (msg) ->

	if msg?.endpoint is '/cards/list'
		store.dispatch cardActions.receiveCards JSON.safeParse msg.value
		loader.cards = yes
		up()

	if msg?.endpoint is '/games/list'
		data = JSON.safeParse msg.value
		store.dispatch gameActions.receiveGames data.gameList
		# TODO set user gameId to null when the gameId is not in list of games
		loader.games = yes
		up()

	if msg?.endpoint is '/games/create' or msg?.endpoint is '/games/join' or msg?.endpoint is '/games/leave'
		data = JSON.safeParse msg.value
		store.dispatch userActions.joinedGame data.gameId

	if msg?.endpoint is '/games/ready' or msg?.endpoint is '/games/start' 
		data = JSON.safeParse msg.value
		# handle errors

	if msg?.endpoint is '/user/login'
		data = JSON.safeParse msg.value
		if not data or data.error
			store.dispatch userActions.failedLogin data?.error
			return
		storage.setItem 'session', data.session
		store.dispatch userActions.receiveUser data

	if msg?.endpoint is '/user/sessionLogin'
		data = JSON.safeParse msg.value
		if not data or data.error
			storage.removeItem 'session'
			store.dispatch userActions.failedLogin data?.error
		else
			store.dispatch userActions.receiveUser data
		loader.user = yes
		up()

	if msg?.endpoint is '/user/logout'
		storage.removeItem 'session'
		store.dispatch userActions.loggedOut()


#
# React
#

up = ->
	if loader.isLoaded()
		main = document.querySelector '#content'
		throw new Error 'No main element' unless main
		ReactDOM.render(
			<Provider store={store}>
				<App />
			</Provider>,
			main
		)


