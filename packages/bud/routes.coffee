commands = {}

Router.route('/bud', {where: 'server'}).post () ->
    trigger = @request.body.trigger_word
    args = @request.body.text.replace(trigger, '').trim()
   
    result = commands[trigger].call(this, args)
    @response.end(JSON.stringify(result))

commands['!hello'] = (text) ->
  a = {}
  a.text = "You what m8!?"
  return a

commands['!thera'] = (text) ->
  a = {}
  if text != ''
    systems = MapSolarSystems.complete(text)
    if systems.length == 0
      a.text = 'System not found'
      return a
    else if systems.length > 1
      systemstext = _.pluck(systems, 'solarSystemName').join()
      a.text = "Please be more specific. Maybe you meant: #{systemstext}"
      return a
    else if systems.length == 1
      from = systems[0]
  else
    from = MapSolarSystems.complete('PR-')[0]

  closest = closestTheraHole(from.solarSystemID)

  fromSystem = from.solarSystemName
  entrySystem = closest.system.solarSystemName
  region = closest.system.regionName
  jumps = closest.jumps
  a.text = "Closest entry to Thera from #{fromSystem}:"

  attach = {}
  security = closest.system.security
  prettySecurity = Math.round(security * 100, 2) / 100
  attach.text = "*#{entrySystem}* (#{prettySecurity}) in #{region}, #{jumps}j away"
  if security > 0.45
    attach.color = '#27ae60'
  else if security < 0
    attach.color = '#e74c3c'
  else
    attach.color = '#f39c12'
  attach.fallback = attach.text
  attach['mrkdwn_in'] = ['text','fallback']
  a.attachments = []
  a.attachments[0] = attach
  return a
