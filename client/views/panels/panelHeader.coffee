Template.panelHeader.helpers
  doctrineName: ->
    Doctrines.findOne(_id: @doctrine).name

Template.panelHeader.events
  'click .settings': (event) ->
    div = $('div.popover', event.target)
    div.toggleClass 'hidden'
  'click  .delete': (event) ->
    console.log @_id
    console.log Template.parentData(2)
    console.log Template.parentData(4)
    console.log Template.parentData(6)
    console.log Template.parentData(8)
    console.log Template.parentData(10)
