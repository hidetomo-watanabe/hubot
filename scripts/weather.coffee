cronJob = require('cron').CronJob
conf =
  channel: '#weather'
  cronTomorrow: '00 00 02 * * 1-5'
  cronToday: '00 00 23 * * 0-4'
  badCondition: /[雨雪雷]/

module.exports = (robot) ->

  getWeatherObj = (cb) ->
    req = require('request')
    options =
      url: 'http://weather.livedoor.com/forecast/webservice/json/v1?city=140010'
      json: true
    req options, (err, res, body) ->
      cb body
      return
    return

  getTelopToday = (obj) ->
    obj.forecasts[0].telop

  getTelopTommorow = (obj) ->
    obj.forecasts[1].telop

  isBad = (telop) ->
    if telop.match(conf.badCondition)
      true
    else
      false

  getDescription = (obj) ->
    obj.description.text

  createText = (obj) ->
    text = ''
    text += '```'
    text += '\n'
    text += '今日: ' + getTelopToday(obj)
    text += '\n'
    text += '明日: ' + getTelopTommorow(obj)
    text += '\n'
    text += '\n'
    text += getDescription(obj)
    text += '\n'
    text += '```'

  robot.respond /天気/i, (res) ->
    getWeatherObj (obj) ->
      res.send createText(obj)

  cronJobToday = new cronJob(
    cronTime: conf.cronToday
    onTick: ->
      envelope = room: conf.channel
      getWeatherObj (obj) ->
        if isBad(getTelopToday(obj))
          robot.send envelope, '(昨日も言ってたらごめんなさい。)'
          robot.send envelope, '今日は天気が悪いようです。'
          robot.send envelope, createText(obj)
    start: true
  )

  cronJobTomorrow = new cronJob(
    cronTime: conf.cronTomorrow
    onTick: ->
      envelope = room: conf.channel
      getWeatherObj (obj) ->
        if isBad(getTelopTommorow(obj))
          robot.send envelope, '明日は天気が悪いようです。'
          robot.send envelope, createText(obj)
    start: true
  )
  
  robot.respond /start_weather_cron/i, (res) ->
    cronJobTomorrow.start()
    text = 'I start weather cron'
    text += '\n'
    text += 'weather channel: ' + conf.channel
    text += '\n'
    text += 'cron conf(UTC): ' + conf.cron
    res.send text
 
  robot.respond /stop_weather_cron/i, (res) ->
    cronJobTomorrow.stop()
    text = 'I stop weather cron'
    res.send text
