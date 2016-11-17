module.exports = (robot) ->

  robot.hear /がんばるぞい/i, (res) ->
    unixtime = (new Date).getTime()
    res.send "https://raw.githubusercontent.com/hidetomo-watanabe/test/master/zoi.jpeg?"+unixtime

  robot.hear /おはようございます/i, (res) ->
    unixtime = (new Date).getTime()
    res.send "https://raw.githubusercontent.com/hidetomo-watanabe/test/master/ohayou.jpeg?"+unixtime

  robot.hear /おつかれさまでした/i, (res) ->
    unixtime = (new Date).getTime()
    res.send "https://raw.githubusercontent.com/hidetomo-watanabe/test/master/kaerou.jpg?"+unixtime
