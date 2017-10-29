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
      url: 'http://weather.livedoor.com/forecast/webservice/json/v1?city=120010'
      json: true
    req options, (err, res, body) ->
      cb body
      return
    return

  getTelopToday = (obj) ->
    obj.forecasts[0].telop

  getTemperatureToday = (obj) ->
    output = obj.forecasts[0].temperature
    if ! output['min']
      output['min'] = {'celsius': '?'}
    if ! output['max']
      output['max'] = {'celsius': '?'}
    output

  getTelopTommorow = (obj) ->
    obj.forecasts[1].telop

  getTemperatureTommorow = (obj) ->
    output = obj.forecasts[1].temperature
    if ! output['min']
      output['min'] = {'celsius': '?'}
    if ! output['max']
      output['max'] = {'celsius': '?'}
    output

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
    text += '今日: '
    text += getTelopToday(obj)
    text += ' '
    text += getTemperatureToday(obj)['min']['celsius']
    text += '°C'
    text += '-'
    text += getTemperatureToday(obj)['max']['celsius']
    text += '°C'
    text += '\n'
    text += '明日: '
    text += getTelopTommorow(obj)
    text += ' '
    text += getTemperatureTommorow(obj)['min']['celsius']
    text += '°C'
    text += '-'
    text += getTemperatureTommorow(obj)['max']['celsius']
    text += '°C'
    text += '\n'
    text += '\n'
    text += getDescription(obj)
    text += '\n'
    text += '```'

  robot.respond /.*(weather|天気)/i, (res) ->
    getWeatherObj (obj) ->
      res.send createText(obj)

  cronJobToday = new cronJob(
    cronTime: conf.cronToday
    onTick: ->
      envelope = room: conf.channel
      getWeatherObj (obj) ->
        if isBad(getTelopToday(obj))
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
    text += 'cron conf(UTC): ' + conf.cronTomorrow
    res.send text
 
  robot.respond /stop_weather_cron/i, (res) ->
    cronJobTomorrow.stop()
    text = 'I stop weather cron'
    res.send text
