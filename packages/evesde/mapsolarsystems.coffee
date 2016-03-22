MapSolarSystems = new Meteor.Collection 'mapsolarsystems'

MapSolarSystems.deny
  insert: -> 
    true
  update: ->
    true
  remove: ->
    true

MapSolarSystems.complete = (name) ->
  regex = "^#{name}.*"
  MapSolarSystems.find({solarSystemName: {$regex: regex, $options: 'i'}}).fetch()

   
