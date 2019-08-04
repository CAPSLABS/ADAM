require("src.physix")
require("src.mapLoader")
require("src.util")
anim8 = require "src.anim8"

function love.load(arg)
    --create raw versions (kept for max. values)
    envRaw = require("src.environment")
    playerRaw = require("src.player")   
    envRaw.player = shallowcopy(playerRaw)
    envRaw:loadLevel() 
    
    --mutable environment with loaded player,enemies&animations:
    env = deepcopy(envRaw)
    _G.map = loadTiledMap("assets/tile/", "ebene1tilemap") 
    --TODO load map using env.lvl.path
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
