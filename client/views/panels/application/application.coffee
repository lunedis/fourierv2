Template.application.rendered = ->
  this.autorun =>
    panelData = Template.currentData().data
    fittings = Fittings.find({_id: {$in: panelData.fittings}}).fetch()

    webs = []
    if panelData.webs?
      webs = panelData.webs

    tps = []
    if panelData.tps?
      tps = panelData.tps

    navigation = Desc.applyEwar panelData.targetNavigation, webs, tps

    if panelData.staticY
      maxDPS = _.max (fit.stats.damage.total for fit in fittings)
    else 
      maxDPS = null

    @$('.dmgApplication').highcharts
      chart:
        type: 'spline'
      title:
        text:
          ''
      plotOptions:
        series:
          animation: false
        spline:
          marker:
            enabled: false
      tooltip:
        crosshairs: true,
        valueDecimals: 0,
        headerFormat: '<span>{point.key}k:</span><br/>'
      yAxis:
        min: 0
        max: maxDPS
      xAxis:
        min: 0
      series: _.map fittings, (ship) ->
        return {
          name: "#{ship.shipTypeName} (#{ship.name})"
          data: _.map _.range(0,120), (distance) ->
            Desc.dps ship.stats.damage, navigation, distance * 1e3
        }

Template.application.helpers
  TargetPresets: ->
    return TargetPresets.find {}
    

Template.application.events
  'change .speed': (event) ->
    speed = parseInt(event.target.value)
    unless speed == NaN
      Panels.update @_id,
        $set:
          'data.targetNavigation.speed': speed

  'change .sig': (event) ->
    sig = parseInt(event.target.value)
    unless sig == NaN
      Panels.update @_id,
       $set:
         'data.targetNavigation.sig': sig

  'change .preset': (event) ->
    id = event.target.value
    unless id == ''
      preset = TargetPresets.findOne _id: id
      Panels.update @_id,
        $set:
          'data.targetNavigation.sig': preset.sig
          'data.targetNavigation.speed': preset.speed
