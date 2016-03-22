Fleetcomp = {}

Fleetcomp.fromPaste = (paste) ->
  f =
    ships: []
    locations: []
    totalMass: 0

  entries = []

  lines = paste.split("\n")
  for l in lines
    l = l.trim()

    fields = l.split("\t")

    entries.push
      name: fields[0]
      system: fields[1]
      shipTypeName: fields[2]
      shipGroup: fields[3]
      role: fields[4]
      skills: fields[5]
      position: fields[6]

  f.ships = _.chain(entries)
    .countBy('shipTypeName')
    .map((value, key) ->
      s = lookup(key)
      {typeName: key, count: value, mass: s.mass, typeID: s.typeID})
    .sortBy('shipTypeName')
    .reverse()
    .sortBy('count')
    .reverse()
    .value()

  f.locations = _.chain(entries)
    .countBy('system')
    .map((value, key) -> 
      {solarSystemName: key, count: value})
    .sortBy('name')
    .reverse()
    .sortBy('count')
    .reverse()
    .value()

  f.totalMass = _(f.ships).reduce((memo, ship) ->
    memo += ship.mass * ship.count
  ,0)
  return f