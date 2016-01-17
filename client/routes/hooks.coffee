Router.onBeforeAction ->
  if isAdmin()
    @next()
  else
    @render 'noaccess'
, except: ['teddie', 'd']

Router.onBeforeAction ->
  if Meteor.user() 
    @next()
  else
    @render 'noaccess'
, only: ['teddie', 'd']

Router.onAfterAction ->
  window.scrollTo(0,0)
