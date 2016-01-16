Meteor.startup ->
  Accounts.config
	 forbidClientAccountCreation: true

Meteor.users.isAdmin = (user) ->
  userObj = {}
  if typeof user is 'object'
    userObj = user
  else if typeof user is 'string'
    userObj = Meteor.users.findOne(user)
  else
    return new Meteor.Error 403, "Wrong parameter for isAdmin"

  return _.contains userObj.authGroup, 'admin'