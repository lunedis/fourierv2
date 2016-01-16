Meteor.publish null, ->
  if not this.userId
    return null
  Meteor.users.find this.userId, fields:
    keyID: 1
    vCode: 1
    authGroup: 1

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