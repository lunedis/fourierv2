Template.fittings.helpers
  roles: ->
    fitIDs = @fittings
    fittings = _.sortBy Fittings.find({_id: {$in: fitIDs}}).fetch(), 'shipTypeName'
    grouped = _.groupBy fittings, 'role'
    result = []
    _.each grouped, (value, key, list) ->
      result.push {"role": key, "fits": value}

    return _.sortBy result,'role'
  AddFittingsSchema: ->
    AddFittingsSchema
  fromDoctrine: ->
    return links: @links, doctrine: @_id

Template.fittings.events
  'click .delete': ->
    if confirm 'Are you sure?'
      fitID = @_id
      Fittings.remove fitID
      slug = Router.current().params.slug
      doctrine = Doctrines.findOne {slug: slug}
      Doctrines.update doctrine._id,
        $pull:
          fittings: fitID