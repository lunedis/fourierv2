@Doctrines = new Mongo.Collection 'doctrines'

BasicDoctrineSchema = new SimpleSchema
  name:
    type: String
    label: "Name"
    max: 100
  slug:
    type: String
    label: "Slug"
    max: 100
  category:
    type: "String"
    label: "Category"
    max: 100
  description:
    type: String
    label: "Description"
    optional: true
    autoform:
      rows: 10
  public:
    type: Boolean
    label: "Public"
  links:
    type: String
    label: "Links"
    allowedValues: ['none', 'kiting', 'brawl', 'armor', 'shield']

AdvancedDoctrineSchema = new SimpleSchema
  fittings:
    type: Array
    label: "Fittings"
    optional: true
    autoform:
      omit: true
  'fittings.$':
    type: String

StoreDoctrineSchema = new SimpleSchema [BasicDoctrineSchema, AdvancedDoctrineSchema]

@UpdateDoctrineSchema = new SimpleSchema [BasicDoctrineSchema]

Doctrines.attachSchema StoreDoctrineSchema

Doctrines.allow
  insert: ->
    isAdmin()
  update: ->
    isAdmin()
  remove: ->
    isAdmin()
