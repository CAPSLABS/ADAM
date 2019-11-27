--[[
--      main.lua
--
--      Logic for GAMESTATES is handled here.
--      The three main functions from the LÖVE framework are defined here:
--      load(), update() and draw().
-- 
--      @date 30.6.2019
--      @authors David L. Wenzel, Phillip Tse
--]]
require("src.mapLoader")
require("src.util")

SUIT = require "src.suit"
ANIMATE = require "src.anim8"

DEBUG = true
--DEBUG = false

--1=menu, 2=game, 3=gameOver, 4=shop
GAMESTATES = {1, 2, 3, 4}
GAMESTATE = GAMESTATES[1]
------------ LOADING --------------

function love.load()
    WORLD = require("src.world")
    MENU = require("src.menu")
    SHOP = require("src.shop")

    WORLD.currentLvl = 3
    --make sure this points to last level in WORLD, which is MENU
    _G.map = LoadTiledMap("assets/tile/", WORLD.levels[WORLD.currentLvl].mapPath)

    WORLD:loadEnemies()
    WORLD:loadMedia()
    WORLD:loadHud()

    PLAYERRAW = require("src.player")
    WORLD.player = Shallowcopy(PLAYERRAW)
    if DEBUG then
        WORLD.player.money = 1000
    end
    WORLD:loadPlayer()
    SHOP:loadBacking()
    MENU:loadMenuSounds()
end

function InitGame(lvl)
    GAMESTATE = 2
    WORLD.cityHealth = 100
    WORLD.runtime = 0
    WORLD.enemies = {}
    WORLD.currentLvl = lvl
    _G.map = LoadTiledMap("assets/tile/", WORLD.levels[lvl].mapPath)
end

------------ UPDATING --------------

function love.update(dt)
    if GAMESTATE == 1 then --MENU
        if WORLD.exploding then
            WORLD:updateExplosion(dt, 240, 850, WORLD.media["explosion"].maxRuntime)
        else
            MENU:checkLoadingInput()
        end
        WORLD:spawnEnemies(dt)
        WORLD:updateEnemies(dt) --moves, animates&deletes enemies
    elseif GAMESTATE == 2 then --GAME
        MENU:checkRestartInput()
        WORLD:checkPlayerActionInput(dt)

        WORLD.player:updateCooldowns(dt)
        WORLD.player:updateModeDurations(dt)
        WORLD.player:updateBooms(dt) --moves,animates&deletes boomerangs
        WORLD.player:updateFire(dt)
        WORLD:updateHealth()

        --WORLD.player:updateSelf(dt)

        --WORLD:updateHUD(dt)
        WORLD:spawnEnemies(dt)
        WORLD:updateEnemies(dt) --moves, animates&deletes enemies
        WORLD:handleCollisions()
        WORLD:updateExplosion(dt, WORLD.player.x + 32, WORLD.player.y + 32, WORLD.player.explosionMaxRuntime)
    elseif GAMESTATE == 3 then --GAME OVER
        MENU:checkGameOverInput()
        MENU:playAirhornSound()
    elseif GAMESTATE == 4 then --SHOP
        SHOP:updateShopShit(dt)
    elseif GAMESTATE == 5 then --Intro Sequence
        WORLD:spawnEnemies(dt)
        WORLD:updateEnemies(dt)
        WORLD:updateExplosion(dt, 240, 850, WORLD.media["explosion"].maxRuntime)
    end
end

------------ DRAWING --------------

function love.draw(dt)
    if GAMESTATE == 1 then --MENU
        if WORLD.exploding then
            WORLD:drawScreenShake(-5, 5)
        end
        _G.map:draw()
        if WORLD.exploding then
            WORLD:drawExplosionStuff(240, 850)
        end
        WORLD:drawEnemyStuff()
        MENU:options()
    elseif GAMESTATE == 2 then --GAME
        _G.map:draw()
        WORLD:drawExplosionStuff(WORLD.player.x + 32, WORLD.player.y + 32)
        WORLD:drawEnemyStuff()
        WORLD:drawPlayerStuff()
        WORLD:drawHud()
    elseif GAMESTATE == 3 then --GAME OVER
        MENU:drawPaidRespect(WORLD.media.surprise.img)
        love.graphics.setFont(WORLD.media.fantasyfont)
        love.graphics.setColor(1, 0, 0, 1)
        love.graphics.print("YOU DIED", 100, 100)
        love.graphics.print("Press ESC to quit.", 100, 150)
        love.graphics.print("Press R to restart.", 100, 175)
        love.graphics.print("Press F to pay respect.", 100, 200)
    elseif GAMESTATE == 4 then --SHOP
        SHOP:broUBroke()
        SUIT.draw()
        SHOP:drawShopShit()
    end

    if DEBUG then
        DrawPerformance()
        if (GAMESTATE == 1) then
            WORLD:drawHitBoxes(240, 850)
        else
            WORLD:drawHitBoxes(WORLD.player.x + 32, WORLD.player.y + 32)
        end
    end
end
