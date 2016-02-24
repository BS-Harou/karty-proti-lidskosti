types = 
	INVALIDATE_GAMES: 'invalidate-games'
	REQUEST_GAMES: 'request-games'
	RECEIVE_GAMES: 'receive-games'
	CREATE_NEW_GAME: 'create-new-game'
	DESTROY_GAME: 'destroy-game'
	JOIN_GAME: 'join-game'
	GET_READY: 'get-ready'
	START_GAME: 'start-game'
	LEAVE_GAME: 'leave-game'
	PICK_CARD: 'pick-card'
	PICK_WINNER: 'pick-winner'

actions =
	
	invalidateGames: ->
		type: types.INVALIDATE_GAMES
	
	requestGames: ->
		app.socket.emit 'data', {
			endpoint: '/games/list'
		}
		type: types.REQUEST_GAMES

	createNewGame: (name) ->
		app.socket.emit 'data', { 
			endpoint: '/games/create'
			value: name
		} 
		type: types.CREATE_NEW_GAME

	destroyGame: (id) ->
		app.socket.emit 'data', { 
			endpoint: '/games/destroy'
			value: id
		} 
		type: types.DESTROY_GAME

	joinGame: (id) ->
		app.socket.emit 'data', { 
			endpoint: '/games/join'
			value: id
		} 
		type: types.JOIN_GAME

	getReady: (id) ->
		app.socket.emit 'data', { 
			endpoint: '/games/ready'
			value: id
		} 
		type: types.GET_READY

	startGame: (id) ->
		app.socket.emit 'data', { 
			endpoint: '/games/start'
			value: id
		} 
		type: types.START_GAME

	leaveGame: (id) ->
		app.socket.emit 'data', { 
			endpoint: '/games/leave'
			value: id
		} 
		type: types.LEAVE_GAME

	pickCard: (id, card) ->
		app.socket.emit 'data', { 
			endpoint: '/games/pick'
			value:
				gameId: id
				card: card
		} 
		type: types.PICK_CARD

	pickWinner: (id, card) ->
		app.socket.emit 'data', { 
			endpoint: '/games/winner'
			value:
				gameId: id
				card: card
		} 
		type: types.PICK_WINNER
	  
	receiveGames: (items) ->
		type: types.RECEIVE_GAMES
		games: items
		receivedAt: Date.now()

Object.assign actions, types

module.exports = actions