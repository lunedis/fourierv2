@SRPRequests = new Mongo.Collection 'srprequests'

@SRPFormSchema = new SimpleSchema
  link:
    type: String
    label: "Zkillboard Link"
  fc:
    type: String
    label: "Fleet Commander"
  type:
    type: String
    label: "Fleet Typ"
    allowedValues: ["Roaming", "Homedef", "Stratop", "CTA", "Sonstiges"]
  comment:
    type: String
    label: "Kommentar"
    optional: true
    autoform:
      rows: 2

SRPAutoSchema = new SimpleSchema
  creator:
    type: String
    label: "Creator"
  date:
    type: String
    label: "Date"
  status:
    type: String
    label: "Status"
    allowedValues: ["Open", "Accepted", "Denied"]

SRPStoreSchema = new SimpleSchema(
  [SRPFormSchema,SRPAutoSchema])

SRPRequests.attachSchema SRPStoreSchema

if Meteor.isServer
  SRPRequests.allow
    insert: ->
      isAdmin()
    update: ->
      isAdmin()
    remove: ->
      isAdmin()

  Meteor.methods
    addSRPRequest: (document) ->
      check document, SRPFormSchema
      document.creator = Meteor.user().username
      document.date = new Date().toISOString().replace(/T/, ' ').replace(/\..+/, '')
      document.status = "Open"
      check document, SRPStoreSchema
      SRPRequests.insert document