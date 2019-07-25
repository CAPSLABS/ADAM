local anim8 = require 'anim8'


function love.load()
  image = love.graphics.newImage('assets/goblinswordMap.png')
  local g = anim8.newGrid(65, 64, image:getWidth(), image:getHeight())
  dedAnim = anim8.newAnimation(g('1-4',5, '4-1', 5), 0.04)
end

function love.update(dt)
  dedAnim:update(dt)
end

function love.draw()
  dedAnim:draw(image, 100, 200)
end