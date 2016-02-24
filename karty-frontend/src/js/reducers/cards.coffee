actions = require '../actions/cards'

initialState =
	isFetching: no
	didInvalidate: no
	items: {}

module.exports = (state = initialState, action) ->

	switch action.type
		when actions.INVALIDATE_CARDS
			Object.assign({}, state, 
				didInvalidate: yes
			)

		when actions.REQUEST_CARDS
			Object.assign({}, state,
				isFetching: yes
				didInvalidate: no
			)

		when actions.RECEIVE_CARDS
			Object.assign({}, state,
				isFetching: no
				didInvalidate: no
				items: action.cards
				lastUpdated: action.receivedAt
			)

		else state
