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
--main components:

-- external libs:
SUIT = require "src.suit"
ANIMATE = require "src.anim8"
--DEBUG = true
DEBUG = false

-- 1=menu, 2=game, 3=gameOver, 4=shop, 5=explosion, 6 = story, 7 = credits
GAMESTATE = 1
math.randomseed(os.time()) --to get new random numbers every boot, we use the time besed randomseed

------------ LOADING --------------
function love.load()
    require("src.mapLoader")
    require("src.util")
    require("src.world.world")
    WORLD = World:Create()
    CONTROLS = require("src.controls")
    MENU = require("src.menu")
    SHOP = require("src.shop")
    STORY = require("src.story")
    MUSIC = require("src.music")
    FADER = require("src.fader")
    CREDITS = require("src.credits")
    WORLD:loadEnemies()
    WORLD:loadMedia()
    WORLD:loadHud()
    WORLD:loadItems()
    WORLD:loadPlayer()
    MENU:load()
    SHOP:loadBacking()
    MUSIC:load()
    MUSIC:changeVolume(0.2)
    MUSIC.tracks.mainMenu:play()
    STORY:loadStory()
    LoadMap()
    if DEBUG then
        SetDebug()
    end
end

function InitGame(lvl, gamestate)
    --is used to reset WORLD variables to get into the next level / endless mode / story chapter
    WORLD.currentLvl = lvl
    GAMESTATE = gamestate
    WORLD:reset()

    if GAMESTATE == 6 then
        love.graphics.setFont(WORLD.media.readfont)
        STORY:processNextLine()
    end
end

------------ UPDATING --------------
function love.update(dt)
    if GAMESTATE == 1 then -- MENU
        MENU:fadeIn(dt)
        MENU:updateMenu(dt)
        WORLD:spawnEnemies(dt)
        WORLD:updateEnemies(dt) -- moves, animates&deletes enemies
        if WORLD.exploding then
            WORLD:updateExplosion(dt, 240, 850, WORLD.media["explosion"].maxRuntime)
        end
    elseif GAMESTATE == 2 then -- GAME
        CONTROLS:gamePlayerInput(dt)
        WORLD.player:update(dt)
        WORLD:updateHealth()
        WORLD:checkWinCondition(dt)
        WORLD:spawnEnemies(dt)
        WORLD:updateEnemies(dt)
        WORLD:handleCollisions()
        WORLD:updateExplosion(dt, WORLD.player.x + 32, WORLD.player.y + 32, WORLD.player.explosionMaxRuntime)
    elseif GAMESTATE == 3 then -- GAME OVER
        CONTROLS:gameOver()
        MENU:playAirhornSound()
    elseif GAMESTATE == 4 then -- SHOP
        SHOP:updateShop(dt)
    elseif GAMESTATE == 5 then -- Intro Sequence
        WORLD:spawnEnemies(dt)
        WORLD:updateEnemies(dt)
        WORLD:updateExplosion(dt, 240, 850, WORLD.media["explosion"].maxRuntime)
    elseif GAMESTATE == 6 then -- STORY
        STORY:update()
    elseif GAMESTATE == 7 then -- CREDITS
        CREDITS:update(dt)
    end
end

------------ DRAWING --------------

function love.draw()
    if GAMESTATE == 1 then -- MENU
        if MENU.gameOpenFadeIn then
            love.graphics.setColor(255, 255, 255, FADER.alpha)
        elseif WORLD.exploding then
            WORLD:drawScreenShake(-5, 5)
        end
        _G.map:draw()
        WORLD:drawEnemyStuff()
        if DEBUG then
            MENU:drawDebugMenu()
            WORLD:drawHitBoxes(240, 850)
        else
            MENU:drawMenu()
        end
        if WORLD.exploding then
            WORLD:drawExplosionStuff(240, 850)
        end
    elseif GAMESTATE == 2 then -- GAME
        _G.map:draw()
        WORLD:drawExplosionStuff(WORLD.player.x + 32, WORLD.player.y + 32)
        WORLD:drawEnemyStuff()
        WORLD:drawPlayerStuff()
        WORLD:drawItemStuff()
        WORLD:drawHud()
        WORLD:drawWinScreen()
        WORLD:drawFire()
        WORLD:drawLightning()
        if DEBUG then
            WORLD:drawHitBoxes(WORLD.player.x + 32, WORLD.player.y + 32)
        end
    elseif GAMESTATE == 3 then -- GAME OVER
        MENU:drawPaidRespect()
        love.graphics.setFont(WORLD.media.fantasyfont)
        love.graphics.setColor(1, 0, 0, 1)
        love.graphics.print("YOU DIED", 100, 100)
        love.graphics.print("Press ESC to quit.", 100, 150)
        love.graphics.print("Press R to restart.", 100, 175)
        love.graphics.print("Press F to pay respect.", 100, 200)
    elseif GAMESTATE == 4 then -- SHOP
        SHOP:drawShop()
    elseif GAMESTATE == 6 then -- STORY
        _G.map:draw()
        STORY:drawStory()
    elseif GAMESTATE == 7 then -- CREDITS
        CREDITS:draw()
    end
end

function love.keypressed(key)
    if GAMESTATE == 1 then
        -- When we passed the title screen
        CONTROLS:menu(key)
    elseif GAMESTATE == 2 then
        CONTROLS:game(key)
    elseif GAMESTATE == 4 then
        CONTROLS:shop(key)
    elseif GAMESTATE == 6 then
        CONTROLS:story(key)
    end
end

function love.keyreleased(key)
    if key == "escape" then
        love.event.quit()
    end
end
