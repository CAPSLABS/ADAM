--[[
--      main.lua
--
--      Logic for Gamestates is handled here.
--      The three main functions from the LÖVE framework are defined here:
--      load(), update() and draw().
-- 
--      @date 30.6.2019
--      @authors David L. Wenzel, Phillip Tse
--]]

require("src.physix")
require("src.mapLoader")
require("src.util")
require("src.menu")
anim8 = require "src.anim8"

Gamestates = {"menu","gameStart","gameOver"}
gamestate = Gamestates[1]

------------ LOADING --------------

function initGame(levelID)
    --create raw versions (kept for max. values)
    envRaw = require("src.environment")
    playerRaw = require("src.player")   
    envRaw.player = shallowcopy(playerRaw)
    envRaw:loadLevel() 
    
    --mutable environment with loaded player,enemies&animations:
    env = deepcopy(envRaw)
    _G.map = loadTiledMap("assets/tile/", env.levels[levelID].mapPath) 
end

function love.load(arg)
    if gamestate == "menu" then
        local menu = Menu:init()
    elseif gamestate == "gameStart" then
        initGame(arg)
    --elseif gamestate == "gameOver" then
    end
end

------------ UPDATING --------------

function reset()
    boomerangs = {}
    goblins = {}

    -- reset timers
    canShootTimer = canShootTimerMax
    createEnemyTimer = createEnemyTimerMax
    canBerserkTimer = canBerserkTimerMax
    canBreathTimer = canBreathTimerMax
    berserkMode = false
    berserkDuration = berserkDurationMax
    canBerserkTimer = canBerserkTimerMax

    -- reset position
    player.x = 50
    player.y = 710

    -- reset our game state
    money = 0
    isAlive = true
end

function love.update(dt)
    if gamestate == "menu" then
        -- TESTING FOR Menu
        if love.keyboard.isDown("c") then
            gamestate = Gamestates[2]
            love.load(1)
        elseif love.keyboard.isDown("1") then
            gamestate = Gamestates[2]
            love.load(1)
        elseif love.keyboard.isDown("2") then
            gamestate = Gamestates[2]
            love.load(2)
        end


    elseif gamestate == "gameStart" then
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

        if env.player.alive == false then
            gamestate = Gamestates[3]
            love.load()
        end

    elseif gamestate == "gameOver" then
         -- BOUNDARY
        if love.keyboard.isDown("escape") then
            love.event.push("quit") 
        elseif love.keyboard.isDown("r") and (env.player.alive==false) then
            love.event.quit("restart")
        end
    end
    
end

------------ DRAWING --------------

function love.draw(dt)
    if gamestate == "menu" then
        local menu = Menu:draw()
    elseif gamestate == "gameStart" then
        _G.map:draw()
        env:drawPlayerStuff()
        env:drawEnemyStuff()
        --love.graphics.print("FPS: "..tostring(love.timer.getFPS( )), 10, 10)
        --local delta = love.timer.getAverageDelta()
        --love.graphics.print(string.format("\t\t\tAverage DT: %.3f ms", 1000 * delta), 10, 10)
    elseif gamestate == "gameOver" then
        love.graphics.setColor(1,0,0,1)
        love.graphics.print("YOU DIED",100,100)
        love.graphics.print("Press ESC to quit.",100,150)
        love.graphics.print("Press R to restart.",100,175)
        love.graphics.print("Press F to pay respect.",100,200)
    end
end
