image_url = 'https://raw.githubusercontent.com/hidetomo-watanabe/image_files/master/'

module.exports = (robot) ->

  robot.hear /がっきー|ガッキー|新垣結衣/i, (res) ->
    unixtime = (new Date).getTime()
    nums = [
      '1.png',
      '2.jpg',
      '3.png',
    # '4.png',
    # '5.jpeg',
      '6.gif',
    ]
    num = nums[Math.floor(Math.random()*nums.length)]
    res.send image_url + '/gakky/' + num + '?' +unixtime

  robot.hear /はしかん|かんなちゃん|橋本環奈/i, (res) ->
    unixtime = (new Date).getTime()
    nums = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15]
    num = nums[Math.floor(Math.random()*nums.length)]
    res.send image_url + '/kannna/' + num + '.jpg?' +unixtime

  robot.hear /飲むぞ/i, (res) ->
    unixtime = (new Date).getTime()
    nums = [
      '1.jpg',
      '2.jpg',
      '3.png',
      '4.jpg',
      '5.gif',
    ]
    num = nums[Math.floor(Math.random()*nums.length)]
    res.send image_url + '/nomuzo/' + num + '?' +unixtime

  robot.hear /今日も一日/i, (res) ->
    unixtime = (new Date).getTime()
    res.send image_url + 'zoi.jpeg?' +unixtime

  robot.hear /おはよう/i, (res) ->
    unixtime = (new Date).getTime()
    res.send image_url + 'ohayou.jpeg?' +unixtime

  robot.hear /おつかれ/i, (res) ->
    unixtime = (new Date).getTime()
    res.send image_url + 'kaerou.jpg?' +unixtime

  robot.hear /やすもう/i, (res) ->
    unixtime = (new Date).getTime()
    res.send image_url + 'yasumu.jpg?' +unixtime

  robot.hear /明日は土曜日/i, (res) ->
    unixtime = (new Date).getTime()
    res.send image_url + 'doyoubi.jpeg?' +unixtime

  robot.hear /スプーン曲げ/i, (res) ->
    unixtime = (new Date).getTime()
    res.send image_url + 'spoonmage.gif?' +unixtime
