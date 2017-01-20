image_url = 'https://raw.githubusercontent.com/hidetomo-watanabe/gakky/master/'
nums = [
  '1.png',
  '2.jpg',
  '3.png',
#  '4.png',
#  '5.jpeg',
  '6.gif',
]

module.exports = (robot) ->

  robot.hear /がっきー|ガッキー/i, (res) ->
    unixtime = (new Date).getTime()
    num = nums[Math.floor(Math.random()*nums.length)]
    res.send image_url + 'gakky' + num + '?' +unixtime