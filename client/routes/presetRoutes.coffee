Router.route '/presets',
  name: 'presets'
  action: ->
    @render 'presets',
      data: ->
        if !@ready
          return
        {targetPresets: TargetPresets.find {} 
        attackerPresets: AttackerPresets.find {}}
  waitOn: ->
    [Meteor.subscribe('targetpresets'), Meteor.subscribe('attackerpresets')]

Router.route '/presets/addTarget',
  name: 'addTargetPreset'
  action: ->
    @render 'addTargetPreset'

Router.route '/presets/addAttacker',
  name: 'AddAttackerPreset'
  action: ->
    @render 'addAttackerPreset'

Router.route 'presets/editTarget/:_id',
  name: 'EditTargetPreset'
  action: ->
    @render 'editTargetPreset',
      data: ->
        if !@ready
          return
        TargetPresets.findOne(@params._id)
  waitOn: ->
    Meteor.subscribe 'targetpresets'

Router.route 'presets/editAttacker/:_id',
  name: 'EditAttackerPreset'
  action: ->
    @render 'editAttackerPreset',
      data: ->
        if !@ready
          return
        AttackerPresets.findOne(@params._id)
  waitOn: ->
    Meteor.subscribe 'attackerpresets'