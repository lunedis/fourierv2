Template['view'].helpers
  rowTemplate: ->
    if @full?
      'fullRow'
    else if @left? or @right?
      'splitRow'

Template.view.events
  'click .full': ->
    Views.update @_id,
      $push:
        layout:
          full: 'new'
  'click .split': ->
    Views.update @_id,
      $push:
        layout:
          right: 'new'
          left: 'new'

Template.fullRow.helpers
  panel: ->
    if !@full? or @full == 'new'
      {type: 'newPanel', target: 'full'}
    else
      Panels.findOne _id: @full
  

Template.splitRow.helpers
  leftPanel: ->
    if !@left? or @left == 'new'
      {type: 'newPanel', target: 'left'}
    else
      Panels.findOne(_id: @left)
  rightPanel: ->
    if !@right? or @right == 'new'
      {type: 'newPanel', target: 'right'}
    else
      Panels.findOne(_id: @right)

Template.newPanel.helpers
  doctrines: ->
    Doctrines.find {}
  types: ->
    ['overview', 'tankStats', 'application', 'mitigation']

Template.newPanel.events
  'submit .newPanel': (event) ->
    title = event.target.title.value
    doctrine = event.target.doctrine.value
    type = event.target.type.value

    view = Template.parentData(8)
    viewID = view._id

    rowCount = view.layout.length

    event.preventDefault()

    panelID = Panels.insert
      title: title
      doctrine: doctrine
      type: type
      view: viewID
      data: 
        fitting: []

    update = $set: {}
    key = 'layout.' + (rowCount - 1) + '.' + @target

    update.$set[key] = panelID

    Views.update viewID, update
