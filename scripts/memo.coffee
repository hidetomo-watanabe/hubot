fs = require('fs')
memos_path = './data/memos'

module.exports = (robot) ->

  cleanNewLine = (text) ->
    text
    .replace(/\n+$/g, '')
    .replace(/\n\n+/g, '\n')

  removeMemo = (input_memos, id) ->
    output = ''
    for i, memo in input_memos.split('\n')
      if id == memo.split(':')[0]
        continue
      output += memo
    output

  robot.respond /memo /i, (res) ->
    input_memo = res.message.text.split(' ')[2]
    memos = cleanNewLine(fs.readFileSync(memos_path).toString())
    if memos == ''
      new_id = 1
    else
      tmp = memos.split('\n')
      last_id = Number(tmp[tmp.length - 1].split(':')[0])
      new_id = last_id + 1
      fs.appendFileSync(memos_path, '\n')
    fs.appendFileSync(memos_path, new_id + ': ' + input_memo)
    res.send 'I remember ' + input_memo

  robot.respond /lsmemo$/i, (res) ->
    memos = cleanNewLine(fs.readFileSync(memos_path).toString())
    if memos == ''
      res.send 'NO MEMO'
    else
      res.send '[id: memo]\n' + memos

  robot.respond /rmmemo /i, (res) ->
    input_id = res.message.text.split(' ')[2]
    memos = cleanNewLine(fs.readFileSync(memos_path).toString())
    removed = removeMemo(memos, input_id)
    fs.writeFileSync(memos_path, removed)
    res.send 'I remove ' + input_id
