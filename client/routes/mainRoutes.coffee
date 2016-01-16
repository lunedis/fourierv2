Router.route '/',
  name: 'teddie'
  action: ->
    @render 'teddie'
    SEO.set title: Meteor.App.NAME + ' - Doctrines'
  waitOn: ->
    [Meteor.subscribe('doctrines'), Meteor.subscribe('fittings')]
  fastRender: true

Router.route '/d/:slug',
  name: 'd'
  action: ->
    @render 'd',
      data: ->
        if !@ready
          return

        doctrine = Doctrines.findOne slug: @params.slug
        if doctrine
          return doctrine
  waitOn: ->
    [Meteor.subscribe('doctrines'), Meteor.subscribe('fittings')]