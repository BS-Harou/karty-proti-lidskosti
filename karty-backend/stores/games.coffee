GAME_STATES =
	LOBBY: 'lobby'
	RUNNING: 'running'
	OVER: 'over'

PLAYER_STATES =
	ONLINE: 'online'
	OFFLINE: 'offline'
	DEAD: 'dead'

class Player
	constructor: (userId) ->
		console.log 'USER ID: ', userId

		@nickname = userStore.getUser(userId).nickname
		@id = userId
		@points = 0
		@ready = false
		@master = no
		@cards = []
		@state = PLAYER_STATES.ONLINE

	removeCard: (cardId) ->
		return no unless ~(index = @cards.indexOf cardId)
		@cards.splice index, 1
		return yes

	toJSON: ->
		{ @id, @nickname, @points, @ready, @master, @cards, @state }

class Game
	constructor: (name, userId) ->
		@cardsPerPlayer = 10
		@pointsToWin = 10

		###*
			Name of the game
			@type {string}
		###
		@name = name

		###*
			Unique ID of the game
			@type {string}
		###
		@id = String(Math.random())

		###*
			Array of players in order they connected to game (TODO maybe convert to unordered object?, would require change for czarIndex)
			@type {!Array<!Player>}
		###
		@players = []

		###*
			State of the game, can be LOBBY, RUNNING or OVER
			@type {GAME_STATES}
		###
		@state = GAME_STATES.LOBBY

		###*
			Id of picked black card for current game turn
			@type {string}
		###
		@blackCard = null # picked black card

		###*
			Cards each players has to pick for current turn
			@type {number}
		###
		@cardsRequired = 0

		###*
			Object of arrays containg IDs of picked cards for each player in turn
			@type {!Object<string, Array<number>>}
		###
		@pickedCards = {}

		###*
			Deck of white cards
			@type {!Deck}
		###
		@whiteDeck = cardStore.getWhiteDeck()

		###*
			Deck of black cards
			@type {!Deck}
		###
		@blackDeck = cardStore.getBlackDeck()

		###*
			Index in players array pointing to czar in current game turn
			@type {number}
		###
		@czarIndex = -1

		###*
			Order of players' picked cards, it has to be random to prevent players guessing which card is whose
			@type {number}
		###
		@randomPlayerOrder = {}

		@joinPlayer userId if userId


	canJoin: -> @state is GAME_STATES.LOBBY
	finishGame: ->
		@state = GAME_STATES.OVER
		@czarIndex = -1
		@cardsRequired = 0
		return

	canDestroy: (userId) ->
		return no unless ~(index = @getPlayerIndex userId)
		return no unless @players[index].master
		return no unless @state is 'over'
		yes

	joinPlayer: (userId) ->
		playerIndex = @getPlayerIndex userId
		return no if ~playerIndex and @players[playerIndex].state is PLAYER_STATES.DEAD
		return yes if ~playerIndex
		return no unless @canJoin()
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

		if @state is GAME_STATES.LOBBY
			@players.splice index, 1
			if @players.length is 0
				gameStore.destroyGame @id, null, yes
		else
			@players[index].state = PLAYER_STATES.DEAD
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
		@state = GAME_STATES.RUNNING
		@newTurn()
		return yes

	newTurn: ->
		@pickedCards = {}
		@blackCard = @blackDeck.drawCard()
		@cardsRequired = @getRequiredCardCount @blackCard
		@randomPlayerOrder = @players.map((player) -> player.id).sort(-> Math.random() - 0.5)
		@czarIndex++
		@czarIndex = 0 if @czarIndex >= @players.length
		@players.forEach (player) => 
			while player.cards.length < @cardsPerPlayer
				player.cards.push @whiteDeck.drawCard()
		return

	getRequiredCardCount: (cardId) ->
		card = cardStore.getCard cardId
		return 1 unless card
		card.value.match(/\b_+\b/gm)?.length or 1

	pickCard: (cardId, userId) ->
		return no unless ~(index = @getPlayerIndex userId)
		return no if index is @czarIndex # user pickng card must not be czar
		player = @players[index]
		@pickedCards[player.id] = [] unless Array.isArray @pickedCards[player.id]
		return no if @pickedCards[player.id].length >= @cardsRequired
		player.removeCard cardId
		
		@pickedCards[player.id].push
			'cardId': cardId
			'userId': userId
		return yes

	pickWinner: (winnerId, czarId) ->
		return no unless ~(@getPlayerIndex winnerId) # winner id must be among players
		return no unless ~(index = @getPlayerIndex czarId)   # czar id must be among players
		return no unless index is @czarIndex # user pickng winner must be czar
		for _, userPickedCards of @pickedCards
			userPickedCards.some (pickedCard) =>
				return no unless pickedCard.userId is winnerId
				return no unless winningPlayer = @players[@getPlayerIndex pickedCard.userId]
				winningPlayer.points++
				@finishGame() if winningPlayer.points >= @pointsToWin
				return yes

		@newTurn() if @state is GAME_STATES.RUNNING # prevent newTurn if game just finished
		return yes

	toJSON: ->
		# TODO We need some player id to group the correct card together on frontend, removing the userId will require some other id of the player
		# pickedCards = @pickedCards.map (obj) -> obj.cardId # hide who picked which card from client
		{ @id, @name, @players, @state, @blackCard, @pickedCards, @cardsRequired, @czarIndex, @randomPlayerOrder }


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

	destroyGame: (gameId, userId, force = no) ->
		return no if not force and not @gameList[gameId]?.canDestroy userId
		delete @gameList[gameId]
		return yes

	getGame: (id) ->
		return @gameList[id] or null

	getGameArray: ->
		arr = (game for _, game of @gameList)

	getGameList: ->
		@gameList