#Tinytest.add 'setup', (test) ->
#  setup()

TEST_PASTE = '''
Lorraine Denniard	J115405	Sabre	Interdictor	Squad Member	0 - 0 - 0	Wing 1 / Squad 1
Lucia Denniard	J115405	Paladin	Marauder	Squad Commander (Boss)	0 - 0 - 5	Wing 1 / Squad 1
'''

Tinytest.add 'invtypes', (test) ->
  s = lookup('Sabre')
  test.equal s.typeName, 'Sabre'

Tinytest.add 'fleetcomp parse and basic information', (test) ->
  f = Fleetcomp.fromPaste(TEST_PASTE)
  test.equal f.ships[0].count, 1, 'Should be 1 Sabre'
  test.equal f.ships[1].typeName, 'Paladin', 'Should be 1 Paladin'
  test.equal f.ships[1].typeID, 28659, 'Paladin typeID'

  test.equal f.locations[0].count, 2, 'Two People'
  test.equal f.locations[0].solarSystemName, 'J115405', 'System Name'
  test.equal f.totalMass, 93530000, 'Mass of fleet'