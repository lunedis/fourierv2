Future = Npm.require 'fibers/future'


LDAP_DEFAULTS = 
  url: 'ldap://lumpy.eu',
  port: '389',
  dn: 'ou=People,dc=lumpy,dc=eu',
  createNewUser: true,
  searchResultsProfileMap: [
    resultKey: 'keyID',
    profileProperty: 'keyID'
  ,
    resultKey: 'vCode',
    profileProperty: 'vCode'
  ,
    resultKey: 'authGroup',
    profileProperty: 'authGroup'
  ,
    resultKey: 'accountStatus',
    profileProperty: 'accountStatus'
  ]


class LDAP
  constructor: (options) ->
    # Set options
    @options = _.defaults options, LDAP_DEFAULTS

    # Make sure options have been set
    try 
      check options.url, String
      #check(this.options.dn, String);
    catch e
      throw new Meteor.Error 'Bad Defaults', 'Options not set. Make sure to set LDAP_DEFAULTS.url and LDAP_DEFAULTS.dn!'
    

    # Because NPM ldapjs module has some binary builds,
    # We had to create a wraper package for it and build for
    # certain architectures. The package typ:ldap-js exports
    # 'MeteorWrapperLdapjs' which is a wrapper for the npm module
    @ldapjs = MeteorWrapperLdapjs

  ###
   # Attempt to bind (authenticate) ldap
   # and perform a dn search if specified
   #
   # @method ldapCheck
   #
   # @param {Object} options  Object with username, ldapPass and overrides for LDAP_DEFAULTS object.
   # Additionally the searchBeforeBind parameter can be specified, which is used to search for the DN
   # if not provided.
  ###
  ldapCheck: (options) ->
    options = options || {};

    if not (options.hasOwnProperty('username') and options.hasOwnProperty 'ldapPass' )
      throw new Meteor.Error 403, 'Missing LDAP Auth Parameter'

    ldapAsyncFut = new Future()


    # Create ldap client
    fullUrl = @options.url + ':' + @options.port
    client = null

    if (@options.url.indexOf('ldaps:#') == 0)
      client = @ldapjs.createClient
        url: fullUrl,
        tlsOptions: 
          ca: [@options.ldapsCertificate]
    else
      client = @ldapjs.createClient
        url: fullUrl

    username = options.username.toLowerCase()

    dn = 'uid=' + username + ',' + @options.dn
    
    # Attempt to bind to ldap server with provided info
    client.bind dn, options.ldapPass, (err) =>
      try
        if err
          # Bind failure, return error
          throw new Meteor.Error err.code, err.message

        retObject =
          username: username,
          searchResults: null

        retObject.emptySearch = true;

        # construct list of ldap attributes to fetch
        attributes = [];
        if @options.searchResultsProfileMap
          @options.searchResultsProfileMap.map (item) ->
            attributes.push item.resultKey

        searchOptions =
          scope: 'sub',
          sizeLimit: 1,
          attributes: attributes,
          filter: @options.search

        client.search dn, searchOptions, (err, res) ->
          if err
            ldapAsyncFut.return
              error: err

          res.on 'searchEntry', (entry) ->
            retObject.emptySearch = false
            # Add entry results to return object
            retObject.searchResults = entry.object
            ldapAsyncFut.return retObject

      catch e
        ldapAsyncFut.return
          error: e

    return ldapAsyncFut.wait()

# Register login handler with Meteor
# Here we create a new LDAP instance with options passed from
# Meteor.loginWithLDAP on client side
# @param {Object} loginRequest will consist of username, ldapPass, ldap, and ldapOptions
Accounts.registerLoginHandler 'ldap', (loginRequest) ->
  # If 'ldap' isn't set in loginRequest object,
  # then this isn't the proper handler (return undefined)
  if not loginRequest.ldap
    return undefined

  # Instantiate LDAP with options
  userOptions = loginRequest.ldapOptions or {}
  ldapObj = new LDAP userOptions

  # Call ldapCheck and get response
  ldapResponse = ldapObj.ldapCheck loginRequest

  if ldapResponse.error
    return {
      userId: null
      error: ldapResponse.error }
  else if ldapResponse.emptySearch
    return {
      userId: null
      error: new Meteor.Error 403, 'User not found in LDAP' }
  else

    if not ldapResponse.searchResults
      return {
        userId: null,
        error: new Meteor.Error 403, 'User details not found in LDAP'
      }
    else
      if not ldapResponse.searchResults.accountStatus == 'Internal'
        return {
          userId: null,
          error: new Meteor.Error 403, 'User inactive'
        }

    # Set initial userId and token vals
    userId = null
    stampedToken =
      token: null

    # Look to see if user already exists
    user = Meteor.users.findOne username: ldapResponse.username

    # Login user if they exist
    if user
      userId = user._id

      # Create hashed token so user stays logged in
      stampedToken = Accounts._generateStampedLoginToken()
      hashStampedToken = Accounts._hashStampedToken stampedToken
      # Update the user's token in mongo
      Meteor.users.update userId,
        $push: 
          'services.resume.loginTokens': hashStampedToken

    # Otherwise create user if option is set
    else if ldapObj.options.createNewUser
      userObject =
        username: ldapResponse.username
      
      # Set email
      if ldapResponse.email 
        userObject.email = ldapResponse.email

      # Set profile values if specified in searchResultsProfileMap
      if ldapResponse.searchResults and ldapObj.options.searchResultsProfileMap.length > 0

        profileMap = ldapObj.options.searchResultsProfileMap;
        profileObject = {};

        # Loop through profileMap and set values on profile object
        i = 0
        while i < profileMap.length
          resultKey = profileMap[i].resultKey
          if ldapResponse.searchResults.hasOwnProperty(resultKey)
            profileObject[profileMap[i].profileProperty] = ldapResponse.searchResults[resultKey]
          i++

        # Set userObject profile
        userObject.profile = profileObject


      userId = Accounts.createUser userObject
    else
      # Ldap success, but no user created
      console.log 'LDAP Authentication succeeded for ' + ldapResponse.username + ', but no user exists in Meteor. Either create the user manually or set LDAP_DEFAULTS.createNewUser to true'
      return {
        userId: null
        error: new Meteor.Error 403, 'User found in LDAP but not in application' }

    return {
      userId: userId
      token: stampedToken.token }