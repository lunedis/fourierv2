Template.ewar.helpers
  'percent': (number) ->
    return (number * 100).toFixed(0) + "%"

Template.ewar.events
  'click .plusEwar': (event) ->
    update = {$push: {}}
    target = 'data.' + event.target.getAttribute 'data-target'
    update.$push[target] = event.target.getAttribute 'data-value'
    Panels.update @_id, update

  'click .minusEwar': (event) ->
    update = {$pop: {}}
    target = 'data.' + event.target.getAttribute 'data-target'
    update.$pop[target] = 1
    Panels.update @_id, update  