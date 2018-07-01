github_url = 'https://raw.githubusercontent.com/hidetomo-watanabe/image_files/master/'

module.exports = (robot) ->

  getGithubUrl = (target, cb) ->
    base_url = 'https://86889njpqa.execute-api.us-east-2.amazonaws.com/v1/'
    req = require('request')
    options =
      url: base_url + target
      json: true
   req options, (err, res, body) ->
     cb body.url
      return
    return

  getPhotozouUrl = (target, cb) ->
    base_url = 'https://897tb9gzii.execute-api.us-east-2.amazonaws.com/v1/'
    req = require('request')
    options =
      url: base_url + target
      json: true
   req options, (err, res, body) ->
     cb body.url
      return
    return

  robot.hear /がっきー|ガッキー|新垣結衣/i, (res) ->
    unixtime = (new Date).getTime()
    target = 'gakky'
    getGithubUrl target, (image_url) ->
      res.send image_url + '?' + unixtime

  robot.hear /はしかん|かんなちゃん|橋本環奈/i, (res) ->
    unixtime = (new Date).getTime()
    target = '%E6%A9%8B%E6%9C%AC%E7%92%B0%E5%A5%88'
    getPhotozouUrl target, (image_url) ->
      res.send image_url + '?' + unixtime

  robot.hear /飲むぞ/i, (res) ->
    unixtime = (new Date).getTime()
    target = 'nomuzo'
    getGithubUrl target, (image_url) ->
      res.send image_url + '?' + unixtime

  robot.hear /なんだって/i, (res) ->
    unixtime = (new Date).getTime()
    target = 'nandatte'
    getGithubUrl target, (image_url) ->
      res.send image_url + '?' + unixtime

  robot.hear /今日も一日/i, (res) ->
    unixtime = (new Date).getTime()
    res.send github_url + 'zoi.jpeg?' +unixtime

  robot.hear /おはよう/i, (res) ->
    unixtime = (new Date).getTime()
    res.send github_url + 'ohayou.jpeg?' +unixtime

  robot.hear /おつかれ/i, (res) ->
    unixtime = (new Date).getTime()
    res.send github_url + 'kaerou.jpg?' +unixtime

  robot.hear /やすもう/i, (res) ->
    unixtime = (new Date).getTime()
    res.send github_url + 'yasumu.jpg?' +unixtime

  robot.hear /明日は土曜日/i, (res) ->
    unixtime = (new Date).getTime()
    res.send github_url + 'doyoubi.jpeg?' +unixtime

  robot.hear /スプーン曲げ/i, (res) ->
    unixtime = (new Date).getTime()
    res.send github_url + 'spoonmage.gif?' +unixtime
