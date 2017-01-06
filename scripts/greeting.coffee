image_url = 'https://raw.githubusercontent.com/hidetomo-watanabe/test/master/'

module.exports = (robot) ->

  robot.hear /今日も一日/i, (res) ->
    unixtime = (new Date).getTime()
    res.send image_url + 'zoi.jpeg?' +unixtime

  robot.hear /おはよう/i, (res) ->
    unixtime = (new Date).getTime()
    res.send image_url + 'ohayou.jpeg?' +unixtime

  robot.hear /おつかれ/i, (res) ->
    unixtime = (new Date).getTime()
    res.send image_url + 'kaerou.jpg?' +unixtime

  robot.hear /やすもう/i, (res) ->
    unixtime = (new Date).getTime()
    res.send image_url + 'yasumu.jpg?' +unixtime
