Tinytest.add 'bud system complete', (test) ->
  systems1 = complete('PR-')
  test.equal systems1.length, 1, 'Completing PR- should give 1 result'
  systems2 = complete('4-C')
  test.equal systems2.length, 2, 'Completing 4-C should give 2 results'
  test.equal systems2[0].solarSystemName, '4-CM8I', 'First result should be 4-CM8I'
