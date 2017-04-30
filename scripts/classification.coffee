child_process = require('child_process')
fig_path = '/tmp'

module.exports = (robot) ->

  robot.respond /what |what's |これなに /i, (res) ->
    target = res.message.text.split(' ')[2]
    if not target.match(/http:\/\/|https:\/\//i)
        res.send 'Sorry, I can understand only URL...'
    else
      unixtime = (new Date).getTime()
      command_wget = 'wget -O ' + fig_path + '/gazou_' + unixtime + ' ' + target
      res.send 'Downloading...'
      child_process.exec command_wget, (err, stdout, stderr) ->
        command_classify = 'python -u bin/classify_by_vgg16.py ' + fig_path + '/gazou_' + unixtime
        res.send 'Thinking...'
        child_process.exec command_classify, (err, stdout, stderr) ->
          result = stdout
          res.send 'This is\n' + stdout
