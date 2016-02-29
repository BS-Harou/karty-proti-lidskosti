assert = require 'assert'

fs = require 'fs'

idIterator = 0
parseCards = (data, type) ->
	String(data).split(/\r?\n/gm).map (cardValue) ->
		id: idIterator++
		value: cardValue
		type: type

packages = ['proti-lidskosti', 'pretendyoure']
whiteCards = []
blackCards  = []

for pkg in packages
	whiteDb = fs.readFileSync "data/#{pkg}/white-cards.txt", 'utf8'
	blackDb = fs.readFileSync "data/#{pkg}/black-cards.txt", 'utf8'
	whiteCards = whiteCards.concat parseCards whiteDb, 'white'
	blackCards = blackCards.concat parseCards blackDb, 'black'

allCards = whiteCards.concat blackCards

toMap = (arr, key) ->
	map = {}
	for item in arr
		map[item[key]] = item
	map


class Deck
	allCards: null
	cards: null
	constructor: (cards) ->
		@allCards = Object.keys(cards).map Number
		@cards = @allCards.slice()
		
	drawCard: ->
		@drawCards(1)[0]

	drawCards: (amount = 10) ->
		return [] unless @allCards.length
		drawnCards = []
		while drawnCards.length < amount
			@cards = @allCards.splice() unless @cards.length
			index = Math.floor(Math.random() * @cards.length)
			drawnCards.push @cards[index]
			@cards.splice index, 1
		return drawnCards

module.exports =
	getAllCards: ->
		return toMap allCards, 'id'

	getWhiteCards: ->
		return toMap whiteCards, 'id'

	getBlackCards: ->
		return toMap blackCards, 'id'

	getCard: (cardId) ->
		map = toMap allCards, 'id'
		map[cardId]

	getWhiteDeck: ->
		new Deck @getWhiteCards()

	getBlackDeck: ->
		new Deck @getBlackCards()
