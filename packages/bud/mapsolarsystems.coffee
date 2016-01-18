@MapSolarSystems = new Meteor.Collection 'mapsolarsystems'

MapSolarSystems.deny
  insert: -> 
    true
  update: ->
    true
  remove: ->
    true

@MapSolarSystemJumps = new Meteor.Collection 'mapsolarsystemjumps'

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

@Graph = Npm.require('node-dijkstra')
@g = new Graph()

@setup = ->
  jumps = MapSolarSystemJumps.find({},{sort: {fromSolarSystemID: 1}}).fetch()
  grouped = _.groupBy(jumps, (jump) -> jump.f)
  _.each(grouped, (value, key, list) ->
    connections = {}
    _.each(value, (con) ->
      connections[con.s] = 1
    )
    g.addVertex key, connections
  )

@getRoute = (from, to) ->
  return g.shortestPath(from.toString(), to.toString())