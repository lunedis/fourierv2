Router.onBeforeAction ->
  if isAdmin()
    @next()
  else
    @render 'noaccess'
, except: ['teddie', 'd', 'SRP']

Router.onBeforeAction ->
  if Meteor.user() 
    @next()
  else
    @render 'noaccess'
, only: ['teddie', 'd', 'SRP']

Router.onAfterAction ->
  window.scrollTo(0,0)
