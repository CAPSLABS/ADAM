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

suit = require "src.suit"
anim8 = require "src.anim8"

debug = true

--1=menu, 2=game, 3=gameOver, 4=shop
Gamestates = {1,2,3,4}
gamestate = Gamestates[1]

------------ LOADING --------------

function love.load()
    world = require("src.world")
    menu = require("src.menu")
    shop = require("src.shop")

    world.currentLvl = 3 
    --make sure this points to last level in world, which is menu
    _G.map = loadTiledMap("assets/tile/",world.levels[world.currentLvl].mapPath) 

    world:loadEnemies()
    world:loadMedia()
    world:loadHud()
    
    playerRaw = require("src.player")   
    world.player = shallowcopy(playerRaw)
    world:loadPlayer()
    
    shop:loadBacking()

    menu:loadMenuSounds()
end

function initGame(lvl)
    gamestate = 2
    world.cityHealth=100
    world.runtime = 0
    world.enemies={}
    world.currentLvl = lvl
    _G.map = loadTiledMap("assets/tile/", world.levels[lvl].mapPath) 
end

------------ UPDATING --------------

function love.update(dt)
    if gamestate == 1 then --MENU
        if world.exploding then
            world:updateExplosion(dt,240,850,world.media["explosion"].maxRuntime)
        else
            menu:checkLoadingInput(key)
        end
        world:spawnEnemies(dt)
        world:updateEnemies(dt) --moves, animates&deletes enemies
    elseif gamestate == 2 then --GAME
        menu:checkRestartInput()
        world:checkPlayerActionInput(dt)

        world.player:updateCooldowns(dt) 
        world.player:updateModeDurations(dt) 
        world.player:updateBooms(dt) --moves,animates&deletes boomerangs
        world.player:updateFire(dt)
        world:updateExplosion(dt, world.player.x, world.player.x, world.player.explosionMaxRuntime)
        world:updateHealth(wee)

        --world.player:updateSelf(dt)

        --world:updateHUD(dt)
        world:spawnEnemies(dt)
        world:updateEnemies(dt) --moves, animates&deletes enemies
        world:handleCollisions()

    elseif gamestate == 3 then --GAME OVER
        menu:checkGameOverInput()
        menu:playAirhornSound()

    elseif gamestate == 4 then --SHOP
        shop:updateShopShit()

    elseif gamestate == 5 then --Intro Sequence
        world:spawnEnemies(dt)
        world:updateEnemies(dt)
        world:updateExplosion(dt,240,850,world.media["explosion"].maxRuntime)
    end
end

------------ DRAWING --------------

function love.draw(dt) 
    if gamestate == 1 then --MENU
        if world.exploding then     
            world:drawExplosionScreenShake()
        end
        _G.map:draw()
        if world.exploding then     
            world:drawExplosionStuff(dt,240,850)
        end
        world:drawEnemyStuff()
        menu:options()

    elseif gamestate == 2 then --GAME
        _G.map:draw()
        world:drawExplosionStuff(dt,world.player.x+32,world.player.y+32)
        world:drawPlayerStuff()        
        world:drawEnemyStuff()
        world:drawHud()

    elseif gamestate == 3 then --GAME OVER
        menu:drawPaidRespect(world.media.surprise.img)
        love.graphics.setFont(world.media.fantasyfont)
        love.graphics.setColor(1,0,0,1)
        love.graphics.print("YOU DIED",100,100)
        love.graphics.print("Press ESC to quit.",100,150)
        love.graphics.print("Press R to restart.",100,175)
        love.graphics.print("Press F to pay respect.",100,200)

    elseif gamestate == 4 then --SHOP
        suit.draw()
        shop:drawShopShit()
    end

    if debug then
        drawPerformance()
        if(gamestate == 1) then
            world:drawHitBoxes(240,850)
        else
            world:drawHitBoxes(world.player.x+32,world.player.y+32)
        end
    end
end
