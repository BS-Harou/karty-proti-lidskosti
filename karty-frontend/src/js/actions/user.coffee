types = 
	INVALIDATE_USER: 'invalidate-user'
	LOGIN_USER: 'request-user'
	RECEIVE_USER: 'receive-user'
	JOINED_GAME: 'joined-game'
	SESSION_LOGIN: 'session-login'
	LOGOUT: 'logout'
	LOGGED_OUT: 'logged-out'
	FAILED_LOGIN: 'failed_login'
	DISMISS_ERROR: 'dismiss_error'

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

	failedLogin: (errorMessage = '') ->
		type: types.FAILED_LOGIN
		errorMessage: errorMessage

	dismissError: ->
		type: types.DISMISS_ERROR
	  
	receiveUser: (user) ->
		type: types.RECEIVE_USER
		data: user
		receivedAt: Date.now()

Object.assign actions, types

module.exports = actions