require("src.physix")
require("src.mapLoader")
require("src.util")
anim8 = require "src.anim8"

createGoblinTimerMax = 0.4
createGoblinTimer = createGoblinTimerMax  

--TODO reset with love.load.reset
--TODO seperate dead function with logic for further levels? 
-- ie, upon death dont reset, only load into current level but keep money/upgrade



function love.load(arg)
    --stats:
    playerRaw = require("src.player")   --kept raw for max. values, apply bought upgrades to playerRaw
    goblinRaw = require("src.goblin")
    env = require("src.environment")
    env.player = shallowcopy(playerRaw) --use this guy for actual calculations

    --pics:
    for key, imgPath in pairs(env.player.media) do
        env.player.media[key] = love.graphics.newImage(imgPath) 
    end
    goblinRaw.media.img = love.graphics.newImage(goblinRaw.media.img) --if we have more than 1 image, we can iterate over media instead
    --enemy.zombie.media.img = love.graphics.newImage(enemy.zombie.media.img)

    --spriteGrids:
    env.player.media.boomGrid= anim8.newGrid(48, 48, playerRaw.media.boom:getWidth(), playerRaw.media.boom:getHeight())
    goblinRaw.media.imgGrid = anim8.newGrid(65, 64, goblinRaw.media.img:getWidth(), goblinRaw.media.img:getHeight())

    --load map:
    _G.map = loadTiledMap("assets/tile/", "ebene1tilemap") 
    --TODO load map using env.lvl.path
    --TODO berserk animation, sonic animation, player walk animation
    --load specific levels with load arg? 
end


function love.update(dt)

    -- BOUNDARY
    if love.keyboard.isDown("escape") then
        love.event.push("quit") 
    elseif love.keyboard.isDown("r") and (env.player.alive==false) then
        love.event.quit("restart")
    -- MOVEMENT
    elseif love.keyboard.isDown("left") then
        env.player:moveLeft(dt)
    elseif love.keyboard.isDown("right") then
        env.player:moveRight(dt)
    end
    -- ATTACKS (do not elseif or one cannot activate skills simultaniously!)
    if love.keyboard.isDown("a") then
        env.player:throwBoom(dt) end
    if love.keyboard.isDown("s") and env.player.canBreath then
        env.player:spitFire(dt) end
    if love.keyboard.isDown("d") and env.player.canBerserk then 
        env.player:goBerserk(dt) end


    env.player:updateCooldowns(dt) 
    env.player:updateModeDurations(dt) 

    env.player:updateBooms(dt) --moves,animates&deletes boomerangs
    env.player:updateFire(dt)

    env:spawnEnemies(dt)
    env:updateEnemies(dt) --moves, animates&deletes enemies
    env:handleCollisions()
end

function love.draw(dt)
    _G.map:draw()
    env:drawPlayerStuff()
    env:drawEnemyStuff()
    
    love.graphics.print("FPS: "..tostring(love.timer.getFPS( )), 10, 10)
    local delta = love.timer.getAverageDelta()
    love.graphics.print(string.format("\t\t\tAverage DT: %.3f ms", 1000 * delta), 10, 10)
end
