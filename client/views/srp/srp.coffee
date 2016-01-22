Template.srp.helpers
  requests: ->
    SRPRequests.find(creator: Meteor.user().username)
  SRPFormSchema: ->
    SRPFormSchema
  srpStatusLabel: ->
    if @status == 'Accepted'
      return 'label-success'
    else
      return 'label-danger'
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