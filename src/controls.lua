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
                STORY.storyIndex = 166
                STORY:mapchange()
                InitGame(6, 6)
            elseif key == "8" then
                STORY.firstLvl = false
                STORY.storyIndex = 202
                STORY:mapchange()
                STORY:mapchange()
                InitGame(7, 6)
            elseif key == "9" then
                STORY.firstLvl = false
                STORY.storyIndex = 219
                STORY:mapchange()
                STORY:mapchange()
                InitGame(8, 6)
            elseif key == "s" then
                --elseif love.keyboard.isDown("l") then
                --    GAMESTATE = 7
                GAMESTATE = 4
            elseif key == "return" then
                MENU:startIntroAnim(1, 6)
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
    end
}
