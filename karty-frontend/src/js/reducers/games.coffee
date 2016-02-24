actions = require '../actions/games'

initialState =
	isFetching: no
	didInvalidate: no
	items: []

module.exports = (state = initialState, action) ->

	switch action.type
		when actions.INVALIDATE_GAMES
			Object.assign({}, state, 
				didInvalidate: yes
			)

		when actions.REQUEST_GAMES
			Object.assign({}, state,
				isFetching: yes
				didInvalidate: no
			)

		when actions.RECEIVE_GAMES
			Object.assign({}, state,
				isFetching: no
				didInvalidate: no
				items: action.games
				lastUpdated: action.receivedAt
			)

		when actions.CREATE_NEW_GAME
			Object.assign({}, state,
				isFetching: yes
				didInvalidate: no
			)

		when actions.DESTROY_GAME
			Object.assign({}, state,
				isFetching: yes
				didInvalidate: no
			)

		when actions.JOIN_GAME
			Object.assign({}, state,
				isFetching: yes
				didInvalidate: no
			)

		when actions.GET_READY
			Object.assign({}, state,
				isFetching: yes
				didInvalidate: no
			)

		when actions.START_GAME
			Object.assign({}, state,
				isFetching: yes
				didInvalidate: no
			)

		when actions.LEAVE_GAME
			Object.assign({}, state,
				isFetching: yes
				didInvalidate: no
			)

		when actions.PICK_CARD
			Object.assign({}, state,
				isFetching: yes
				didInvalidate: no
			)

		when actions.PICK_WINNER
			Object.assign({}, state,
				isFetching: yes
				didInvalidate: no
			)

		else state
