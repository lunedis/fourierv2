Template.navigation.events
  'click #login-buttons-ldap': (event) ->
    username = $('#login-username').val().trim()
    password = $('#login-password').val().trim()
    console.log 'logging in'
    Meteor.loginWithLDAP username, password,
        # The dn value depends on what you want to search/auth against
        # The structure will depend on how your ldap server
        # is configured or structured.
      dn: "uid=" + username + ",ou=People,dc=lumpy,dc=eu",
        # The search value is optional. Set it if your search does not
        # work with the bind dn.
      # search: "(objectclass=*)"
    , (err) -> 
      if (err)
        console.log err.reason