cronJob = require('cron').CronJob
weather_channel = '#weather'
cron_conf = '00 00 11 * * 1-5'

module.exports = (robot) ->

  getWeatherObj = (cb) ->
    req = require('request')
    req {url: 'http://weather.livedoor.com/forecast/webservice/json/v1?city=140010'}, (err, res, body) ->
      cb JSON.parse(body)
      return
    return

  getTelop = (obj) ->
    obj.forecasts[0].telop

  getDescription = (obj) ->
    obj.description.text

  createText = (obj) ->
    text = '今日の天気は悪いようです。'
    text += '\n'
    text += '\n'
    text += '[' + getTelop(obj) + ']'
    text += '\n'
    text += getDescription(obj)

  cronJob = new cronJob(
    cronTime: cron_conf
    onTick: ->
      envelope = room: weather_channel
      getWeatherObj (obj) ->
        if getTelop(obj).match(/[雨雪雷]/)
          robot.send envelope, createText(obj)
    start: false
  )
  
  robot.hear /start_weather_cron/i, (res) ->
    cronJob.start()
    text = 'I start weather cron'
    text += '\n'
    text += 'cron conf: ' + cron_conf
    text += '\n'
    text += 'weather channel: ' + weather_channel
    res.send text
 
  robot.hear /stop_weather_cron/i, (res) ->
    cronJob.stop()
    text = 'I stop weather cron'
    res.send text
