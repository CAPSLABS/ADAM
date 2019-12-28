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
require("src.story")

SUIT = require "src.suit"
ANIMATE = require "src.anim8"
--DEBUG = true
DEBUG = false

--1=menu, 2=game, 3=gameOver, 4=shop, 5=explosion, 6 = story
GAMESTATES = {1, 2, 3, 4, 5}
GAMESTATE = GAMESTATES[1]
------------ LOADING --------------

function love.load()
    WORLD = require("src.world")
    MENU = require("src.menu")
    SHOP = require("src.shop")
    STORY = require("src.story")
    MUSIC = require("src.music")
    WORLD.currentLvl = 3 --this should point to menu (3)
    --make sure this points to last level in WORLD, which is MENU
    WORLD:loadEnemies()
    WORLD:loadMedia()
    WORLD:loadHud()
    WORLD:loadItems()
    LoadMap()

    PLAYERRAW = require("src.player")
    WORLD.player = Shallowcopy(PLAYERRAW)
    if DEBUG then
        WORLD.player.money = 1000
    end
    WORLD:loadPlayer()
    SHOP:loadBacking()
    MUSIC:load()
    MUSIC:changeVolume(0.2)
    MUSIC.tracks.mainMenu:play()
end

function LoadMap()
    _G.map = LoadTiledMap("assets/tile/", WORLD.map)
end

function InitGame(lvl, gamestate)
    WORLD.cityHealth = 100
    WORLD.runtime = 0
    WORLD.enemies = {}
    WORLD.drops = {}
    WORLD.wonLevel = false
    WORLD.currentLvl = lvl
    WORLD.player.hearts = WORLD.player.maxHearts
    GAMESTATE = gamestate
    if GAMESTATE == 6 then
        love.graphics.setFont(WORLD.media.fantasyfont)
        if STORY.loaded == false then
            STORY:loadStory()
        else
            STORY:processNextLine()
        end
    end
end

------------ UPDATING --------------

function love.update(dt)
    if GAMESTATE == 1 then --MENU
        if WORLD.exploding then
            WORLD:updateExplosion(dt, 240, 850, WORLD.media["explosion"].maxRuntime)
        end
        if DEBUG then
            MENU:checkDebugInput()
        end
        MENU:updateMenu()
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
        WORLD:checkWinCondition(dt)
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
    elseif GAMESTATE == 6 then --STORY
        STORY:updateStory(dt)
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
        if DEBUG then
            MENU:drawDebugMenu()
        else
            MENU:drawMenu()
        end
    elseif GAMESTATE == 2 then --GAME
        _G.map:draw()
        WORLD:drawExplosionStuff(WORLD.player.x + 32, WORLD.player.y + 32)
        WORLD:drawEnemyStuff()
        WORLD:drawPlayerStuff()
        WORLD:drawItemStuff()
        WORLD:drawHud()
        WORLD:drawWinScreen()
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
    elseif GAMESTATE == 6 then
        _G.map:draw()
        STORY:drawStory()
    end

    if DEBUG then
        -- DrawPerformance()
        if (GAMESTATE == 1) then
            WORLD:drawHitBoxes(240, 850)
        else
            WORLD:drawHitBoxes(WORLD.player.x + 32, WORLD.player.y + 32)
        end
    end
end

function love.keyreleased(key)
    if key == "escape" then
        love.event.quit()
    end
    if GAMESTATE == 6 then
        STORY:keyUpdate(key)
    end
end
