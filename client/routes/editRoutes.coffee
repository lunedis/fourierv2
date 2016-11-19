Router.route 'doctrines',
  name: 'doctrines'
  action: ->
    @render 'doctrines'
    SEO.set title: Meteor.App.NAME + ' - Edit Doctrines'
  waitOn: ->
    [Meteor.subscribe('allDoctrines'), Meteor.subscribe('allFittings')]
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
    [Meteor.subscribe('allDoctrines'), Meteor.subscribe('allFittings')]

Router.route 'doctrines/edit/:_id',
  name: 'editDoctrine'
  action: ->
    @render 'editDoctrine',
      data: ->
        if !@ready
          return
        Doctrines.findOne _id: @params._id
    SEO.set title: Meteor.App.NAME + ' - Edit Doctrine'
  waitOn: ->
    Meteor.subscribe 'allDoctrines'

Router.route 'fitting/edit/:_id',
  name: 'editFitting'
  action: ->
    @render 'editFitting',
      data: ->
        if !@ready
          return
        fit = Fittings.findOne _id: @params._id
        if fit.refit?.fittings?
          for refit in fit.refit.fittings
            refit.eft = getEFT(
              shipTypeName: fit.shipTypeName
              name: refit.name
              loadout: refit.loadout)
        return fit
  waitOn: ->
    [Meteor.subscribe('allDoctrines'), Meteor.subscribe('allFittings')]
