STATES =
	LOBBY: 'lobby'
	RUNNING: 'running'
	OVER: 'over'

class Player
	constructor: (userId) ->
		console.log 'USER ID: ', userId

		@nickname = userStore.getUser(userId).nickname
		@id = userId
		@points = 0
		@ready = false
		@master = no
		@cards = []

	removeCard: (cardId) ->
		return no unless ~(index = @cards.indexOf cardId)
		@cards.splice index, 1
		return yes

	toJSON: ->
		{ @id, @nickname, @points, @ready, @master, @cards }

class Game
	constructor: (name, userId) ->
		@cardsPerPlayer = 10
		@pointsToWin = 10

		@name = name
		@id = String(Math.random())
		@players = []
		@state = STATES.LOBBY
		@joinPlayer userId if userId
		@card = null # picked black card
		@pickedCards = {}
		@whiteDeck = cardStore.getWhiteDeck()
		@blackDeck = cardStore.getBlackDeck()


	canJoin: -> @state is STATES.LOBBY
	finishGame: -> @state = STATES.OVER

	canDestroy: (userId) ->
		return no unless ~(index = @getPlayerIndex userId)
		return no unless @players[index].master
		return no unless @state is 'over'
		yes

	joinPlayer: (userId) ->
		return no unless @canJoin()
		# TODO return if user already in game
		newPlayer = new Player userId
		newPlayer.master = yes unless @players.length
		@players.push newPlayer
		return yes

	getPlayerIndex: (userId) ->
		for player, i in @players
			if player.id is userId
				return i
		return -1

	isEveryoneReady: ->
		@players.every (player) -> player.ready

	removePlayer: (userId) ->
		return no unless ~(index = @getPlayerIndex userId)
		@players.splice index, 1
		return yes

	readyPlayer: (userId) ->
		return no unless ~(index = @getPlayerIndex userId)
		@players[index].ready = yes
		return yes

	startGame: (userId) ->
		return no unless ~(index = @getPlayerIndex userId)
		return no unless @players[index].master
		return no unless @isEveryoneReady()
		# return no unless >= 3 ready users
		# kick not ready users
		@state = STATES.RUNNING
		@newTurn()
		return yes

	newTurn: ->
		@pickedCards = {}
		@card = @blackDeck.drawCard()
		@players.forEach (player) => 
			while player.cards.length < @cardsPerPlayer
				player.cards.push @whiteDeck.drawCard()
		return

	pickCard: (cardId, userId) ->
		return no unless ~(index = @getPlayerIndex userId)
		# return no if pickedCards >= maxCardsForBlackCard
		player = @players[index]
		player.removeCard cardId
		@pickedCards[player.id] = [] unless Array.isArray @pickedCards[player.id]
		@pickedCards[player.id].push
			'cardId': cardId
			'userId': userId

	pickWinner: (winnerId, czarId) ->
		return no unless ~(@getPlayerIndex winnerId) # winner id must be among players
		return no unless ~(@getPlayerIndex czarId)   # czar id must be among players
		# TODO return no unless czarId is czar
		for _, userPickedCards of @pickedCards
			userPickedCards.forEach (pickedCard) =>
				return unless pickedCard.userId is winnerId
				return unless winningPlayer = @players[@getPlayerIndex pickedCard.userId]
				winningPlayer.points++
				if winningPlayer.points >= @pointsToWin
					@finishGame()

		@newTurn() if @state is STATES.RUNNING # prevent newTurn if game just finished

	toJSON: ->
		# TODO We need some player id to group the correct card together on frontend, removing the suerId will require some other id of the player
		# pickedCards = @pickedCards.map (obj) -> obj.cardId # hide who picked which card from client
		{ @id, @name, @players, @state, @card, @pickedCards }


module.exports =
	gameList: {}
	hasGame: (name) ->
		for gameId, game of @gameList when game.name is name
			return yes
		return no

	addGame: (name, playerId) ->
		return null if @hasGame name
		newGame = new Game name
		@gameList[newGame.id] = newGame
		return newGame

	destroyGame: (gameId, userId) ->
		return no unless @gameList[gameId]?.canDestroy userId
		delete @gameList[gameId]
		return yes

	getGame: (id) ->
		return @gameList[id] or null

	getGameArray: ->
		arr = (game for _, game of @gameList)

	getGameList: ->
		@gameList