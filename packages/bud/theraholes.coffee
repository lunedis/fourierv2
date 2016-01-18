request = Npm.require('request')
Future = Npm.require 'fibers/future'

@theraHoles = ->
  eveScoutFuture = new Future()
  request "http://www.eve-scout.com/api/wormholes", (error, response, body) ->
    if not error && response.statusCode == 200
      eveScoutFuture.return JSON.parse(body)
    else
      eveScoutFuture.return error: error

  theraHoles = eveScoutFuture.wait()

  systems = _.chain(theraHoles)
    .filter (item) ->
      return item.destinationSolarSystem.regionId < 11000000
    .map (item) ->
      return {
        solarSystemID: item.wormholeDestinationSolarSystemId
        solarSystemName: item.destinationSolarSystem.name
        security: item.destinationSolarSystem.security
        regionID: item.destinationSolarSystem.regionId
        regionName: item.destinationSolarSystem.region.name
      }
    .value()


  console.log systems