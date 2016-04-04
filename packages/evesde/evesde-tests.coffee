Tinytest.add 'invtypes', (test) ->
  s = InvTypes.lookup('Sabre')
  test.equal s.typeName, 'Sabre'

Tinytest.add 'mapsolarsytem complete', (test) ->
  systems1 = MapSolarSystems.complete('PR-')
  test.equal systems1.length, 1, 'Completing PR- should give 1 result'
  test.equal systems1[0].solarSystemID, 30004711, 'PR- should have the id 30004711'
  systems2 = MapSolarSystems.complete('4-C')
  test.equal systems2.length, 2, 'Completing 4-C should give 2 results'
  test.equal systems2[0].solarSystemName, '4-CM8I', 'First result should be 4-CM8I'
