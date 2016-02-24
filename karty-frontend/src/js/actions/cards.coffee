types = 
	INVALIDATE_CARDS: 'invalidate-cards'
	REQUEST_CARDS: 'request-cards'
	RECEIVE_CARDS: 'receive-cards'

actions =
	
	invalidateCards: ->
		type: types.INVALIDATE_CARDS
	
	requestCards: ->
		app.socket.emit 'data', { 
			endpoint: '/cards/list' 
		}
		type: types.REQUEST_CARDS
	  
	receiveCards: (cards) ->
		type: types.RECEIVE_CARDS
		cards: cards
		receivedAt: Date.now()

Object.assign actions, types

module.exports = actions