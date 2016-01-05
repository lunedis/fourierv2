Meteor.publish 'doctrines', ->
  Doctrines.find({})

Meteor.publish 'fittings', ->
  Fittings.find()
