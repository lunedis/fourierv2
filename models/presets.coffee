@TargetPresets = new Mongo.Collection 'targetpresets'

@TargetPresetsStoreSchema = new SimpleSchema
  name:
    type: String
    label: "Name"
  speed:
    type: Number
    label: "Speed"
    decimal: true
  sig:
    type: Number
    label: "Signature Radius"
    decimal: true
  mwd:
    type: Boolean
    label: "MWD activated yes/no"

@TargetPresetsEFTSchema = new SimpleSchema
  name:
    type: String
    label: "Name"
  eft:
    type: String
    label: "EFT Fitting"
    autoform:
      rows: 5
  links:
    type: Boolean
    label: "Links yes/no"

TargetPresets.attachSchema TargetPresetsStoreSchema

if Meteor.isServer
  TargetPresets.allow
    insert: ->
      isAdmin()
    update: ->
      isAdmin()
    remove: ->
      isAdmin()

  transformNavigation = (obj) ->
    Desc.init()
    fit = Desc.FromEFT obj.eft
    if obj.links? and obj.links
      fleet = new DescFleet
      fleet.setSquadCommander Desc.getSkirmishLoki()
      fleet.addFit fit

    navigations = fit.getNavigation()
    delete obj.eft
    delete obj.links

    obj.speed = navigations[1].speed
    obj.sig = navigations[1].sig
    obj.mwd = navigations[1].typeName.indexOf('Microwarpdrive') > -1

    return obj

  Meteor.methods
    addTargetPresetEFT: (document) ->
      check document, TargetPresetsEFTSchema
      
      if isAdmin()
        document = transformNavigation document 

        check document, TargetPresetsStoreSchema
        TargetPresets.insert document
      else
        throw new Meteor.Error 403, 'Not allowed' 
    editTargetPresetEFT: (modifier, documentID) ->
      check modifier, TargetPresetsEFTSchema
      check documentID, String

      if isAdmin()
        modifier.$set = transformNavigation modifier.$set

        check modifier, TargetPresetsStoreSchema
        TargetPresets.update documentID, modifier
      else
        throw new Meteor.Error 403, 'Not allowed' 

@AttackerPresets = new Mongo.Collection 'attackerpresets'

AttackerPresetsStoreSchema = new SimpleSchema
  name:
    type: String
    label: 'Name'
  total:
    type: Number
    label: 'Total DPS'
    decimal: true

  turret:
    type: Object
    label: 'Turret'
    optional: true
    blackbox: true
  missile:
    type: Object
    label: "Missile"
    optional: true
    blackbox: true
  drone:
    type: Object
    label: 'Drone'
    optional: true
    blackbox: true
  sentry:
    type: Object
    label: 'sentry'
    optional: true
    blackbox: true


@AttackerPresetsEFTSchema = new SimpleSchema
  name:
    type: String
    label: 'Name'
  eft:
    type: String
    label: 'EFT Fitting'
    autoform:
      rows: 5

AttackerPresets.attachSchema AttackerPresetsStoreSchema

if Meteor.isServer
  AttackerPresets.allow
    insert: -> 
      isAdmin()
    update: -> 
      isAdmin()
    remove: ->
      isAdmin()

  transformDamage = (obj) ->
    Desc.init()
    fit = Desc.FromEFT obj.eft

    damage = fit.getDamage()
    delete obj.eft

    _.extend obj, damage
    return obj

  Meteor.methods
    'addAttackerPresetEFT': (document) ->
      check document, AttackerPresetsEFTSchema

      if isAdmin()
        document = transformDamage document

        check document, AttackerPresetsStoreSchema
        AttackerPresets.insert document
      else
        throw new Meteor.Error 403, 'Not allowed'
    'editAttackerPresetEFT': (modifier, documentID) ->
      check modifier, AttackerPresetsEFTSchema
      check documentID, String

      if isAdmin()
        modifier.$set = transformDamage modifier.$set

        check modifier, AttackerPresetsStoreSchema
        AttackerPresets.update documentID, modifier
      else
        throw new Meteor.Error 403, 'Not allowed'