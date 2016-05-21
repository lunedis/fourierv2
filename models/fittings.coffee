@Fittings = new Mongo.Collection 'fittings'

mandatoryDescriptionSchema = new SimpleSchema
  name:
    type: String
    max: 100
    label: "Name"
  role:
    type: String
    label: "Role"
  public:
    type: Boolean
    label: "Public"

descriptionSchema = new SimpleSchema
  description:
    type: String
    label: "Description"
    optional: true
    autoform:
      rows: 5
  priority:
    type: String
    label: "Priority"
    allowedValues: ["", "high", "medium", "low"]
    optional: true
  count:
    type: String
    label: "Count"
    optional: true
  tips:
    type: String,
    label: "Tips"
    optional: true
    autoform:
      rows: 2
  fittingDoctor:
    type: String
    label: "Fitting Doctor"
    optional: true
    autoform:
      rows: 2
  refits:
    type: String
    label: "Refits"
    optional: true
    autoform:
      rows: 5

RefitSchemaBase = new SimpleSchema
  refit:
    type: Object
    label: "Refit"
    optional: true
  'refit.modules':
    type: Array
    label: "Modules"
    optional: true
  'refit.modules.$':
    type: Object
    label: "Module"
  'refit.modules.$.typeName':
    type: String
    label: "TypeName"
  'refit.modules.$.count':
    type: Number
    label: "Count"
  'refit.modules.$.comment':
    type: String
    label: "Comment"
    optional: true
  'refit.modules.$.storage':
    type: String
    label: "Storage"
    allowedValues: ["Ship", "Station"]
  'refit.fittings':
    type: Array
    label: "Fittings"
  'refit.fittings.$':
    type: Object
    label: "Fitting"
  'refit.fittings.$.name':
    type: String
    label: "Name"
  'refit.fittings.$.description':
    type: String
    label: "Description"
    autoform:
      rows: 2

RefitSchemaFit = new SimpleSchema
  'refit.fittings.$.eft':
    type: String
    label: "EFT"
    autoform:
      rows: 4

RefitSchemaExtended = new SimpleSchema
  'refit.modules.$.typeID':
    type: Number
    label: "typeID"
  'refit.modules.$.slot':
    type: String
    label: "Slot"
    allowedValues: ["Highslot", "Medslot", "Lowslot", "Subsystem", "Charge"]
  'refit.fittings.$.loadout':
    type: Object
    label: "Loadout"
    blackbox: true

loadoutSchema = new SimpleSchema
  shipTypeID:
    type: Number
    label: "shipTypeID"
    autoform:
      omit: true
  shipTypeName: 
    type: String
    label: "ShipTypeName"
    autoform:
      omit: true
  loadout:
    type: Object
    label: "Loadout"
    blackbox: true
    autoform:
      omit: true
  stats: 
    type: Object
    label: "Stats"
    blackbox: true
    autoform:
      omit: true

eftSchema = new SimpleSchema
  eft:
    type: String
    label: "EFT"
    autoform:
      rows: 5
  links:
    type: String
    allowedValues: ['none', 'kiting', 'armor', 'shield']
    label: 'Links'
    autoform:
      label: false
      afFieldInput:
        type: 'hidden'
  doctrine:
    type: String
    label: 'Doctrine'
    autoform:
      label: false
      afFieldInput:
        type: 'hidden'

eftSchemaOptional = new SimpleSchema
  eft:
    type: String
    label: "EFT"
    optional: true
    autoform:
      rows: 5
  links:
    type: String
    allowedValues: ['none', 'kiting', 'armor', 'shield']
    label: 'Links'
    autoform:
      label: false
      afFieldInput:
        type: 'hidden'

StoreFittingsSchema = new SimpleSchema(
  [mandatoryDescriptionSchema, descriptionSchema, 
  loadoutSchema, RefitSchemaBase, RefitSchemaExtended])

@AddFittingsSchema = new SimpleSchema(
  [mandatoryDescriptionSchema, eftSchema])

