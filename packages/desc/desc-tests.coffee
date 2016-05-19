TYPE_SCIMITAR = 11978
TYPE_PROTOTYPECLOAK = 11370
TYPE_10MNAFTERBURNERII = 12058
TYPE_50MNMWDII = 12076
TYPE_ORACLE = 4302
TYPE_MEGAPULSELASER = 3057
TYPE_MEDIUMENERGYLOCUSII = 31486
TYPE_SCORCHL = 12820
TYPE_ISHTAR = 12005
TYPE_CURATORII = 28213
TYPE_STASISWEBII = 527
TYPE_PHASEDWEAPONTP = 19814
TYPE_SSMEDIUMPLASMASMARTBOMB = 14220
TYPE_LARGEREMOTESHIELDBOOSTERII = 3608

roughly = (test, actual, expected, epsilon, text='') ->
  test.equal(Math.abs(actual - expected) < epsilon, true, text)

Tinytest.add 'desc init', (test) ->
	test.equal Desc.init(), true

Tinytest.add 'desc navigation basic', (test) ->
  fit = new DescFitting()
  fit.setShip TYPE_SCIMITAR
  stats = fit.getNavigation()
  navigation = stats[0] # no propmod
  test.equal navigation.typeName, 'None'
  test.equal navigation.speed, 316.25
  test.equal navigation.sig, 65

Tinytest.add 'desc tank basic', (test) ->
  fit = new DescFitting()
  fit.setShip TYPE_SCIMITAR
  stats = fit.getTank()
  test.equal stats.resihull, 1
  roughly test, stats.resiarmor, 1.927653498, 1e-3
  roughly test, stats.resishield, 2.285855589, 1e-3
  roughly test, stats.ehphull, 1792, 1
  roughly test, stats.ehparmor, 4050, 1
  roughly test, stats.ehpshield, 4622, 1
  roughly test, stats.ehp, 10465, 1

Tinytest.add 'desc parse and missiles', (test) ->
  kestrel = """[Kestrel, MiG]
  Ballistic Control System II
  Nanofiber Internal Structure II

  5MN Y-T8 Compact Microwarpdrive
  Medium Shield Extender II
  Warp Disruptor II
  Fleeting Propulsion Inhibitor I

  Light Missile Launcher II, Caldari Navy Nova Light Missile
  Light Missile Launcher II, Caldari Navy Nova Light Missile
  Light Missile Launcher II, Caldari Navy Nova Light Missile
  Light Missile Launcher II, Caldari Navy Nova Light Missile

  Small Ancillary Current Router II
  Small Anti-EM Screen Reinforcer I
  Small Core Defense Field Extender I
  Mjolnir Fury Light Missile x500
  Scourge Fury Light Missile x500
  Nova Fury Light Missile x500
  Inferno Fury Light Missile x500
  Caldari Navy Scourge Light Missile x500
  Caldari Navy Inferno Light Missile x1000
  Caldari Navy Nova Light Missile x500
  Caldari Navy Mjolnir Light Missile x500
  Nanite Repair Paste x50
  """

  parse = Desc.ParseEFT kestrel
  test.equal parse.shipTypeID, 602
  test.equal parse.shipTypeName, 'Kestrel'
  test.equal parse.loadout.mids[0].typeID, 5973
  test.equal parse.loadout.highs.length, 4
  test.equal parse.loadout.drones.length, 0
  test.equal parse.loadout.charges.length, 9

  fit = Desc.FromParse parse
  stats = fit.getDamage()

  roughly test, stats.missile.range, 63300, 100
  roughly test, stats.missile.dps, 91.1, 1e-1

Tinytest.add 'desc drones', (test) ->
  VNI = """[Vexor Navy Issue, MiG]
  Damage Control II
  Energized Adaptive Nano Membrane II
  Drone Damage Amplifier II
  Drone Damage Amplifier II
  Nanofiber Internal Structure II
  Medium Ancillary Armor Repairer, Nanite Repair Paste

  Federation Navy 100MN Afterburner
  Faint Epsilon Warp Scrambler I
  Warp Disruptor II
  Medium Electrochemical Capacitor Booster I, Navy Cap Booster 800

  Small Focused Pulse Laser II, Scorch S
  Small Focused Pulse Laser II, Scorch S
  Small Unstable Power Fluctuator I
  Small Unstable Power Fluctuator I

  Medium Auxiliary Nano Pump I
  Medium Drone Speed Augmentor I
  Medium Polycarbon Engine Housing I

  Praetor II x5
  Hammerhead II x5
  Acolyte II x5

  Scorch S x2
  Conflagration S x2
  Imperial Navy Multifrequency S x2
  Nanite Repair Paste x150
  Navy Cap Booster 800 x18
  """

  fit = Desc.FromEFT VNI
  test.equal fit.drones.usedBandwith, 125
  test.equal fit.drones.active, 5
  test.equal fit.drones.inSpace.length, 1
  
  stats = fit.getDamage()
  roughly test, stats.drone.dps, 590, 1
  test.equal stats.drone.range, 60000
  roughly test, stats.drone.speed, 2846, 1

