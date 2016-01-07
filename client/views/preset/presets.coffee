Template.presets.events
  'click .targetPresetDelete': (event) ->
    if confirm 'Are you sure?'
      TargetPresets.remove @_id
  'click .attackerPresetDelete': (event) ->
    if confirm 'Are you sure?'
      AttackerPresets.remove @_id

Template.addTargetPreset.helpers
  TargetPresetsEFTSchema: ->
    return TargetPresetsEFTSchema
Template.editTargetPreset.helpers
  TargetPresetsEFTSchema: ->
    return TargetPresetsEFTSchema

Template.addAttackerPreset.helpers
  AttackerPresetsEFTSchema: ->
    return AttackerPresetsEFTSchema
Template.editAttackerPreset.helpers
  AttackerPresetsEFTSchema: ->
    return AttackerPresetsEFTSchema

SuccessRedirectPresets = 
  onSuccess: (operation, fit) ->
    Router.go 'presets'

AutoForm.hooks
  AddTargetPresetForm: SuccessRedirectPresets
  AddTargetPresetEFTForm: SuccessRedirectPresets
  AddAttackerPresetForm: SuccessRedirectPresets
  EditTargetPresetForm: SuccessRedirectPresets
  EditTargetPresetEFTForm: SuccessRedirectPresets
  EditAttackerPresetEFTForm: SuccessRedirectPresets