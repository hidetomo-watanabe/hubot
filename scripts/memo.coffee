fs = require('fs')
memos_path = './data/memos'

module.exports = (robot) ->

  robot.respond /memo /i, (res) ->
    input_memo = res.message.text.split(' ')[2]
    memos = fs.readFileSync(memos_path).toString().replace(/\n+$/g, '')
    if memos != ''
      fs.appendFileSync(memos_path, '\n')
    lines_num = (memos.match(/\n/g) || []).length
    id = lines_num + 1
    fs.appendFileSync(memos_path, id + ': ' + input_memo)
    res.send 'I remember ' + input_memo

  robot.respond /lsmemo$/i, (res) ->
    memos = fs.readFileSync(memos_path).toString().replace(/\n+$/g, '')
    if memos == ''
      res.send 'NO MEMO'
    else
      res.send '[id: memo]\n' + memos
