login = ->
  username = $('#login-username').val().trim()
  password = $('#login-password').val().trim()
  console.log 'logging in'
  Meteor.loginWithLDAP username, password, (err) -> 
    if (err)
      console.log err.reason

Template.navigation.events
  'click #login-buttons-ldap': (event) ->
    login()
  'click #login-buttons-logout': (event) ->
    Meteor.logout (err)->
  'keypress #login-password': (event) ->
    if event.keyCode == 13
      login()