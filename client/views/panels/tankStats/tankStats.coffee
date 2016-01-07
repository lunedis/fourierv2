subAttr = (obj, attr1, attr2) ->
  key = attr1 + attr2
  obj[key]

Template.tankStats.onCreated ->
  this.autorun =>
    doctrineID = Template.currentData().doctrine
    Template.currentData().tanktype = Doctrines.findOne(doctrineID).links

Template.tankStats.helpers
  fittingsWithTank: ->
    fitData = @data.fittings

    if !fitData?
      return []

    fitList = _.pluck fitData, 'id'
    counts = {}
    for fit in fitData
      counts[fit.id] = fit.count

    fittings = Fittings.find({_id: {$in: fitList}}).fetch()
    totalRep = _.reduce fittings, (memo, ship) =>
      if @tanktype == 'shield' and ship.stats.outgoing.shield?
        memo + ship.stats.outgoing.shield.rr * counts[ship._id]
      else if @tanktype == 'armor' and ship.stats.outgoing.armor?
        memo + ship.stats.outgoing.armor.rr * counts[ship._id]
      else
        return memo
    , 0

    minEHP = {name: '', value: Number.MAX_VALUE}
    minTank = {name: '', value: Number.MAX_VALUE}
    minTTL = {name: '', value: Number.MAX_VALUE}

    min = (variable, ship, attribute) ->
      if ship[attribute] < variable.value
        variable.value = ship[attribute]
        variable.name = "#{ship.shipTypeName} (#{ship.name})"
      return variable

    _.each fittings, (ship) =>
      rep = 0;
      if @tanktype == 'shield' and ship.stats.outgoing.shield?
        rep = ship.stats.outgoing.shield.rr

      if @tanktype == 'armor' and ship.stats.outgoing.armor?
        rep = ship.stats.outgoing.armor.rr
      
      ship.count = counts[ship._id]

      if ship.count > 0
        if subAttr(ship.stats.tank, 'ehp', @tanktype) < minEHP.value
            minEHP.value = subAttr(ship.stats.tank, 'ehp', @tanktype)
            minEHP.name = "#{ship.shipTypeName} (#{ship.name})"

      if (rep == totalRep and ship.count == 1) or ship.count == 0
        ship.tank = 0
        ship.ttl = 0
      else
        ship.tank = subAttr(ship.stats.tank, 'resi', @tanktype) * (totalRep - rep)
        ship.ttl = subAttr(ship.stats.tank, 'ehp', @tanktype) / ship.tank

        minTank = min minTank, ship, 'tank'
        minTTL = min minTTL, ship, 'ttl'

    ret = {}
    ret.fittings = fittings
    ret.totalRep = totalRep
    ret.minEHP = minEHP
    ret.minTank = minTank
    ret.minTTL = minTTL
    return ret
    
Template.tankStatsTable.helpers
  tanktype: ->
    Template.instance().tanktype
  tankattr: (obj, attr, decimals=0) ->
    return formatNumber subAttr(obj, attr, Template.parentData(2).tanktype), decimals
  outgoingattr: (obj, attr, decimals=0) ->
    key = Template.parentData(2).tanktype
    if obj[key]?
      formatNumber obj[key][attr], decimals
    else
      ''