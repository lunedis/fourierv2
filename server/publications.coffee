Meteor.publish 'doctrines',(group) ->
  check(group, String)
  Doctrines.find({group: group})

Meteor.publish 'fittings', ->
  Fittings.find()
