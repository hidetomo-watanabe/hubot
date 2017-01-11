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
    text = '今日明日の天気は悪いようです。'
    text += '\n'
    text += '\n'
    text += '今日: [' + getTelopToday(obj) + ']'
    text += '\n'
    text += '明日: [' + getTelopTommorow(obj) + ']'
    text += '\n'
    text += '\n'
    text += getDescription(obj)

  cronJob = new cronJob(
    cronTime: conf.cron
    onTick: ->
      envelope = room: conf.channel
      getWeatherObj (obj) ->
        if isBad(getTelopToday(obj), getTelopTommorow(obj))
          robot.send envelope, createText(obj)
    start: false
  )
  cronJob.start()
  
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
