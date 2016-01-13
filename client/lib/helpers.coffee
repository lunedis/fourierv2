@formatNumber = (number, decimals = 0) ->
  number.toFixed(decimals).replace /\d(?=(\d{3})+$)/g, '$&,'

@groupByRole = (fittings) ->
  grouped = _.groupBy fittings, 'role'
  result = []
  _.each grouped, (value, key, list) ->
    result.push {'role': key, 'fits': value}
  return _.sortBy result, 'role'

UI.registerHelper 'formatNumber', (context, options) ->
  if context
    decimals = 0
    if typeof options == 'number'
      decimals = options
    
    formatNumber(context, decimals)

UI.registerHelper 'noDecimals', (context, options) ->
  if context
    context.toFixed(0)

UI.registerHelper 'formatNumberK', (context, options) ->
  if context
    decimals = 0
    if typeof options == 'number'
      decimals = options
    
    (context / 1000).toFixed(decimals)

UI.registerHelper 'log', (context, options) ->
  console.log @

UI.registerHelper 'greaterZero', (context, options) ->
  context > 0

UI.registerHelper 'percent', (context, options) ->
  check context, Number
  return (context * 100).toFixed(0) + "%"