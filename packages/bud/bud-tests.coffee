#Tinytest.add 'setup', (test) ->
#  setup()

Tinytest.add 'bud system complete', (test) ->
  systems1 = complete('PR-')
  test.equal systems1.length, 1, 'Completing PR- should give 1 result'
  test.equal systems1[0].solarSystemID, 30004711, 'PR- should have the id 30004711'
  systems2 = complete('4-C')
  test.equal systems2.length, 2, 'Completing 4-C should give 2 results'
  test.equal systems2[0].solarSystemName, '4-CM8I', 'First result should be 4-CM8I'

#Tinytest.add 'route calculation', (test) ->
#  systems1 = complete('PR-')
#  systems2 = complete('Jita')

  #route = getRoute(systems1[0].solarSystemID, systems2[0].solarSystemID)

  #console.log route.length

Tinytest.add 'theraholes', (test) ->
  theraHoles()