InvTypes = new Meteor.Collection 'invtypes'

InvTypes.deny
  insert: -> 
    true
  update: ->
    true
  remove: ->
    true

Cache = {}

InvTypes.lookup = (typeName) ->
  if Cache[typeName]?
    Cache[typeName]
  else
    Cache[typeName] = InvTypes.findOne typeName: typeName
  
InvTypes.lookupCategory = (typeName, check) ->
  type = InvTypes.lookup(typeName)
  if type? && check(type.categoryName)
    type.typeID
  else
    false

InvTypes.lookupShip = (typeName) ->
  InvTypes.lookupCategory typeName, (categoryName) ->
    categoryName == 'Ship'

InvTypes.lookupDrone = (typeName) ->
  InvTypes.lookupCategory typeName, (categoryName) ->
    categoryName == 'Drone'

InvTypes.lookupCharge = (typeName) ->
  InvTypes.lookupCategory typeName, (categoryName) ->
    categoryName == 'Charge'

InvTypes.lookupImplant = (typeName) ->
  InvTypes.lookupCategory typeName, (categoryName) ->
    categoryName == 'Implant'

InvTypes.lookupModule = (typeName) ->
  InvTypes.lookupCategory typeName, (categoryName) ->
    categoryName == 'Module' || categoryName == 'Subsystem'

InvTypes.lookupName = (typeID) ->
  type = InvTypes.findOne typeID: typeID
  return type.typeName