@UpdateFittingsSchema = new SimpleSchema(
  [mandatoryDescriptionSchema, descriptionSchema, 
  eftSchemaOptional, RefitSchemaBase, RefitSchemaFit])

Fittings.attachSchema StoreFittingsSchema

@getEFT = (fit) ->
  eftModule = (module) ->
    s = module.typeName
    if module.chargeName?
      s += ", " + module.chargeName
    s += "\n"
    return s
  eftCharge = (charge) ->
    return charge.typeName + " x" + charge.quantity + "\n"

  eft = "[#{fit.shipTypeName}, #{fit.name}]\n"
  for m in fit.loadout.lows
    eft += eftModule(m) 
  eft += "\n" 
  for m in fit.loadout.mids
    eft += eftModule(m) 
  eft += "\n" 
  for m in fit.loadout.highs
    eft += eftModule(m) 
  eft += "\n" 
  for m in fit.loadout.rigs
    eft += eftModule(m) 
  eft += "\n" 
  for m in fit.loadout.subs
    eft += eftModule(m) 
  eft += "\n" 
  for m in fit.loadout.drones
    eft += eftCharge(m) 
  eft += "\n" 
  for m in fit.loadout.charges
    eft += eftCharge(m) 

  return eft

if Meteor.isServer
  Fittings.allow
    insert: ->
      isAdmin()
    update: ->
      isAdmin()
    remove: ->
      isAdmin()

  transformStats = (obj) ->
    Desc.init()
    parse = Desc.ParseEFT obj.eft
    fit = Desc.FromParse parse

    unless obj.links == 'none'
      fleet = new DescFleet()
      fleet.setSquadCommander Desc.getSkirmishLoki()
      if obj.links == 'armor'
        fleet.setWingCommander Desc.getArmorLoki()
      else if obj.links == 'shield'
        fleet.setWingCommander Desc.getSiegeLoki()
      fleet.setFleetCommander Desc.getInformationLinks() 

      fleet.addFit fit

    delete obj.eft
    delete obj.links
    _.extend obj, parse
    stats = fit.getStats()
    if stats.defense?
      obj.stats = stats.defense
    else
      obj.stats = stats
    return obj

  transformRefit = (obj) ->
    Desc.init()

    for mod in obj['refit.modules']
      mod.typeID = InvTypes.lookup(mod.typeName).typeID
      mod.slot = Desc.getSlotForModule(mod.typeID)

    return obj

  transformRefitFit = (fit) ->
    parse = Desc.ParseEFT fit.eft
    fit.loadout = parse.loadout
    delete fit.eft

    return fit

  Meteor.methods
    addFitting: (document) ->
      check document, AddFittingsSchema
      if isAdmin()
        doctrineID = document.doctrine
        delete document.doctrine
        document = transformStats document
        check document, StoreFittingsSchema
        fitID = Fittings.insert document
        Doctrines.update doctrineID, $push: fittings: fitID
      else
        throw new Meteor.Error 403, 'No Permissions'
    updateFitting: (modifier, documentID) ->
      check modifier, UpdateFittingsSchema
      check documentID, String

      if isAdmin()
        if modifier.$set.eft?
          modifier.$set = transformStats modifier.$set
        else
          delete modifier.$set.links
          delete modifier.$unset.eft

        if modifier.$set['refit.modules']?
          modifier.$set = transformRefit modifier.$set

        if modifier.$set['refit.fittings']?
          for fit in modifier.$set['refit.fittings']
            if fit.eft?
              fit = transformRefitFit fit

        check modifier, StoreFittingsSchema
        Fittings.update documentID, modifier
      else
        throw new Meteor.Error 403, 'No Permissions'

  @RecalculateStats = ->
    fits = Fittings.find().fetch()
    _.each fits, (fit) ->
      doctrine = Doctrines.findOne {fittings: fit._id}
      unless doctrine
        return
      set = {}
      set.links = doctrine.links
      set.eft = getEFT(fit)
            
      newSet = transformStats(set) 
      Fittings.update(fit._id, $set: newSet) 
