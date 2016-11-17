fs = require('fs')

module.exports = (robot) ->

  robot.respond /fyi /i, (res) ->
    fyi = res.message.text.split(' ')[2]
    fs.appendFileSync('/home/vagrant/soinn-bot/hubot/data/fyis', '\n' + fyi)
    res.send 'I remember ' + fyi
