@InvTypes = new Meteor.Collection 'invtypes'

InvTypes.deny
  insert: -> 
    true
  update: ->
    true
  remove: ->
    true

Cache = {}

lookup = (typeName) ->
  if Cache[typeName]?
    Cache[typeName]
  else
    Cache[typeName] = InvTypes.findOne typeName: typeName
  
lookupCategory = (typeName, check) ->
  type = lookup(typeName)
  if type? && check(type.categoryName)
    type.typeID
  else
    false

@lookupShip = (typeName) ->
  lookupCategory typeName, (categoryName) ->
    categoryName == 'Ship'

@lookupDrone = (typeName) ->
  lookupCategory typeName, (categoryName) ->
    categoryName == 'Drone'

@lookupCharge = (typeName) ->
  lookupCategory typeName, (categoryName) ->
    categoryName == 'Charge'

@lookupImplant = (typeName) ->
  lookupCategory typeName, (categoryName) ->
    categoryName == 'Implant'

@lookupModule = (typeName) ->
  lookupCategory typeName, (categoryName) ->
    categoryName == 'Module' || categoryName == 'Subsystem'

@lookupName = (typeID) ->
  type = InvTypes.findOne typeID: typeID
  return type.typeName