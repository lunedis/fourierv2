@Fleetcomps = new Mongo.Collection 'fleetcomps'

FleetcompsSchema = new SimpleSchema
  entries:
    type: Array
    label: "Entries"
  'entries.$':
    type: Object
    blackbox: true
  ships:
    type: Array
    label: "Ships"
  'ships.$':
    type: Object
    blackbox: true
  locations:
    type: Array
    label: "Locations"
  'locations.$':
    type: Object
    blackbox: true
  docked:
    type: Array
  'docked.$':
    type: Object
    blackbox: true
  commanders:
    type: Array
  'commanders.$':
    type: Object
    blackbox: true
  totalMass:
    type: Number
    label: "Total Mass"

Fleetcomps.attachSchema FleetcompsSchema

if Meteor.isServer
  Fleetcomps.allow
    insert: ->
      isAdmin()
    update: ->
      isAdmin()
    remove: ->
      isAdmin()

  Meteor.methods
    newFleetcomp: (paste) ->
      check paste, String
      if isAdmin()
        f = parseFleetcomp(paste)
        console.log f
        Fleetcomps.insert(f)
      else
        throw new Meteor.Error 403, 'No Permissions'
    updateFleetcomp: (paste, documentID) ->
      check paste, String
      check documentID, String

      if isAdmin()
        f = parseFleetcomp(paste)
        Fleetcomps.update documentID, {$set: f}
      else
        throw new Meteor.Error 403, 'No Permissions'