Tinytest.add 'desc smartbomb', (test) ->
  fit = new DescFitting()

  fit.setShip TYPE_ISHTAR
  fit.addModule TYPE_SSMEDIUMPLASMASMARTBOMB

  stats = fit.getDamage()
  roughly test, stats.total, 18, 1
  roughly test, stats.smartbomb.dps, 18, 1
  roughly test, stats.smartbomb.range, 5400, 100

Tinytest.add 'desc cloak', (test) ->
  fit = new DescFitting()

  fit.setShip TYPE_SCIMITAR 
  fit.addModule TYPE_PROTOTYPECLOAK

  nav = fit.getNavigation()

  roughly test, nav[0].speed, 316, 1, 'Cloak should be inactive by default'

Tinytest.add 'desc MJFG', (test) ->
  fit = new DescFitting()

  fit.setShip InvTypes.lookupShip "Stork" 
  fit.addModule InvTypes.lookupModule "Micro Jump Field Generator"

  nav = fit.getNavigation()

  roughly test, nav[0].sig, 69, 1, 'MJFG should not always be active'

Tinytest.add 'desc dualprop', (test) ->
  fit = new DescFitting()

  fit.setShip TYPE_SCIMITAR
  fit.addModule TYPE_10MNAFTERBURNERII
  fit.addModule TYPE_50MNMWDII

  navs = fit.getNavigation()

  ab = navs[1]
  test.equal ab.typeID, TYPE_10MNAFTERBURNERII
  roughly test, ab.speed, 784.7, 1e-1

  mwd = navs[2]
  test.equal mwd.typeID, TYPE_50MNMWDII
  roughly test, mwd.speed, 2085.8, 1e-1

Tinytest.add 'desc T3D', (test) ->
  confessor = """[Confessor, shield beam]
  Heat Sink II
  Heat Sink II
  Heat Sink II
  Micro Auxiliary Power Core II
  Co-Processor II

  5MN Y-T8 Compact Microwarpdrive
  Medium F-S9 Regolith Compact Shield Extender
  Tracking Computer II, Optimal Range Script

  Small Focused Beam Laser II, Aurora S
  Small Focused Beam Laser II, Aurora S
  Small Focused Beam Laser II, Aurora S
  Small Focused Beam Laser II, Aurora S
  [Empty High slot]
  [Empty High slot]

  Small Energy Locus Coordinator II
  Small Energy Locus Coordinator II
  Small Anti-EM Screen Reinforcer II
  """

  fit = Desc.FromEFT confessor
  stats = fit.getStats()

  defense = stats.defense
  roughly test, defense.tank.ehp, 7266, 1
  roughly test, defense.navigation[1].sig, 280, 1
  roughly test, defense.navigation[1].speed, 1406, 1

  speed = stats.propulsion
  roughly test, speed.tank.ehp, 6319, 1
  roughly test, speed.navigation[1].speed, 2344, 1
  roughly test, speed.damage.turret.optimal, 45416, 1

  ss = stats.sharpshooter
  roughly test, ss.navigation[1].sig, 419, 1
  roughly test, ss.damage.turret.optimal, 75693, 1

Tinytest.add 'desc fleet drones', (test) ->
  arbitrator = """[Arbitrator, Med Mobile Armor]
  1600mm Rolled Tungsten Compact Plates
  Energized Adaptive Nano Membrane II
  Damage Control II
  Drone Damage Amplifier II
  Drone Damage Amplifier II

  50MN Cold-Gas Enduring Microwarpdrive
  Drone Navigation Computer II
  Drone Navigation Computer II
  Balmer Series Tracking Disruptor I

  Drone Link Augmentor II
  Light Missile Launcher II, Caldari Navy Inferno Light Missile
  Light Missile Launcher II, Caldari Navy Inferno Light Missile
  [Empty High slot]

  Medium Anti-Explosive Pump I
  Medium Trimark Armor Pump I
  Medium Trimark Armor Pump I


  Infiltrator II x5
  """

  fit = Desc.FromEFT arbitrator
  fleet = new DescFleet()
  fleet.setWingCommander Desc.getStandardLinks1()
  fleet.setSquadCommander Desc.getStandardLinks2()
  fleet.addFit fit

  stats = fit.getStats()

  roughly test, stats.tank.ehp, 41227, 1
  roughly test, stats.navigation[1].speed, 1651.3, 1e-1
  roughly test, stats.navigation[1].sig, 523, 1
  roughly test, stats.damage.drone.dps, 295, 1
  roughly test, stats.damage.drone.speed, 5654, 1

