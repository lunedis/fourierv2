Template.editFitting.onCreated ->
  @autorun ->
    fit = Template.currentData()
    doctrine = Doctrines.findOne {fittings: fit._id}
    fit.links = doctrine.links
    fit.doctrine = doctrine.slug

Template.editFitting.helpers
  UpdateFittingsSchema: ->
    UpdateFittingsSchema