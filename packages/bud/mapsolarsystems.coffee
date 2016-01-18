@MapSolarSystems = new Meteor.Collection 'mapsolarsystems'

MapSolarSystems.deny
  insert: -> 
    true
  update: ->
    true
  remove: ->
    true

@complete = (name) ->
  regex = "^#{name}.*"
  MapSolarSystems.find({solarSystemName: {$regex: regex}}).fetch()
