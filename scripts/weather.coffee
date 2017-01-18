cronJob = require('cron').CronJob
conf =
  channel: '#weather'
  cron: '00 00 02 * * 1-5'
  bad_condition: /[雨雪雷]/

module.exports = (robot) ->

  getWeatherObj = (cb) ->
    req = require('request')
    req {url: 'http://weather.livedoor.com/forecast/webservice/json/v1?city=140010'}, (err, res, body) ->
      cb JSON.parse(body)
      return
    return

  getTelopToday = (obj) ->
    obj.forecasts[0].telop

  getTelopTommorow = (obj) ->
    obj.forecasts[1].telop

  isBad = (today, tommorow) ->
    if today.match(conf.bad_condition) or tommorow.match(conf.bad_condition)
      true
    else
      false

  getDescription = (obj) ->
    obj.description.text

  createText = (obj) ->
    text = ''
    text += '```'
    text += '\n'
    text += '今日: [' + getTelopToday(obj) + ']'
    text += '\n'
    text += '明日: [' + getTelopTommorow(obj) + ']'
    text += '\n'
    text += '\n'
    text += getDescription(obj)
    text += '\n'
    text += '```'

  robot.respond /天気/i, (res) ->
    getWeatherObj (obj) ->
      res.send createText(obj)

  cronJob = new cronJob(
    cronTime: conf.cron
    onTick: ->
      envelope = room: conf.channel
      getWeatherObj (obj) ->
        if isBad(getTelopToday(obj), getTelopTommorow(obj))
          robot.send envelope, '今日、明日の天気が悪いようです。'
          robot.send envelope, createText(obj)
    start: true
  )
  
  robot.respond /start_weather_cron/i, (res) ->
    cronJob.start()
    text = 'I start weather cron'
    text += '\n'
    text += 'weather channel: ' + conf.channel
    text += '\n'
    text += 'cron conf(UTC): ' + conf.cron
    res.send text
 
  robot.respond /stop_weather_cron/i, (res) ->
    cronJob.stop()
    text = 'I stop weather cron'
    res.send text
