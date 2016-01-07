Template.countButtons.events
  'click .countUp': (event) ->
    panel = Template.parentData(2)
    console.log panel
    Meteor.call 'updateFittingCount', panel._id, @_id, 1

  'click .countDown': (event) ->
    panel = Template.parentData(2)
    count = (_.findWhere panel.data.fittings, {id: @_id}).count
    console.log panel
    unless count <= 0
      Meteor.call 'updateFittingCount', panel._id, @_id, -1