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

debug = false

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
    world = require("src.world")
    world.currentLvl = 3 --make sure to have last index as menu
    --world.currentLvl = #world.levels
    world:loadEnemies()
    world:loadMedia()
    _G.map = loadTiledMap("assets/tile/",world.levels[world.currentLvl].mapPath) 
end

function initGame(startLvl)
    world.enemies={}
    world.currentLvl = startLvl
    --create raw versions (kept for max. values)
    playerRaw = require("src.player")   
    world.player = shallowcopy(playerRaw)
    world:loadPlayer()
    _G.map = loadTiledMap("assets/tile/", world.levels[startLvl].mapPath) 
end

------------ UPDATING --------------

function love.update(dt)
    if gamestate == 1 then --MENU
        world:spawnEnemies(dt)
        world:updateEnemies(dt) --moves, animates&deletes enemies
        menu:checkLoadingInput()

    elseif gamestate == 2 then --GAME
        menu:checkRestartInput()
        world:checkPlayerActionInput(dt)

        world.player:updateCooldowns(dt) 
        world.player:updateModeDurations(dt) 
        world.player:updateBooms(dt) --moves,animates&deletes boomerangs
        world.player:updateFire(dt)
        --world.player:updateSelf(dt)

        world:spawnEnemies(dt)
        world:updateEnemies(dt) --moves, animates&deletes enemies
        world:handleCollisions()

    elseif gamestate == 3 then --GAME OVER
        menu:checkRestartInput()

    elseif gamestate == 4 then --SHOP

    elseif gamestate == 5 then --Intro Sequence
        world:updateExplosion(dt)
    end
end

------------ DRAWING --------------

function love.draw(dt) 
    if gamestate == 1 then --MENU
        _G.map:draw()
        world:drawEnemyStuff()
        menu:options()

    elseif gamestate == 2 then --GAME
        _G.map:draw()
        world:drawPlayerStuff()        
        world:drawEnemyStuff()

        if debug then
            world:drawHitBoxes()
        end    
    elseif gamestate == 3 then --GAME OVER
        love.graphics.setColor(1,0,0,1)
        love.graphics.print("YOU DIED",100,100)
        love.graphics.print("Press ESC to quit.",100,150)
        love.graphics.print("Press R to restart.",100,175)
        love.graphics.print("Press F to pay respect.",100,200)

    elseif gamestate == 4 then --SHOP

    elseif gamestate == 5 then --Intro Sequence
        _G.map:draw()
        world:drawEnemyStuff()
        world:drawExplosionStuff()
    end

    if debug then
        drawPerformance()
    end
end