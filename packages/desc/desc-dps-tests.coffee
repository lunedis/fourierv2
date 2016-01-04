roughly = (test, actual, expected, epsilon) ->
  test.equal(Math.abs(actual - expected) < epsilon, true)

Tinytest.add 'desc dps turret application', (test) ->
  stats =
    turret:
      dps: 55.21825396825397
      optimal: 62118.7658767872
      falloff: 12500
      tracking: 0.031640625
      signatureResolution: 400
    total: 55.21825396825397

  navigation =
    speed: 0
    sig: 140

  dps = Desc.dps stats, navigation, 40000
  roughly test, dps, 56.6, 1e-1
  dps = Desc.dps stats, navigation, 70000
  roughly test, dps, 38, 2

  navigation = 
    speed: 219
    sig: 140

  dps = Desc.dps stats, navigation, 63000
  roughly test, dps, 51, 2

Tinytest.add 'desc dps missile application', (test) ->
  stats =
    missile: 
      dps: 91.08608656580779
      range: 63281.25
      explosionVelocity: 255
      explosionRadius: 30
      drf: 2.8
    total: 91.08608656580779

  navigation =
    speed: 0
    sig: 74.3

  dps = Desc.dps stats, navigation, 50000
  roughly test, dps, 91, 1
  dps = Desc.dps stats, navigation, 70000
  test.equal dps, 0

  navigation =
    speed: 4771
    sig: 74.3

  dps = Desc.dps stats, navigation, 50000
  roughly test, dps, 27, 1

Tinytest.add 'desc dps sentry', (test) ->
  stats = 
    sentry:
      dps: 320
      optimal: 65625
      falloff: 12000
      tracking: 0.03
      signatureResolution: 400
    total: 320

  navigation =
    speed: 0
    sig: 100

  dps = Desc.dps stats, navigation, 50000
  roughly test, dps, 320, 10

Tinytest.add 'desc dps drone', (test) ->
  stats =
    drone:
      dps: 307
      speed: 5654
      range: 60000
    total: 307

  navigation =
    speed: 0
    sig: 100

  dps = Desc.dps stats, navigation, 50000
  roughly test, dps, 307, 1

  dps = Desc.dps stats, navigation, 70000
  roughly test, dps, 0, 1

  navigation =
    speed: 6000
    sig: 75

  dps = Desc.dps stats, navigation, 30000
  roughly test, dps, 0, 1

Tinytest.add 'desc dps web and tp application', (test) ->

  navigation =
    speed: 4815
    sig: 49.7

  oneWeb = Desc.applyEwar(navigation, [0.6], [])
  twoWeb = Desc.applyEwar(navigation, [0.6, 0.6], [])

  ninetyWeb = Desc.applyEwar(navigation, [0.9], [])
  mixedWeb = Desc.applyEwar(navigation, [0.6, 0.9], [])
  mixedWeb2 = Desc.applyEwar(navigation, [0.9, 0.6], [])

  roughly test, oneWeb.speed, 1926, 1
  roughly test, twoWeb.speed, 922, 1
  roughly test, ninetyWeb.speed, 482, 1
  roughly test, mixedWeb.speed, 230, 1
  test.equal mixedWeb.speed, mixedWeb2.speed

  oneTP = Desc.applyEwar(navigation, [], [0.375], yes)
  twoTP = Desc.applyEwar(navigation, [], [0.375, 0.375], yes)
  strongTP = Desc.applyEwar(navigation, [], [0.685771], yes)
  mixedTP = Desc.applyEwar(navigation, [], [0.685771, 0.375], yes)
  mixedTP2 = Desc.applyEwar(navigation, [], [0.375, 0.685771], yes)

  roughly test, oneTP.sig, 66, 1
  roughly test, twoTP.sig, 80, 0.1
  roughly test, strongTP.sig, 79.4, 0.1
  roughly test, mixedTP.sig, 96.4, 0.2
  test.equal mixedTP.sig, mixedTP2.sig