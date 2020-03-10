return {
    menu = function(self, key)
        if not DEBUG then
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
                        MENU:startIntroAnim()
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
        else
            -- cannot have STORY.firstLvl = false here and STORY.firstLvl = true for lvl 1 because the explosion
            -- animation of the beginning lets us call this function during the animation, setting STORY.firstLvl to
            -- false if don't hold the button 1 pressed
            if key == "1" then
                MENU:startIntroAnim()
                STORY.firstLvl = true
            elseif key == "2" then
                STORY.firstLvl = false
                STORY.storyIndex = 25
                InitGame(1, 6)
            elseif key == "3" then
                STORY.firstLvl = false
                STORY.storyIndex = 50
                InitGame(2, 6)
            elseif key == "4" then
                STORY.firstLvl = false
                STORY.storyIndex = 83
                InitGame(3, 6)
            elseif key == "5" then
                STORY.firstLvl = false
                STORY.storyIndex = 113
                STORY:mapchange()
                InitGame(4, 6)
            elseif key == "6" then
                STORY.firstLvl = false
                STORY.storyIndex = 137
                STORY:mapchange()
                InitGame(5, 6)
            elseif key == "7" then
                STORY.firstLvl = false
                STORY.storyIndex = 167
                STORY:mapchange()
                InitGame(6, 6)
            elseif key == "8" then
                STORY.firstLvl = false
                STORY.storyIndex = 203
                STORY:mapchange()
                STORY:mapchange()
                InitGame(7, 6)
            elseif key == "9" then
                STORY.firstLvl = false
                STORY.storyIndex = 220
                STORY:mapchange()
                STORY:mapchange()
                InitGame(8, 6)
            elseif key == "s" then
                GAMESTATE = 4
            --elseif key == "c" then
            --    GAMESTAATE = 7
            elseif key == "e" then
                WORLD.endlessmode = true
                MUSIC:startMusic("villageBattle")
                InitGame(10, 2)
            elseif key == "return" then
                MENU:startIntroAnim()
            end
        end
    end,
    game = function(self, key)
        if WORLD.wonLevel and key == "return" then
            if WORLD.endlessmode then
                WORLD:nextEndlessMode()
            else
                InitGame(WORLD.currentLvl, 6)
                WORLD.player:reset()
            end
        end
    end,
    gamePlayerInput = function(self, dt)
        -- MOVEMENT
        if love.keyboard.isDown("left") then
            WORLD.player:moveLeft(dt)
        elseif love.keyboard.isDown("right") then
            WORLD.player:moveRight(dt)
        end
        if love.keyboard.isDown("down") then
            WORLD.player:changeVerticalDirDown()
        elseif love.keyboard.isDown("up") then
            WORLD.player:changeVerticalDirUp()
        end
        -- ATTACKS (do not elseif or one cannot activate skills simultaniously!)
        if love.keyboard.isDown("a") then
            WORLD.player:throwBoom(dt)
        end
        if love.keyboard.isDown("s") and WORLD.player.canFire then
            WORLD.player:spitFire()
        end
        if love.keyboard.isDown("d") and WORLD.player.canBerserk then
            WORLD.player:goBerserk(dt)
        end
        if love.keyboard.isDown("f") and WORLD.player.canGoFast then
            WORLD.player:gottaGoFast(dt)
        end
        if love.keyboard.isDown("space") and WORLD.player.canBurst then
            WORLD.player:burst(dt)
        end
    end,
    story = function(self, key)
        if key == "return" then
            STORY:processNextLine()
        end
    end,
    shop = function(self, key)
        if key == "down" then
            if WORLD.endlessmode then
                if 0 <= SHOP.currentRow and SHOP.currentRow <= 5 then
                    SHOP.currentRow = SHOP.currentRow + 1
                    SHOP.hovered[SHOP.currentRow] = true
                end
            else
                if 1 <= SHOP.currentRow and SHOP.currentRow <= 5 then
                    SHOP.currentRow = SHOP.currentRow + 1
                    SHOP.hovered[SHOP.currentRow] = true
                end
            end
        elseif key == "up" then
            if WORLD.endlessmode then
                if 1 <= SHOP.currentRow and SHOP.currentRow <= 6 then
                    SHOP.currentRow = SHOP.currentRow - 1
                    SHOP.hovered[SHOP.currentRow] = true
                end
            else
                if 2 <= SHOP.currentRow and SHOP.currentRow <= 6 then
                    SHOP.currentRow = SHOP.currentRow - 1
                    SHOP.hovered[SHOP.currentRow] = true
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
    end,
    gameOver = function(self)
        if love.keyboard.isDown("r") then
            if WORLD.endlessmode then
                love.event.quit("restart")
            else
                WORLD.player:reset(true)
                InitGame(WORLD.currentLvl, 2)
            end
        elseif love.keyboard.isDown("f") then
            MENU.respectPaid = true
            MENU.firstFPress = true
            if MENU.lastInput == "f" then
                MENU.firstFPress = false
            end
            MENU.lastInput = "f"
        else
            MENU.lastInput = "n"
        end
    end
}
