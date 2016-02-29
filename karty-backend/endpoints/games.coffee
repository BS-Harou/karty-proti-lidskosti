ERRORS =
	gameExists: { error: 'Game already exists'}
	notLoggedIn: { error: 'You must login first'}

getGames = ->
	gameStore.getGameList()

createGame = (name) ->
	return ERRORS.gameExists if gameStore.hasGame name
	data = gameStore.addGame name
	return data

destroyGame = (id, user) ->
	return no unless game = gameStore.getGame id
	gameStore.destroyGame game.id, user.id

joinGame = (id, user) ->
	return no unless game = gameStore.getGame id
	game.joinPlayer user.id

readyPlayer = (id, user) ->
	return no unless game = gameStore.getGame id
	game.readyPlayer user.id

leaveGame = (id, user) ->
	return no unless game = gameStore.getGame id
	game.removePlayer user.id

startGame = (id, user) ->
	return no unless game = gameStore.getGame id
	game.startGame user.id

pickCard = (data, user) ->
	return no unless game = gameStore.getGame data.gameId
	game.pickCard parseInt(data.card), user.id

pickWinner = (data, user) ->
	return no unless game = gameStore.getGame data.gameId
	game.pickWinner data.userId, user.id

module.exports =
	list: (data, response) ->
		responseData =
			gameList: getGames data
		response responseData

	create: (data, response, socketData) ->
		return response ERRORS.notLoggedIn unless socketData.user
		game = createGame data
		joined = joinGame game.id, socketData.user
		responseData =
			gameId: if joined then game.id else null
		broadcastData =
			gameList: getGames data
		response responseData
		response.broadcast broadcastData, '/games/list'

	destroy: (data, response, socketData) ->
		return response ERRORS.notLoggedIn unless socketData.user
		destroyGame data, socketData.user
		responseData = {}
		broadcastData =
			gameList: getGames data
		response responseData
		response.broadcast broadcastData, '/games/list'

	join: (data, response, socketData) ->
		return response ERRORS.notLoggedIn unless socketData.user
		joined = joinGame data, socketData.user
		responseData =
			gameId: if joined then data else null
		broadcastData =
			gameList: getGames data
		response responseData
		response.broadcast broadcastData, '/games/list'

	ready: (data, response, socketData) ->
		return response ERRORS.notLoggedIn unless socketData.user
		readyPlayer data, socketData.user
		responseData = {}
		broadcastData =
			gameList: getGames data
		response responseData
		response.broadcast broadcastData, '/games/list'

	start: (data, response, socketData) ->
		return response ERRORS.notLoggedIn unless socketData.user
		startGame data, socketData.user
		responseData = {}
		broadcastData =
			gameList: getGames data
		response responseData
		response.broadcast broadcastData, '/games/list'

	leave: (data, response, socketData) ->
		return response ERRORS.notLoggedIn unless socketData.user
		left = leaveGame data, socketData.user
		responseData =
			gameId: if left then null else data
		broadcastData =
			gameList: getGames data
		response responseData
		response.broadcast broadcastData, '/games/list'

	pick: (data, response, socketData) ->
		return response ERRORS.notLoggedIn unless socketData.user
		pickCard data, socketData.user
		responseData = {}
		broadcastData =
			gameList: getGames data
		response responseData
		response.broadcast broadcastData, '/games/list'

	winner: (data, response, socketData) ->
		return response ERRORS.notLoggedIn unless socketData.user
		pickWinner data, socketData.user
		responseData = {}
		broadcastData =
			gameList: getGames data
		response responseData
		response.broadcast broadcastData, '/games/list'