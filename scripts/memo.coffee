fs = require('fs')
memos_path = './data/memos'

module.exports = (robot) ->

  cleanNewLine = (text) ->
    text
    .replace(/\n+$/g, '')
    .replace(/\n\n+/g, '\n')

  getMemos = () ->
    cleanNewLine(fs.readFileSync(memos_path).toString())

  removeMemo = (input_memos, id) ->
    output = ''
    for memo, i in input_memos.split('\n')
      if id == memo.split(':')[0]
        continue
      output += memo + '\n'
    cleanNewLine(output)

  robot.respond /memo /i, (res) ->
    input_memo = res.message.text.split(' ')[2]
    memos = getMemos()
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
    memos = getMemos()
    if memos == ''
      res.send 'NO MEMO'
    else
      res.send '[id: memo]\n' + memos

  robot.respond /rmmemo /i, (res) ->
    input_id = res.message.text.split(' ')[2]
    memos = getMemos()
    removed = removeMemo(memos, input_id)
    fs.writeFileSync(memos_path, removed)
    res.send 'I forget ' + input_id
