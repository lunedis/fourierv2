Template.fittingCountSelect.helpers
  fittings: ->
    fitData = @data.fittings

    visibleFits = _.pluck(fitData, 'id')

    fitIDs = Doctrines.findOne({_id: @doctrine}).fittings

    fittings = Fittings.find({_id: {$in: fitIDs}}).fetch()

    for item in fittings
      if _.contains visibleFits, item._id
        item.visible = "checked"
      else
        item.visible = ""

    return fittings

Template.fittingCountSelect.events
  'change .visibleCheck input': (event) ->
    panelID = Template.currentData()._id

    if event.target.checked
      fit = {id: @_id, count: 0}
      Panels.update panelID, {$push: {'data.fittings': fit}}
    else
      Panels.update panelID, {$pull: {'data.fittings': {'id': @_id}}}