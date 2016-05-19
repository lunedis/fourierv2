@SelectText = (text) ->
    doc = document
    if doc.body.createTextRange
        range = document.body.createTextRange()
        range.moveToElementText text
        range.select();
    else if window.getSelection
        selection = window.getSelection()      
        range = document.createRange()
        range.selectNodeContents text
        selection.removeAllRanges()
        selection.addRange(range)


Template.d.rendered = ->
  # anchor scrolling
  hash = document.location.hash.substr(1);
  if hash && !Template.d.scrolled
    scroller = ->
      $("html, body").stop()

    Meteor.setTimeout ->
      elem = $('#'+hash)
      if elem.length
        scroller().scrollTop elem.offset().top
        # Guard against scrolling again w/ reactive changes
        Template.d.scrolled = true
    , 0

Template.d.destroyed = ->
  delete Template.d.scrolled;


Template.d.helpers
  roles: ->
    fitIDs = @fittings
    fittings = _.sortBy Fittings.find({_id: {$in: fitIDs},public: true}).fetch(), 'shipTypeName'
    grouped = _.groupBy fittings, 'role'

    return groupByRole fittings
    
Template.fit.helpers
  difficultyLabelColor: ->
    if @priority == 'high'
      'label-danger'
    else if @priority == 'low'
      'label-success'
    else if @priority == 'medium'
      'label-warning'
    else
      'label-info'

  roleLabelColor: ->
    if @role == 'DPS'
      return 'label-danger'
    else if @role == 'Support'
      return 'label-warning'
    else
      return 'label-info'

Template.refit.helpers
  groupedModules: ->
    _(@refit.modules).chain().sortBy('typeName').groupBy('slot').value()
  refitFittings: ->
    ship = this
    for f in @refit.fittings
      f.shipTypeID = ship.shipTypeID
      f.shipTypeName = ship.shipTypeName
      #f.name = ship.name + " Refit"
    return @refit.fittings