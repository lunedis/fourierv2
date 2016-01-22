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
  if isAdminById(@userId)
    Doctrines.find()
  else
    @ready()

Meteor.publish 'fittings', ->
  if not @userId
    @ready()
  else
    Fittings.find({public: true})

Meteor.publish 'allFittings', ->
  if isAdminById(@userId)
    Fittings.find()
  else
    @ready()

Meteor.publish 'views', ->
  if isAdminById(@userId)
    Views.find()
  else
    @ready()

Meteor.publish 'panels', (view) ->
  check(view, String)
  if isAdminById(@userId)
    Panels.find view: view
  else
    @ready()

Meteor.publish 'targetpresets', ->
  if isAdminById(@userId)
    TargetPresets.find()
  else
    @ready()

Meteor.publish 'attackerpresets', ->
  if isAdminById(@userId)
    AttackerPresets.find()
  else
    @ready()


Meteor.publish 'srprequests', ->
  if isAdminById(@userId)
    SRPRequests.find()
  else
    SRPRequests.find({creator: Meteor.users.findOne(_id: @userId).username})