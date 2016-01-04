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


Template.doctrine.rendered = ->
  # anchor scrolling
  hash = document.location.hash.substr(1);
  if hash && !Template.doctrine.scrolled
    scroller = ->
      $("html, body").stop()

    Meteor.setTimeout ->
      elem = $('#'+hash)
      if elem.length
        scroller().scrollTop elem.offset().top
        # Guard against scrolling again w/ reactive changes
        Template.doctrine.scrolled = true
    , 0

Template.doctrine.destroyed = ->
  delete Template.doctrine.scrolled;


Template.doctrine.helpers
  roles: ->
    fitIDs = @fittings
    fittings = _.sortBy Fittings.find({_id: $in: fitIDs}).fetch(), 'shipTypeName'
    grouped = _.groupBy fittings, 'role'
    result = []
    _.each grouped, (value, key, list) ->
      result.push {"role": key, "fits": value}

    return _.sortBy result,'role'
  AddFittingsSchema: ->
    AddFittingsSchema
  fromDoctrine: ->
    return links: @links, doctrine: @_id


Template.fit.events
  'click .delete': ->
    if confirm 'Are you sure?'
      fitID = @_id
      Fittings.remove fitID
      slug = Router.current().params.slug
      doctrine = Doctrines.findOne {slug: slug}
      Doctrines.update doctrine._id,
        $pull:
          fittings: fitID

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
