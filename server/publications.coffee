Meteor.publish null, ->
  if not @userId
    return null
  Meteor.users.find @userId, fields:
    keyID: 1
    vCode: 1
    authGroup: 1

Meteor.publish 'doctrines', ->
  if not @userId
    return null
  Doctrines.find()

Meteor.publish 'fittings', ->
  Fittings.find({public: true})

Meteor.publish 'allFittings', ->
  if not @userId or not Meteor.users.isAdmin(@userId)
    return null
  Fittings.find()

Meteor.publish 'views', ->
  if not @userId or not Meteor.users.isAdmin(@userId)
    return null
  Views.find()

Meteor.publish 'panels', (view) ->
  if not @userId or not Meteor.users.isAdmin(@userId)
    return null
  check(view, String)
  Panels.find view: view

Meteor.publish 'targetpresets', ->
  if not @userId or not Meteor.users.isAdmin(@userId)
    return null
  TargetPresets.find {}

Meteor.publish 'attackerpresets', ->
  if not @userId or not Meteor.users.isAdmin(@userId)
    return null
  AttackerPresets.find {}