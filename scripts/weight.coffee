cronJob = require('cron').CronJob
conf =
  channel: '#weight'
  time: '00 00 12 * * *'

module.exports = (robot) ->

  cronJobWeight = new cronJob(
    cronTime: conf.time
    onTick: ->
      envelope = room: conf.channel
      robot.send envelope, 'ママ、体重測った？'
    start: true
  )

  robot.respond /start_weight_cron/i, (res) ->
    cronJobWeight.start()
    text = 'I start weight cron'
    text += '\n'
    text += 'weight channel: ' + conf.channel
    text += '\n'
    text += 'cron conf(UTC): ' + conf.time
    res.send text
 
  robot.respond /stop_weight_cron/i, (res) ->
    cronJobWeight.stop()
    text = 'I stop weight cron'
    res.send text
