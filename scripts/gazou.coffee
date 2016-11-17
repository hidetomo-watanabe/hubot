module.exports = (robot) ->

  robot.hear /がんばるぞい/i, (res) ->
    unixtime = (new Date).getTime()
    res.emote "https://raw.githubusercontent.com/hidetomo-watanabe/test/master/zoi.jpeg?"+unixtime
