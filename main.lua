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
DEBUG = true
DEBUG = false

--1=menu, 2=game, 3=gameOver, 4=shop, 5=explosion, 6 = story
GAMESTATES = {1, 2, 3, 4, 5}
GAMESTATE = GAMESTATES[1]
math.randomseed(os.time())

------------ LOADING --------------

function love.load()
    WORLD = require("src.world")
    MENU = require("src.menu")
    SHOP = require("src.shop")
    STORY = require("src.story")
    MUSIC = require("src.music")
    FADER = require("src.fader")
    CREDITS = require("src.credits")
    WORLD.currentLvl = #WORLD.levels --this should point to menu
    --make sure this points to last level in WORLD, which is MENU
    WORLD:loadMenu()
    WORLD:loadEnemies()
    WORLD:loadMedia()
    WORLD:loadHud()
    WORLD:loadItems()
    LoadMap()

    PLAYERRAW = require("src.player")
    WORLD.player = Shallowcopy(PLAYERRAW)
    if DEBUG then
        WORLD.player.money = 10000
    end
    WORLD:loadPlayer()
    SHOP:loadBacking()
    MUSIC:load()
    MUSIC:changeVolume(0.1)
    MUSIC.tracks.mainMenu:play()
end

function LoadMap()
    _G.map = LoadTiledMap("assets/tile/", WORLD.map)
end

function InitGame(lvl, gamestate)
    if not WORLD.endlessmode then
        WORLD.cityHealth = 100
    end
    WORLD.runtime = 0
    WORLD.enemies = {}
    WORLD.drops = {}
    WORLD.wonLevel = false
    WORLD.spawn = true
    WORLD.currentLvl = lvl
    WORLD.player.hearts = WORLD.player.maxHearts
    GAMESTATE = gamestate

    -- resets buyable city hp in endlessmode
    SHOP.clicked = false

    if GAMESTATE == 6 then
        love.graphics.setFont(WORLD.media.readfont)
        if STORY.loaded == false then
            STORY:loadStory()
        else
            STORY:processNextLine()
        end
    end
    if GAMESTATE == 2 then
        WORLD.player.startOfLvlMoney = WORLD.player.money
    end
end

------------ UPDATING --------------

function love.update(dt)
    if GAMESTATE == 1 then --MENU
        if MENU.gameOpenFadeIn then
            local done = FADER:fadeIn(dt)
            if done then
                MENU.gameOpenFadeIn = false
            end
        end
        if WORLD.exploding then
            WORLD:updateExplosion(dt, 240, 850, WORLD.media["explosion"].maxRuntime)
        end
        if DEBUG then
            MENU:checkDebugInput()
        end
        MENU:updateMenu(dt)
        WORLD:spawnEnemies(dt)
        WORLD:updateEnemies(dt) --moves, animates&deletes enemies

        if WORLD.credits then
            CREDITS:update(dt)
        end
    elseif GAMESTATE == 2 then --GAME
        WORLD:checkPlayerActionInput(dt)
        WORLD.player:update(dt)
        WORLD:updateHealth()
        WORLD:checkWinCondition(dt)
        WORLD:spawnEnemies(dt)
        WORLD:updateEnemies(dt) --moves, an
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
    elseif GAMESTATE == 7 then --CREDITS
        CREDITS:update(dt)
    end
end

------------ DRAWING --------------

