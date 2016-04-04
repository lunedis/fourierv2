#Tinytest.add 'setup', (test) ->
#  setup()

Tinytest.add 'route calculation', (test) ->
  systems1 = MapSolarSystems.complete('PR-')
  systems2 = MapSolarSystems.complete('Jita')

  route = Routing.getDistance(systems1[0].solarSystemID,systems2[0].solarSystemID)
  test.equal route, 39

