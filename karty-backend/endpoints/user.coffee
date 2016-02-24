ERRORS =
	userExists: { error: 'User already exists' }
	invalidUser: { error: 'No user with such id' }
	noUser: { error: 'No user for this socket' }


login = (nickname) ->
	return ERRORS.userExists if userStore.hasUser nickname
	data = userStore.addUser nickname # { nickname: {string}, session: {string}, id: {string} }
	return data

sessionLogin = (session) ->
	user = userStore.getUserBySession session
	return ERRORS.invalidUser unless user
	return user

logout = (userId) ->
	console.log 'LOGOUT: ', userId
	user = userStore.getUser userId
	if user
		userStore.removeUser userId
		return {}
	else
		return ERRORS.invalidUser unless user
	


module.exports =
	login: (data, response, socketData) ->
		loggedUser = login data
		socketData.user = loggedUser
		console.log 'LOGGED USER: ', loggedUser
		response loggedUser

	sessionLogin: (data, response, socketData) ->
		loggedUser = sessionLogin data
		socketData.user = loggedUser
		console.log 'SESSION LOGGED USER: ', loggedUser
		response loggedUser

	logout: (data, response, socketData) ->
		res = ERRORS.noUser
		if socketData.user
			res = logout socketData.user.id
			socketData.user = null 
		response res 