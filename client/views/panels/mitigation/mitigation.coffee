Template.mitigation.rendered = ->
  this.autorun ->
    panelData = Template.currentData().data
    fittings = Fittings.find({_id: {$in: panelData.fittings}}).fetch()

    if panelData.staticY
      maxDPS = panelData.attackerDamageStats.total
    else
      maxDPS = null

    webs = []
    if panelData.webs?
      webs = panelData.webs

    tps = []
    if panelData.tps?
      tps = panelData.tps

    $('#dmgMitigation' + Template.currentData()._id).highcharts
      title:
        text:
          ''
      chart:
        type: 'spline'
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
          data: _.map _.range(0,100), (distance) ->
            nav = Desc.applyEwar ship.stats.navigation[1], webs, tps
            Desc.dps panelData.attackerDamageStats, nav, distance * 1e3
          }

Template.mitigation.helpers
  AttackerPresets: ->
    AttackerPresets.find {}

Template.mitigation.events
  'change .preset': (event) ->
    id = event.target.value
    unless id == ''
      preset = AttackerPresets.findOne _id: id
      Panels.update @_id,
        $set: 'data.attackerDamageStats': preset
