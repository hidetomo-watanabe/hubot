image_url = 'https://raw.githubusercontent.com/hidetomo-watanabe/gakky/master/'
nums = [1, 2, 3, 4, 5]

module.exports = (robot) ->

  robot.respond /がっきー/i, (res) ->
    unixtime = (new Date).getTime()
    num = nums[Math.floor(Math.random()*nums.length)]
    res.send image_url + 'gakky' + num + '.png?' +unixtime
