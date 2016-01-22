Template.srprequests.helpers
  openRequests: ->
    SRPRequests.find status: 'Open'
  archivedRequests: ->
    SRPRequests.find status: $not: 'Open'
  srpStatusLabel: ->
    if @status == 'Accepted'
      return 'label-success'
    else
      return 'label-danger'
Template.srprow.helpers
  srpTypeLabel: ->
    if @type == 'CTA'
      return 'label-danger'
    else if @type == 'Stratop'
      return 'label-warning'
    else if @type == 'Homedef'
      return 'label-success'
    else if @type == 'Roaming'
      return 'label-info'
    return 'label-default'

Template.srprequests.events
  'click .reset': (event) ->
    SRPRequests.update(@._id, $set: status: "Open")
  'click .accept': (event) ->
    SRPRequests.update(@._id, $set: status: "Accepted")
  'click .deny': (event) ->
    SRPRequests.update(@._id, $set: status: "Denied")