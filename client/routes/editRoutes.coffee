Router.route 'doctrines',
  name: 'doctrines'
  action: ->
    @render 'doctrines'
    SEO.set title: METEOR.App.NAME + ' - Edit Doctrines'
  waitOn: ->
    Meteor.subscribe 'doctrines'
  fastRender: true

Router.route 'doctrines/:slug',
  name: 'fittings'
  action: ->
    @render 'fittings',
      data: ->
        if !@ready
          return

        doctrine = Doctrines.findOne slug: @params.slug
        if doctrine
          return doctrine
  waitOn: ->
    [Meteor.subscribe('doctrines'), Meteor.subscribe('fittings')]

Router.route 'doctrines/edit/:_id',
  name: 'editDoctrine'
  action: ->
    @render 'editDoctrine',
      data: ->
        if !@ready
          return
        Doctrines.findOne _id: @params._id
    SEO.set title: METEOR.App.NAME + ' - Edit Doctrine'
  waitOn: ->
    Meteor.subscribe 'doctrines'

Router.route 'fitting/edit/:_id',
  name: 'editFitting'
  action: ->
    @render 'editFitting',
      data: ->
        if !@ready
          return
        Fittings.findOne _id: @params._id
  waitOn: ->
    [Meteor.subscribe('doctrines'), Meteor.subscribe('fittings')]