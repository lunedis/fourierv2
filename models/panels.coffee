@Panels = new Mongo.Collection 'panels'

Panels.attachSchema new SimpleSchema
  view:
    type: String
    label: "Parent View"
  type:
    type: String
    label: "Type"
  title:
    type: String
    label: "Title"
    optional: true
  doctrine:
    type: String
    label: "Doctrine"
    optional: true
  data:
    type: Object
    optional: true
    blackbox: true

Panels.allow
  insert: ->
    isAdmin()
  update: ->
    isAdmin()
  remove: ->
    isAdmin()

Meteor.methods
  'updateFittingCount': (panelID, fitID, count) ->
    check panelID, String
    check fitID, String
    check count, Number

    if isAdmin()
      Panels.update {_id: panelID, 'data.fittings.id': fitID}, {$inc: {'data.fittings.$.count': count}}