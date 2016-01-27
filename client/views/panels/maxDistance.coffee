Template.maxDistance.events
  'change .maxDistance': (event) ->
    Panels.update @_id,
      $set:
        'data.maxDistance': event.target.value
