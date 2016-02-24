assert = require 'assert'

fs = require 'fs'

idIterator = 0
parseCards = (data, type) ->
	String(data).split(/\r?\n/gm).map (cardValue) ->
		id: idIterator++
		value: cardValue
		type: type

whiteCards = fs.readFileSync 'data/white-cards.txt', 'utf8'
blackCards = fs.readFileSync 'data/black-cards.txt', 'utf8'

whiteCards = parseCards whiteCards, 'white'
blackCards = parseCards blackCards, 'black'

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
			index = Math.round(Math.random() * @cards.length)
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

	getWhiteDeck: ->
		new Deck @getWhiteCards()

	getBlackDeck: ->
		new Deck @getBlackCards()
