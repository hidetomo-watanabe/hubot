fig_path = '/tmp'

module.exports = (robot) ->

  robot.respond /what |what's |これなに /i, (res) ->
    target = res.message.text.split(' ')[2]
    if not target.match(/http:\/\/|https:\/\//i)
        res.send 'Sorry, I can understand only URL...'
