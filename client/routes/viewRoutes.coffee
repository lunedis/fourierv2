Router.route '/views',
  name: 'views'
  action: ->
    @render 'views',
      data: ->
        if !@ready
          return
        Views.find {}
  waitOn: ->
    Meteor.subscribe 'views'

Router.route '/view/:_id',
  name: 'view'
  action: ->
    @render 'view', 
      data: ->
        if !@ready
          return
        Views.findOne this.params._id
  waitOn: ->
    [Meteor.subscribe('views'),Meteor.subscribe('panels', this.params._id), Meteor.subscribe('allDoctrines'),Meteor.subscribe('allFittings'), Meteor.subscribe('targetpresets'), Meteor.subscribe('attackerpresets')]