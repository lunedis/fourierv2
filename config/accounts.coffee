Meteor.startup ->
  Accounts.config
	 forbidClientAccountCreation: true

Meteor.users.isAdmin = (user) ->
  return _.contains user.authGroup, 'admin'