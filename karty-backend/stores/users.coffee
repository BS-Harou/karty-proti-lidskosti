class User
	constructor: (nickname) ->
		@nickname = nickname
		@id = String(Math.random())
		@session = String(Math.random())


module.exports =
	userList: {}
	hasUser: (nickname) ->
		for userId, user of @userList when user.nickname is nickname
			return yes
		return no

	addUser: (nickname) ->
		return null if @hasUser nickname
		newUser = new User nickname
		@userList[newUser.id] = newUser
		return newUser

	removeUser: (userId) ->
		exists = !!@userList[userId]
		delete @userList[userId]
		return exists

	getUser: (id) ->
		return @userList[id] or null

	getUserBySession: (session) ->
		for userId, user of @userList when user.session is session
			return user
		return null
