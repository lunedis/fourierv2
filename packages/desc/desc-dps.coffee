Desc = {}

Desc.dps = (stats, n, distance) ->
  dps = 0
  if stats.turret?
    t = stats.turret
    dps += stats.turret.dps * Desc.turretApplication(
      t.optimal, t.falloff, t.tracking, t.signatureResolution,
      n.speed, n.sig, distance)

  if stats.missile?
    m = stats.missile
    dps += stats.missile.dps * Desc.missileApplication(
      m.range, m.explosionRadius, m.explosionVelocity, m.drf, 
      n.speed, n.sig, distance)

  if stats.sentry?
    s = stats.sentry
    dps += stats.sentry.dps * Desc.turretApplication(
      s.optimal, s.falloff, s.tracking, s.signatureResolution,
      n.speed, n.sig, distance)

  if stats.drone?
    d = stats.drone
    dps += stats.drone.dps * Desc.droneApplication(
      d.range, d.speed,
      n.speed, n.sig, distance)

  return dps

Desc.turretApplication = (optimal, falloff, tracking, sigres, speed, sig, distance) ->
  trackingPart = Math.pow((speed / (distance * tracking)) * (sigres / sig), 2)
  rangePart = Math.pow(Math.max(0, distance - optimal) / falloff, 2)
  chanceToHit = Math.pow(0.5, trackingPart + rangePart)
  if chanceToHit < 0.01
    3 * chanceToHit
  else
    (Math.pow(chanceToHit,2) + chanceToHit + 0.0499) / 2

Desc.missileApplication = (range, explosionRadius, explosionVelocity, drf, speed, sig, distance) ->
  if (distance > range)
    return 0

  sigPart = sig / explosionRadius
  sigSpeedPart = Math.pow((sig / explosionRadius) * (explosionVelocity / speed), Math.log(drf) / Math.log(5.5))

  Math.min(1, sigPart, sigSpeedPart)

Desc.droneApplication = (range, droneSpeed, speed, sig, distance) ->
  if distance > range
    return 0
  if speed > droneSpeed
    return 0
  return 1

Desc.applyEwar = (navigation, webs, tps, mwd=no) ->
  compare = (a,b) ->
    return b-a

  stacking = (n) ->
    Math.pow(Math.E, -Math.pow(n / 2.67, 2))

  webs.sort compare
  tps.sort compare

  newNav = {}
  newNav.speed = navigation.speed
  newNav.sig = navigation.sig

  for web, i in webs
    factor = (1 - (web * stacking(i)))
    newNav.speed *= factor

  for tp, i in tps
    n = i
    if mwd
      n = i + 1

    factor = 1 + tp * stacking(n)
    newNav.sig *= factor

  return newNav