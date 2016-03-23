Template.fleetcompPaste.events
  'submit .newFleetcomp': (event) ->
    event.preventDefault()

    paste = event.target.paste.value

    Meteor.call 'newFleetcomp', paste, (error, result) ->
      if error
        alert("error")
      else
        Router.go('/f/' + result)
      
  