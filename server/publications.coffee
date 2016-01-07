Meteor.publish 'doctrines', ->
  Doctrines.find({})

Meteor.publish 'fittings', ->
  Fittings.find()

Meteor.publish 'views', ->
  Views.find()

Meteor.publish 'panels', (view) ->
  check(view, String)
  Panels.find view: view

Meteor.publish 'targetpresets', ->
  TargetPresets.find {}

Meteor.publish 'attackerpresets', ->
  AttackerPresets.find {}