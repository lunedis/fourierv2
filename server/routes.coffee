Router.route '/api/:slug', ->
  @response.statusCode = 200
  @response.setHeader "Content-Type", "application/json"
  slugs = @params.slug.split ','
  doctrines = Doctrines.find slug: {$in: slugs}
  dnas = []
  for d in doctrines.fetch()
    fittings = Fittings.find {_id: {$in: d.fittings}}, {sort: {typeName: 1, name: 1}}

    loadout = (f) ->
      l = []
      for i in f.subs
        l.push {typeName: i.typeName, typeID: i.typeID, quantity: 1}
      for i in f.highs
        l.push {typeName: i.typeName, typeID: i.typeID, quantity: 1}
      for i in f.mids
        l.push {typeName: i.typeName, typeID: i.typeID, quantity: 1}
      for i in f.lows
        l.push {typeName: i.typeName, typeID: i.typeID, quantity: 1}
      for i in f.rigs
        l.push {typeName: i.typeName, typeID: i.typeID, quantity: 1}
      for i in f.drones
        l.push {typeName: i.typeName, typeID: i.typeID, quantity: i.quantity}
      for i in f.charges
        l.push {typeName: i.typeName, typeID: i.typeID, quantity: i.quantity}
      l
  
    for f in fittings.fetch()
      dnas.push
        id: f._id
        doctrine: d.name
        name: f.name
        typeName: f.shipTypeName
        typeID: f.shipTypeID
        loadout: loadout f.loadout

  @response.end(JSON.stringify(dnas))
, where: 'server'
