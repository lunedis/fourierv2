split = window.location.hostname.split '.'
if split[1] == 'teddie' and split[2] == 'zap' and split[3] == 'de' and split[4] == 'com'
  Session.set('subdomain',split[0])
else
  Session.set('subdomain','eon')

Router.route '/',
  name: 'doctrines'
  action: ->
    @render 'doctrines'
    SEO.set title: Meteor.App.NAME + ' - Doctrines'
  waitOn: ->
    Meteor.subscribe 'doctrines', Session.get('subdomain')
  fastRender: true

Router.route '/:slug',
  name: 'doctrine'
  action: ->
    @render 'doctrine',
      data: ->
        if !@ready
          return

        doctrine = Doctrines.findOne slug: @params.slug
        if doctrine
          return doctrine
  waitOn: ->
    [Meteor.subscribe('doctrines', Session.get('subdomain')), Meteor.subscribe('fittings')]

Router.route 'editFitting/:_id',
  name: 'editFitting'
  action: ->
    @render 'editFitting',
      data: ->
        if !@ready
          return
        Fittings.findOne _id: @params._id
  waitOn: ->
    [Meteor.subscribe('doctrines', Session.get('subdomain')), Meteor.subscribe('fittings')]

Router.route 'editDoctrine/:_id',
  name: 'editDoctrine'
  action: ->
    @render 'editDoctrine',
      data: ->
        if !@ready
          return
        Doctrines.findOne _id: @params._id
  waitOn: ->
    [Meteor.subscribe('doctrines',Session.get('subdomain'))]
