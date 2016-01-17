Meteor.startup ->
  Accounts.config
	 forbidClientAccountCreation: true

@_isAdmin = (user) ->
  return _.contains user.authGroup, 'admin'

@isAdmin = ->
  return Meteor.user() && _isAdmin(Meteor.user())

@isAdminById = (userId) ->
  return userId && _isAdmin(Meteor.users.findOne({_id: userId}))