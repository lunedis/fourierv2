Meteor.publish null, ->
  if not @userId
    @ready()
  else
    Meteor.users.find @userId, fields:
      keyID: 1
      vCode: 1
      authGroup: 1

Meteor.publish 'doctrines', ->
  if not @userId
    @ready()
  else
    Doctrines.find({public: true})

Meteor.publish 'allDoctrines', ->
  if not @userId or not Meteor.users.isAdmin(@userId)
    @ready()
  else
    Doctrines.find()

Meteor.publish 'fittings', ->
  if not @userId
    @ready()
  else
    Fittings.find({public: true})

Meteor.publish 'allFittings', ->
  if not @userId or not Meteor.users.isAdmin(@userId)
    @ready()
  else
    Fittings.find()

Meteor.publish 'views', ->
  if not @userId or not Meteor.users.isAdmin(@userId)
    @ready()
  else
    Views.find()

Meteor.publish 'panels', (view) ->
  check(view, String)
  if not @userId or not Meteor.users.isAdmin(@userId)
    @ready()
  else
    Panels.find view: view

Meteor.publish 'targetpresets', ->
  if not @userId or not Meteor.users.isAdmin(@userId)
    @ready()
  else
    TargetPresets.find {}

Meteor.publish 'attackerpresets', ->
  if not @userId or not Meteor.users.isAdmin(@userId)
    @ready()
  else
    AttackerPresets.find {}