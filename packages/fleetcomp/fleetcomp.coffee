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
    skills = fields[5].split(" - ")
    positions = fields[6].split(" / ")
    system = fields[1].replace('(Docked)', '').trim()
    docked = fields[1].indexOf('(Docked)') > 0

    entries.push
      name: fields[0]
      location: fields[1]
      system: system
      docked: docked
      shipTypeName: fields[2]
      shipGroup: fields[3]
      role: fields[4]
      skills:
        fleetCommand: parseInt skills[0]
        wingCommand: parseInt skills[1]
        leadership: parseInt skills[2]
      position: 
        wing: positions[0]
        squad: positions[1]

  f.ships = _.chain(entries)
    .countBy('shipTypeName')
    .map((value, key) ->
      s = InvTypes.lookup(key)
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

  f.docked = _.chain(entries)
    .where {docked: true}
    .value()

  console.log f.docked

  f.commanders = _.chain(entries)
    .filter (entry) ->
      return entry.role.indexOf('Commander') > 0
    .map (entry) ->
      entry.skilled = false
      if entry.role.indexOf('Wing') >= 0
        if entry.skills.wingCommand == 5
          entryskilled = true
      else if entry.role.indexOf('Squad') >= 0
        if entry.skills.leadership == 5
          entry.skilled = true

      entry.shipTypeID = InvTypes.lookup(entry.shipTypeName).typeID
      return entry
    .value()

  f.totalMass = _(f.ships).reduce((memo, ship) ->
    memo += ship.mass * ship.count
  ,0)
  return f