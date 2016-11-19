Template.fittings.helpers
  roles: ->
    fitIDs = @fittings
    fittings = Fittings.find({_id: {$in: fitIDs},public: true},{sort: {priority: -1, shipTypeName: 1}}).fetch()
    return groupByRole fittings
  AddFittingsSchema: ->
    AddFittingsSchema
  fromDoctrine: ->
    return links: @links, doctrine: @_id
  fittingOptions: ->
    return _.sortBy(Fittings.find({}).fetch(), 'shipTypeName');

Template.fittings.events
  'click .delete': ->
    if confirm 'Are you sure?'
      fitID = @_id
      slug = Router.current().params.slug
      doctrine = Doctrines.findOne {slug: slug}
      Doctrines.update doctrine._id,
        $pull:
          fittings: fitID

      if Doctrines.find({fittings: fitID}).fetch().length == 0
        Fittings.remove fitID
  'submit #addExistingFittingForm': (event) ->
    event.preventDefault()
    Doctrines.update(@_id, {$push: {fittings: event.target.existingFitting.value}})
    return false
