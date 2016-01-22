Router.route '/srp/admin',
  name: 'SRPAdmin'
  action: ->
    @render 'srprequests'
    SEO.set title: Meteor.App.NAME + ' - SRP'
  waitOn: ->
    Meteor.subscribe('srprequests')

Router.route '/srp/',
  name: 'SRP'
  action: ->
    @render 'srp'
    SEO.set title: Meteor.App.NAME + ' - SRP'
  waitOn: ->
    Meteor.subscribe('srprequests')
