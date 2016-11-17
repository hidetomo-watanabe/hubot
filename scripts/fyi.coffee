fs = require('fs')
fyis_path = '/home/vagrant/soinn-bot/hubot/data/fyis'

module.exports = (robot) ->

  robot.respond /fyi /i, (res) ->
    fyi = res.message.text.split(' ')[2]
    fyis = fs.readFileSync(fyis_path).toString().replace(/\n+$/g, '')
    if fyis != ''
      fs.appendFileSync(fyis_path, '\n')
    fs.appendFileSync(fyis_path, fyi)
    res.send 'I remember ' + fyi

  robot.respond /lsfyi$/i, (res) ->
    fyis = fs.readFileSync(fyis_path).toString().replace(/\n+$/g, '')
    if fyis == ''
      res.send 'NO FYI'
    else
      res.send '[fyi list]\n' + fyis
