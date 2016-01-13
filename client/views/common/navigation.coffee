Template.navigation.events
  'click #login-buttons-ldap': (event) ->
    username = $('#login-username').val().trim()
    password = $('#login-password').val().trim()
    console.log 'logging in'
    Meteor.loginWithLDAP username, password, (err) -> 
      if (err)
        console.log err.reason
  'click #login-buttons-logout': (event) ->
    Meteor.logout (err)->
      loginButtonsSession.closeDropdown()