apiKey = "060fc1d4-d311-4880-a693-86c2505e6aff"

Router.route '/api/:slug', ->
  if true || @request.headers.apikey == apiKey
    @response.statusCode = 200
    @response.setHeader "Content-Type", "application/json"
    slugs = @params.slug.split ','
    doctrines = Doctrines.find slug: {$in: slugs}
    dnas = []
    for d in doctrines.fetch()
      fittings = Fittings.find {_id: {$in: d.fittings},public: true}, {sort: {typeName: 1, name: 1}}

      loadout = (s) ->
        l = []
        f = s.loadout
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
        if s.refit?.modules?
          for i in _.filter(s.refit.modules, (m) -> m.storage == "Ship")
            l.push {typeName: i.typeName, typeID: i.typeID, quantity: i.count}
        l
  
      for f in fittings.fetch()
        dnas.push
          id: f._id
          doctrine: d.name
          name: f.name
          typeName: f.shipTypeName
          typeID: f.shipTypeID
          loadout: loadout f

    @response.end(JSON.stringify(dnas))
  else
    @response.statusCode = 403
    @response.setHeader "Content-Type", "application/json"
    @response.end(JSON.stringify({error: "No permission"}))
, where: 'server'


Router.route '/api', ->
  if @request.headers.apikey == apiKey
    @response.statusCode = 200
    @response.setHeader "Content-Type", "application/json"
    doctrines = Doctrines.find({public: true},{fields: {"_id": 1, "name": 1, "slug": 1, "links":1}})

    @response.end(JSON.stringify(doctrines.fetch()))
  else
    @response.statusCode = 403
    @response.setHeader "Content-Type", "application/json"
    @response.end(JSON.stringify({error: "No permission"}))
, where: 'server'


