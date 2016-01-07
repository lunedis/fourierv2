Template.fittingSelect.helpers
  fittings: ->
    visibleFits = @data.fittings

    fitIDs = Doctrines.findOne({_id: @doctrine}).fittings

    fittings = Fittings.find({_id: {$in: fitIDs}}).fetch()

    for item in fittings
      if _.contains visibleFits, item._id
        item.visible = "checked"
      else
        item.visible = ""

    return fittings

Template.fittingSelect.events
  'change .visibleCheck input': (event) ->
    panelID = Template.currentData()._id

    if event.target.checked
      Panels.update panelID, {$addToSet: {'data.fittings': @_id}}
    else
      Panels.update panelID, {$pullAll: {'data.fittings': [@_id]}}

