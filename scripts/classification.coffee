child_process = require('child_process')
fig_path = '/tmp'

module.exports = (robot) ->

  getMsg = (result) ->
    msg = ''
    label = result.split(',')[0]
    accuracy = result.split(',')[1]
    if accuracy > 0.90
      msg += 'きっと'
    elif accuracy > 0.70
      msg += 'たぶん'
    elif accuracy > 0.50
      msg += 'もしかすると'
    elif accuracy > 0.30
      msg += 'なんとなくですが'
    else
      msg += 'ぶっちゃけわかんないですけど'
    msg += '、これは' + label + 'です。'
    msg

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
          msg = getMsg(stdout)
          res.send msg
          command_rm = 'rm ' + fig_path + '/gazou_' + unixtime
          child_process.exec command_rm, (err, stdout, stderr) ->