Tinytest.add 'desc turret', (test) ->
  fit = new DescFitting
  fit.setShip TYPE_ORACLE
  fit.addModuleWithCharge TYPE_MEGAPULSELASER, TYPE_SCORCHL
  fit.addModule TYPE_MEDIUMENERGYLOCUSII
  fit.addModule TYPE_MEDIUMENERGYLOCUSII

  damageStats = fit.getDamage()
  roughly test, damageStats.turret.optimal, 62119, 1
  roughly test, damageStats.turret.tracking, 0.0316, 1e-3
  test.equal damageStats.turret.signatureResolution, 400

Tinytest.add 'desc sentry', (test) ->
  fit = new DescFitting
  fit.setShip TYPE_ISHTAR
  fit.addDrone TYPE_CURATORII, 5

  damageStats = fit.getDamage()
  roughly test, damageStats.sentry.optimal, 65625, 1
  roughly test, damageStats.sentry.falloff, 12000, 1
  roughly test, damageStats.sentry.tracking, 0.03, 1e-2
  test.equal damageStats.sentry.signatureResolution, 400

Tinytest.add 'desc ewar', (test) ->
  fit = new DescFitting
  fit.setShip TYPE_SCIMITAR
  fit.addModule TYPE_STASISWEBII
  fit.addModule TYPE_PHASEDWEAPONTP
  fit.addModule InvTypes.lookupModule 'Warp Disruptor II'
  fit.addModule InvTypes.lookupModule 'Warp Scrambler II'
  fit.addModule InvTypes.lookupModule 'Remote Sensor Dampener II'

  ewarStats = fit.getEwar()
  test.equal ewarStats.webs[0].strength, 0.6
  test.equal ewarStats.webs[0].range, 10000
  test.equal ewarStats.tps[0].strength, 0.375
  test.equal ewarStats.tps[0].optimal, 45000
  test.equal ewarStats.points[0].range, 24000
  test.equal ewarStats.damps[0].strength, 0.19125
  test.equal ewarStats.scrams[0].range, 9000

Tinytest.add 'desc outgoing', (test) ->
  fit = new DescFitting
  fit.setShip TYPE_SCIMITAR
  fit.addModule TYPE_LARGEREMOTESHIELDBOOSTERII

  outgoingStats = fit.getOutgoing()
  roughly test, outgoingStats.shield.rr, 85, 1
  roughly test, outgoingStats.shield.optimal, 32200, 100
  roughly test, outgoingStats.shield.falloff, 48000, 100

Tinytest.add 'desc rr', (test) ->
  basi = """[Basilisk, MiG]
Reactor Control Unit II
Damage Control II

100MN Afterburner II
Large Shield Extender II
Adaptive Invulnerability Field II
Adaptive Invulnerability Field II
EM Ward Field II

Large 'Regard' Remote Capacitor Transmitter
Large S95a Scoped Remote Shield Booster
Large S95a Scoped Remote Shield Booster
Large S95a Scoped Remote Shield Booster
Pithum C-Type Medium Remote Shield Booster
Pithum C-Type Medium Remote Shield Booster

Medium Core Defense Field Extender II
Medium Ancillary Current Router II

Light Shield Maintenance Bot II x5
"""
  fit = Desc.FromEFT(basi);
  roughly test, fit.getStats().outgoing.shield.rr, 332, 1

Tinytest.add 'desc empty racks', (test) ->
  hyena = """[Hyena, Talwarfleet]

[Empty Low slot]
[Empty Low slot]
[Empty Low slot]

5MN Quad LiF Restrained Microwarpdrive
Medium Shield Extender II
Medium Shield Extender II
Federation Navy Stasis Webifier

[Empty High slot]
[Empty High slot]
[Empty High slot]

Small Core Defense Field Extender II
Small Core Defense Field Extender II"""

  parse = Desc.ParseEFT hyena
  test.equal parse.loadout.highs.length, 0
  test.equal parse.loadout.rigs.length, 2

