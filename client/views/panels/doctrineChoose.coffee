Template.doctrineChoose.helpers
  'doctrines': ->
    Doctrines.find {}

  'selected': ->
    if @_id == Template.parentData().doctrine
      return 'selected'
    return ''

Template.doctrineChoose.events
  'change .doctrineChoose': (event) ->
    event.preventDefault()
    doctrine = event.target.value
    Panels.update @_id,
      $set:
        'doctrine': doctrine,
        'data.fittings': []