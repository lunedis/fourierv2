@CreateUser = (username, email, password) ->
	Accounts.createUser
		username: username
		email: email
		password: password