Tinytest.add 'desc imps', (test) ->
  eos = """[Eos, Tremble]

  Internal Force Field Array I
  Armor Explosive Hardener II
  Drone Damage Amplifier II
  Drone Damage Amplifier II
  Nanofiber Internal Structure II
  Nanofiber Internal Structure II

  Gist X-Type 100MN Afterburner
  Command Processor I
  Small Electrochemical Capacitor Booster I, Navy Cap Booster 400
  Drone Navigation Computer I

  Armored Warfare Link - Damage Control II
  Skirmish Warfare Link - Interdiction Maneuvers II
  Skirmish Warfare Link - Rapid Deployment II
  Skirmish Warfare Link - Evasive Maneuvers II
  [Empty High slot]
  [Empty High slot]

  Medium Processor Overclocking Unit II
  Medium Ancillary Current Router I


  Gecko x2
  Hammerhead II x2
  Hobgoblin II x1
  Nanite Repair Paste x500


  Mid-grade Snake Alpha
  Mid-grade Snake Beta
  Mid-grade Snake Gamma
  Mid-grade Snake Delta
  Mid-grade Snake Epsilon
  Mid-grade Snake Omega
  Zor's Custom Navigation Hyper-Link"""

  parse = Desc.ParseEFT eos
  test.equal parse.loadout.implants.length, 7

  fit = Desc.FromParse parse
  stats = fit.getNavigation()
  roughly test, stats[1].speed, 1535, 1

Tinytest.add 'desc info links and targeting', (test) ->
  crucifier = """[Crucifier, 1MN Armor Big]

200mm Steel Plates II
Damage Control II
Energized Adaptive Nano Membrane II

1MN Monopropellant Enduring Afterburner
Sensor Booster II, Targeting Range Script
Tracking Disruptor II, Optimal Range Disruption Script
Tracking Disruptor II, Optimal Range Disruption Script

Drone Link Augmentor I
125mm Gatling AutoCannon I, EMP S

Small Tracking Diagnostic Subroutines I
Small Tracking Diagnostic Subroutines I
[Empty Rig slot]


Warrior I x9"""
  fit = Desc.FromEFT(crucifier);
  fleet = new DescFleet()
  fleet.setFleetCommander Desc.getInformationLinks()
  fleet.setWingCommander Desc.getStandardLinks1()
  fleet.setSquadCommander Desc.getStandardLinks2()
  fleet.addFit fit

  stats = fit.getStats()
  console.log stats.targeting
  roughly test, stats.targeting.range, 183000, 1000, "Targeting range should be 183000"
  roughly test, stats.targeting.strength, 25.1, 0.1
  roughly test, stats.targeting.scanres, 743, 1
  roughly test, stats.targeting.targets, 6, 1

  roughly test, stats.ewar.tds[0].optimal, 143640, 1
  roughly test, stats.ewar.tds[0].falloff, 36000, 1
  roughly test, stats.ewar.tds[0].strength, 0.786, 0.001 

Tinytest.add 'desc info links and ecm', (test) ->
  fit = new DescFitting
  fit.setShip InvTypes.lookupShip 'Griffin'
  fit.addModule InvTypes.lookupModule 'Enfeebling Phase Inversion ECM I'
  fit.addModule InvTypes.lookupModule 'Small Particle Dispersion Projector I'
  fit.addModule InvTypes.lookupModule 'Small Particle Dispersion Projector I'
  fit.addModule InvTypes.lookupModule 'Small Particle Dispersion Projector I'

  fleet = new DescFleet()
  fleet.setFleetCommander Desc.getInformationLinks()
  fleet.setWingCommander Desc.getStandardLinks1()
  fleet.setSquadCommander Desc.getStandardLinks2()
  fleet.addFit fit

  stats = fit.getEwar()
  roughly test, stats.ecm[0].optimal, 79579, 1
  roughly test, stats.ecm[0].falloff, 48114, 1
  roughly test, stats.ecm[0].strength, 10.5, 0.1 

Tinytest.add 'desc slot detection', (test) ->
  test.equal Desc.getSlotForModule(TYPE_LARGEREMOTESHIELDBOOSTERII), "Highslot", "Large Remote SB II is a highslot module"
  test.equal Desc.getSlotForModule(TYPE_10MNAFTERBURNERII), "Medslot", "10MN AB II is a med module"