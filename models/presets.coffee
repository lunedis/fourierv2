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
      Meteor.user()
    update: ->
      Meteor.user()
    remove: ->
      Meteor.user()

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
      
      document = transformNavigation document 

      check document, TargetPresetsStoreSchema
      TargetPresets.insert document
    editTargetPresetEFT: (modifier, documentID) ->
      check modifier, TargetPresetsEFTSchema
      check documentID, String

      modifier.$set = transformNavigation modifier.$set

      check modifier, TargetPresetsStoreSchema
      TargetPresets.update documentID, modifier


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
      true
    update: ->
      true
    remove: ->
      true

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
      
      document = transformDamage document

      check document, AttackerPresetsStoreSchema
      AttackerPresets.insert document
    'editAttackerPresetEFT': (modifier, documentID) ->
      check modifier, AttackerPresetsEFTSchema
      check documentID, String

      modifier.$set = transformDamage modifier.$set

      check modifier, AttackerPresetsStoreSchema
      AttackerPresets.update documentID, modifier