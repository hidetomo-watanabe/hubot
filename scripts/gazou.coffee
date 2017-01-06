module.exports = (robot) ->

  robot.hear /今日も一日/i, (res) ->
    unixtime = (new Date).getTime()
    res.send "https://raw.githubusercontent.com/hidetomo-watanabe/test/master/zoi.jpeg?"+unixtime

  robot.hear /おはよう/i, (res) ->
    unixtime = (new Date).getTime()
    res.send "https://raw.githubusercontent.com/hidetomo-watanabe/test/master/ohayou.jpeg?"+unixtime

  robot.hear /おつかれ/i, (res) ->
    unixtime = (new Date).getTime()
    res.send "https://raw.githubusercontent.com/hidetomo-watanabe/test/master/kaerou.jpg?"+unixtime

  robot.hear /やすもう/i, (res) ->
    unixtime = (new Date).getTime()
    res.send "https://raw.githubusercontent.com/hidetomo-watanabe/test/master/yasumu.jpg?"+unixtime
