Template.doctrines.helpers
  categories: ->
    doctrines = Doctrines.find({},{sort: slug: 1}).fetch()
    grouped = _.groupBy doctrines, 'category'
    result = []
    _.each grouped, (value, key, list) ->
      result.push {"category": key, "doctrines": value}

    return _.sortBy result, 'category'
