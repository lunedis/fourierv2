# Pass in username, password as normal
Meteor.loginWithLDAP = (user, password, callback) ->
  # Set up loginRequest object
  loginRequest = 
    username: user,
    ldapPass: password
    ldap: true

  Accounts.callLoginMethod
    # Call login method with ldap = true
    # This will hook into our login handler for ldap
    methodArguments: [loginRequest],
      userCallback: (error, result) ->
        if (error)
          callback && callback(error)
        else
          callback && callback()
