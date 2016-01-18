Router.route('/bud', {where: 'server'}).post ->
    console.log @request.body
    answer = {}
    answer.text = "You what m8"
    @response.end(JSON.stringify(answer))
