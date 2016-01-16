Router.onBeforeAction ->
  if Meteor.user() and Meteor.users.isAdmin(Meteor.user())
    @next()
  else
    @render 'noaccess'
, except: ['teddie', 'd']

Router.onBeforeAction ->
  if not Meteor.user() and not Meteor.loggingIn()
    @render 'noaccess'
  else
    @next()


, only: ['teddie', 'd']

Router.onAfterAction ->
  window.scrollTo(0,0)