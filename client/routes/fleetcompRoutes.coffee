Router.route '/fleetcomp/',
  name: 'newFleetcomp'
  action: ->
    @render 'fleetcompPaste'
    SEO.set title: Meteor.App.NAME + ' - New Fleetcomp'

Router.route '/f/:_id',
  name: 'f'
  action: ->
    @render 'fleetcomp',
      data: ->
        if !@ready
          return

        fleetcomp = Fleetcomps.findOne @params._id
        if fleetcomp
          return fleetcomp
  waitOn: ->
    Meteor.subscribe('fleetcomps')