function love.draw()
    if GAMESTATE == 1 then --MENU
        _G.map:draw()
        WORLD:drawEnemyStuff()
        if MENU.gameOpenFadeIn then
            love.graphics.setColor(255, 255, 255, FADER.alpha)
        elseif WORLD.exploding then
            WORLD:drawScreenShake(-5, 5)
        end
        if DEBUG then
            MENU:drawDebugMenu()
        else
            MENU:drawMenu()
        end
        if WORLD.exploding then
            WORLD:drawExplosionStuff(240, 850)
        end
    elseif GAMESTATE == 2 then --GAME
        _G.map:draw()
        WORLD:drawExplosionStuff(WORLD.player.x + 32, WORLD.player.y + 32)
        WORLD:drawEnemyStuff()
        WORLD:drawPlayerStuff()
        WORLD:drawItemStuff()
        WORLD:drawHud()
        WORLD:drawWinScreen()
        WORLD:drawFire()
        WORLD:drawLightning()
    elseif GAMESTATE == 3 then --GAME OVER
        MENU:drawPaidRespect(WORLD.media.surprise.img)
        love.graphics.setFont(WORLD.media.fantasyfont)
        love.graphics.setColor(1, 0, 0, 1)
        love.graphics.print("YOU DIED", 100, 100)
        love.graphics.print("Press ESC to quit.", 100, 150)
        love.graphics.print("Press R to restart.", 100, 175)
        love.graphics.print("Press F to pay respect.", 100, 200)
    elseif GAMESTATE == 4 then --SHOP
        SHOP:drawShopShit()
        SHOP:broUBroke()
    elseif GAMESTATE == 6 then --STORY
        _G.map:draw()
        STORY:update()
        STORY:drawStory()
    elseif GAMESTATE == 7 then --CREDITS
        love.graphics.setColor(255, 255, 255, FADER.alpha)
        CREDITS:draw()
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

function love.keypressed(key)
    if GAMESTATE == 1 then
        -- When we passed the title screen
        if MENU.enterPressed then
            if key == "down" then
                if MENU.currentButtonId < 4 then
                    MENU.currentButtonId = MENU.currentButtonId + 1
                end
            elseif key == "up" then
                if MENU.currentButtonId > 1 then
                    MENU.currentButtonId = MENU.currentButtonId - 1
                end
            elseif key == "return" then
                if MENU.currentButtonId == 1 then
                    MENU:startGame()
                elseif MENU.currentButtonId == 2 then
                    WORLD.endlessmode = true
                    MUSIC:startMusic("villageBattle")
                    InitGame(10, 2)
                elseif MENU.currentButtonId == 3 then
                    CREDITS:load()
                else
                    print("currentButtonId " .. MENU.currentButtonId .. " not valid.")
                end
            elseif key == "left" then
                MENU:decreaseVolume()
            elseif key == "right" then
                MENU:increaseVolume()
            end
        end
    elseif GAMESTATE == 2 then
        if WORLD.wonLevel and key == "return" then
            if WORLD.endlessmode then
                WORLD:nextEndlessMode()
            else
                InitGame(WORLD.currentLvl, 6)
                WORLD.player:reset()
            end
        end
    elseif GAMESTATE == 4 then
        if key == "down" then
            if WORLD.endlessmode then
                if 0 <= SHOP.currentRow and SHOP.currentRow <= 5 then
                    SHOP.currentRow = SHOP.currentRow + 1
                end
            else
                if 1 <= SHOP.currentRow and SHOP.currentRow <= 5 then
                    SHOP.currentRow = SHOP.currentRow + 1
                end
            end
        elseif key == "up" then
            if WORLD.endlessmode then
                if 1 <= SHOP.currentRow and SHOP.currentRow <= 6 then
                    SHOP.currentRow = SHOP.currentRow - 1
                end
            else
                if 2 <= SHOP.currentRow and SHOP.currentRow <= 6 then
                    SHOP.currentRow = SHOP.currentRow - 1
                end
            end
        elseif key == "return" then
            -- getSkillFromRow returns the name of the skill in the shop, the according player lvl of that skill, and the lvl function of that skill
            if SHOP.currentRow ~= 6 then
                local skillName, skillLevel, skillFct = SHOP:getSkillFromRow()
                if skillLevel < #SHOP.prices[skillName] then
                    if SHOP:buy(SHOP.prices[skillName][skillLevel + 1]) then
                        skillFct(WORLD.player)
                    else
                        SHOP.tooBroke = true
                        SHOP.sensei = SHOP.media.senseiAngry
                    end
                end
            else
                love.graphics.setBackgroundColor(0, 0, 0, 0)
                if WORLD.endlessmode then
                    SHOP.clicked = false
                    SHOP.todaysSpecial = nil
                    SHOP.specialCategory = nil
                    WORLD.shoppedThisIteration = true
                    WORLD:nextEndlessMode()
                else
                    InitGame(WORLD.currentLvl, 6)
                end
            end
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
