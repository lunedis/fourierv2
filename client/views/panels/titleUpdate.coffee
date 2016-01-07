Template.titleUpdate.events
  'submit .titleUpdate': (event) ->
    event.preventDefault()
    title = event.target.title.value
    Panels.update @_id, 
      $set: 
        'title': title