Template.damageStats.helpers
  'damageTypes': ->
    for key, value of this when key != 'total'
      if key == 'turret'
        type = 'Turret'
      else if key == 'missile'
        type = 'Missile'
      else if key == 'sentry'
        type = 'Sentry'
      else if key == 'drone'
        type = 'Drone'
      else if key == 'smartbomb'
        type = 'Smartbomb'

      value.type = 'damageStats' + type
      value