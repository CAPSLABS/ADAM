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

require("src.mapLoader")
require("src.util")
anim8 = require "src.anim8"

debug = true

--1=menu, 2=game, 3=gameOver, 4=shop, 5=intro
Gamestates = {1,2,3,4,5}
gamestate = Gamestates[1]

------------ LOADING --------------

function love.load(startLvl)
    if gamestate == 1 then
        initMenu()
    elseif gamestate == 2 then 
        initGame(startLvl)
    --elseif gamestate == "gameOver" then
    --elseif gamestate == "shop" then
    end
end

function initMenu()
    menu = require("src.menu")
    env = require("src.environment")
    env.currentLvl = 3 --make sure to have last index as menu
    --env.currentLvl = #env.levels
    env:loadEnemies()
    env:loadMedia()
    _G.map = loadTiledMap("assets/tile/",env.levels[env.currentLvl].mapPath) 
end

function initGame(startLvl)
    env.enemies={}
    env.currentLvl = startLvl
    --create raw versions (kept for max. values)
    playerRaw = require("src.player")   
    env.player = shallowcopy(playerRaw)
    env:loadPlayer()
    _G.map = loadTiledMap("assets/tile/", env.levels[startLvl].mapPath) 
end

------------ UPDATING --------------

function love.update(dt)
    if gamestate == 1 then --MENU
        env:spawnEnemies(dt)
        env:updateEnemies(dt) --moves, animates&deletes enemies
        menu:checkLoadingInput()

    elseif gamestate == 2 then --GAME
        menu:checkRestartInput()
        env:checkPlayerActionInput(dt)

        env.player:updateCooldowns(dt) 
        env.player:updateModeDurations(dt) 
        env.player:updateBooms(dt) --moves,animates&deletes boomerangs
        env.player:updateFire(dt)
        --env.player:updateSelf(dt)

        env:spawnEnemies(dt)
        env:updateEnemies(dt) --moves, animates&deletes enemies
        env:handleCollisions()

    elseif gamestate == 3 then --GAME OVER
        menu:checkRestartInput()

    elseif gamestate == 4 then --SHOP

    elseif gamestate == 5 then --Intro Sequence
        env:updateExplosion(dt)
    end
end

------------ DRAWING --------------

function love.draw(dt) 
    if gamestate == 1 then --MENU
        _G.map:draw()
        env:drawEnemyStuff()
        menu:options()

    elseif gamestate == 2 then --GAME
        _G.map:draw()
        env:drawPlayerStuff()        
        env:drawEnemyStuff()
    
    elseif gamestate == 3 then --GAME OVER
        love.graphics.setColor(1,0,0,1)
        love.graphics.print("YOU DIED",100,100)
        love.graphics.print("Press ESC to quit.",100,150)
        love.graphics.print("Press R to restart.",100,175)
        love.graphics.print("Press F to pay respect.",100,200)

    elseif gamestate == 4 then --SHOP

    elseif gamestate == 5 then --Intro Sequence
        _G.map:draw()
        env:drawEnemyStuff()
        env:drawExplosionStuff()
    end

    if debug then
        drawPerformance()
    end
end