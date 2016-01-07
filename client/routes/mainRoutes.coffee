Router.route '/',
  name: 'doctrines'
  action: ->
    @render 'doctrines'
    SEO.set title: Meteor.App.NAME + ' - Doctrines'
  waitOn: ->
    Meteor.subscribe 'doctrines'
  fastRender: true

Router.route '/d/:slug',
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
    [Meteor.subscribe('doctrines'), Meteor.subscribe('fittings')]

Router.route 'editFitting/:_id',
  name: 'editFitting'
  action: ->
    @render 'editFitting',
      data: ->
        if !@ready
          return
        Fittings.findOne _id: @params._id
  waitOn: ->
    [Meteor.subscribe('doctrines'), Meteor.subscribe('fittings')]

Router.route 'editDoctrine/:_id',
  name: 'editDoctrine'
  action: ->
    @render 'editDoctrine',
      data: ->
        if !@ready
          return
        Doctrines.findOne _id: @params._id
  waitOn: ->
    [Meteor.subscribe('doctrines')]
