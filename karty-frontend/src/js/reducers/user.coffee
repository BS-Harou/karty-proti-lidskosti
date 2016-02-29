actions = require '../actions/user'

initialState =
	isFetching: no
	didInvalidate: no
	data: {}
	error: null
	gameId: null

module.exports = (state = initialState, action) ->

	switch action.type
		when actions.INVALIDATE_USER
			Object.assign({}, state, 
				didInvalidate: yes
			)

		when actions.LOGIN_USER
			Object.assign({}, state,
				isFetching: yes
				didInvalidate: no
			)

		when actions.SESSION_LOGIN
			Object.assign({}, state,
				isFetching: yes
				didInvalidate: no
			)

		when actions.RECEIVE_USER
			Object.assign({}, state,
				isFetching: no
				didInvalidate: no
				error: null
				data: action.data
				lastUpdated: action.receivedAt
			)

		when actions.JOINED_GAME
			Object.assign({}, state,
				isFetching: no
				didInvalidate: no
				gameId: action.gameId
				lastUpdated: action.receivedAt
			)

		when actions.LOGOUT
			Object.assign({}, state,
				isFetching: no
				didInvalidate: no
				lastUpdated: action.receivedAt
			)

		when actions.LOGGED_OUT
			Object.assign({}, state,
				isFetching: no
				didInvalidate: no
				data: {}
				gameId: null
				lastUpdated: action.receivedAt
			)

		when actions.FAILED_LOGIN
			Object.assign({}, state,
				isFetching: no
				didInvalidate: no
				data: {}
				gameId: null
				error: action.errorMessage
			)

		when actions.DISMISS_ERROR
			Object.assign({}, state,
				error: null
			)

		else state
