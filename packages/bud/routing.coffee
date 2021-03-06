neo4j = Npm.require('neo4j')
db = new neo4j.GraphDatabase('http://neo4j:thera@localhost:7474')

syncCypher = Async.wrap(db, 'cypher')

@Routing = {}
Routing.clear = ->
  query = """
    MATCH (n)
    OPTIONAL MATCH (n)-[r]-()
    DELETE n,r"""

  syncCypher({query: query})
 
Routing.setup = ->
  systems = MapSolarSystems.find({},{ fields: {'solarSystemID': 1}}).fetch()

  _.each systems, (item) ->
    query = """
      CREATE (system: System {props})
      RETURN system"""

    syncCypher(
      query: query
      params: props: id: item.solarSystemID
    )


  jumps = MapSolarSystemJumps.find({}).fetch()
  _.each jumps, (jump) ->
    query = """
      MATCH (system1:System {id: {id1}})
      MATCH (system2:System {id: {id2}})
      MERGE (system1) -[rel:jumps]-> (system2)"""

    syncCypher(
      query: query
      params:
        id1: jump.f
        id2: jump.s
    )

Routing.getDistance = (from, to) ->
  query = """
    MATCH (system1:System {id: {id1}}),
       (system2:System {id:{id2}}),
       p = shortestPath((system1)-[*..150]-(system2))
   RETURN length(p)"""

  result = syncCypher(
    query: query
    params:
      id1: from
      id2: to
  )
  return result[0]['length(p)']
 
