Template.countButtons.events
  'click .countUp': (event) ->
    panel = Template.parentData(3)
    Meteor.call 'updateFittingCount', panel._id, @_id, 1

  'click .countDown': (event) ->
    panel = Template.parentData(3)
   # count = (_.findWhere panel.data.fittings, {id: @_id}).count
   # unless count <= 0
    Meteor.call 'updateFittingCount', panel._id, @_id, -1