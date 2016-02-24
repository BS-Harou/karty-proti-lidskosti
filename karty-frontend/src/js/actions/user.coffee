types = 
	INVALIDATE_USER: 'invalidate-user'
	LOGIN_USER: 'request-user'
	RECEIVE_USER: 'receive-user'
	JOINED_GAME: 'joined-game'
	SESSION_LOGIN: 'session-login'
	LOGOUT: 'logout'
	LOGGED_OUT: 'logged-out'

actions =
	
	invalidateUser: ->
		type: types.INVALIDATE_USER
	
	loginUser: (nickname) ->
		app.socket.emit 'data', { endpoint: '/user/login',  value: nickname }
		type: types.LOGIN_USER

	sessionLogin: (session) ->
		app.socket.emit 'data', { endpoint: '/user/sessionLogin',  value: session }
		type: types.SESSION_LOGIN

	joinedGame: (gameId) ->
		type: types.JOINED_GAME
		gameId: gameId

	logout: ->
		app.socket.emit 'data', { endpoint: '/user/logout' }
		type: types.LOGOUT

	loggedOut: ->
		type: types.LOGGED_OUT
	  
	receiveUser: (user) ->
		type: types.RECEIVE_USER
		data: user
		receivedAt: Date.now()

Object.assign actions, types

module.exports = actions