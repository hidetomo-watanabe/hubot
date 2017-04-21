fs = require('fs')
memos_path = './data/memos'

module.exports = (robot) ->

  cleanNewLine = (text) ->
    text
    .replace(/\n+$/g, '')
    .replace(/\n\n+/g, '\n')

  robot.respond /memo /i, (res) ->
    input_memo = res.message.text.split(' ')[2]
    memos = cleanNewLine(fs.readFileSync(memos_path).toString())
    if memos == ''
      id = 1
    else
      tmp = memos.split('\n')
      last_id = Number(tmp[tmp.length - 1].split(':')[0])
      id = last_id + 1
      fs.appendFileSync(memos_path, '\n')
    fs.appendFileSync(memos_path, id + ': ' + input_memo)
    res.send 'I remember ' + input_memo

  robot.respond /lsmemo$/i, (res) ->
    memos = cleanNewLine(fs.readFileSync(memos_path).toString())
    if memos == ''
      res.send 'NO MEMO'
    else
      res.send '[id: memo]\n' + memos
