Template.fleetcomp.helpers
  'unskilled': () ->
    if @skilled
      return ''
    else
      return 'danger'
  'WHTrips': (WHmass) ->
    times = (WHmass * 1000000) / @totalMass
    text = formatNumber(times,1)
    c = "info"
    if times >= 2
      c = 'success'
    else if times < 1
      c = 'danger'

    return '<td class="' + c + '" style="color: black;">' + text + '</td>'

Template.fleetcomp.events
  'submit .updateFleetcomp': (event) ->
    event.preventDefault()
    paste = event.target.paste.value

    Meteor.call 'updateFleetcomp', paste, @_id, (error, result) ->
      if error
        alert("error")
      else
        event.target.paste.value = ""
      
  