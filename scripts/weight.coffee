fs = require('fs')
cronJob = require('cron').CronJob
weights_path = './data/weights'
conf =
  channel: '#weight'
  time: '00 00 12 * * *'

module.exports = (robot) ->

  cronJobWeight = new cronJob(
    cronTime: conf.time
    onTick: ->
      envelope = room: conf.channel
      robot.send envelope, 'ママ、体重教えて'
    start: true
  )

  robot.hear /kg/i, (res) ->
    unixtime = (new Date).getTime()
    input_text = res.message.text
    fs.appendFileSync(weights_path, unixtime + ',' + input_text)

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
