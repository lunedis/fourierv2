Template.staticY.helpers
  'checked': ->
    if @data.staticY
      'checked'
    else
      ''

Template.staticY.events
  'change .staticY': (event) ->
    Panels.update @_id,
      $set:
        'data.staticY': event.target.checked
