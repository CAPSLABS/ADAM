--[[
--		Menu
--		@date 4.8.2019
--		@authors David, Phil
--]]
return {
    -- Whether F has been pressed in the game over screen
    respectPaid = false,
    -- Short time switch to mark the first time when F is pressed
    firstFPress = false,
    -- Last acknowledged input during the game over screen
    lastInput = nil,
    enterPressed = false,
    gameOpenFadeIn = true,
    slider = {value = 0.2, min = 0, max = 1},
    -- The id of the SUIT widget we are currently focussing
    currentButtonId = 1,
    focussedButtonBorderWidth = 5,
    a = nil,
    d = nil,
    a2 = nil,
    m = nil,
    ----------------- UPDATING -----------------
    decreaseVolume = function(self, dt)
        if MENU.currentButtonId == 4 then
            MENU.slider.value = MENU.slider.value - 0.1
            MUSIC:changeVolume(MENU.slider.value)
            if MENU.slider.value < 0 then
                MENU.slider.value = 0
            end
        end
    end,
    increaseVolume = function(self, dt)
        if MENU.currentButtonId == 4 and MENU.slider.value + 0.1 < 1 then
            MENU.slider.value = MENU.slider.value + 0.1
            MUSIC:changeVolume(MENU.slider.value)
        end
    end,
    -- Title screen menu Text
    updateMenu = function(self, dt)
        if love.keyboard.isDown("return") then
            self.enterPressed = true
        end
        if self.enterPressed then
            self:mainMenu()
        end
    end,
    -- Menu after pressing enter on title screen once - controls using mouse
    mainMenu = function(self)
        if SUIT.ImageButton(WORLD.HUD.media.hud.borderSmall, {id = 1}, self:getBorderX(), self:getBorderY(1)).hit then
            self:startGame()
        elseif SUIT.ImageButton(WORLD.HUD.media.hud.borderSmall, {id = 2}, self:getBorderX(), self:getBorderY(2)).hit then
            WORLD.endlessmode = true
            MUSIC:startMusic("villageBattle")
            InitGame(10, 2)
        elseif SUIT.ImageButton(WORLD.HUD.media.hud.borderSmall, {id = 3}, self:getBorderX(), self:getBorderY(3)).hit then
            CREDITS:load()
        end
        MUSIC:changeVolume(self.slider.value)
    end,
    getBorderX = function(self)
        return 240 - WORLD.HUD.media.hud.borderSmall:getWidth() / 2
    end,
    getBorderY = function(self, segment)
        return WORLD.y / 5 * segment - WORLD.y / 8
    end,
    fadeIn = function(self, dt)
        if self.gameOpenFadeIn then
            local done = FADER:fadeIn(dt)
            if done then
                self.gameOpenFadeIn = false
            end
        end
    end,
    -- Controls during during gameover
    checkGameOverInput = function(self)
        if love.keyboard.isDown("r") then
            if WORLD.endlessmode then
                love.event.quit("restart")
            else
                WORLD.player:reset(true)
                WORLD:reset()
                InitGame(WORLD.currentLvl, 2)
            end
        elseif love.keyboard.isDown("f") then
            self.respectPaid = true
            self.firstFPress = true
            if self.lastInput == "f" then
                self.firstFPress = false
            end
            self.lastInput = "f"
        else
            self.lastInput = "n"
        end
    end,
    playAirhornSound = function(self)
        if self.firstFPress then
            if self.lastInput == "f" then
                MUSIC.airhorn:play()
            end
        elseif MUSIC.airhorn:isPlaying() and self.lastInput ~= "f" then
            MUSIC.airhorn:stop()
        end
    end,
    startIntroAnim = function(self)
        WORLD.player.bursting = true
        WORLD.exploding = true
    end,
    setTitle = function(self)
        local rand = math.random(0, 2)
        if rand == 0 then
            self.a = "A - wesome"
            self.d = "D - efender"
            self.a2 = "A - ction"
            self.m = "M - urderer"
        elseif rand == 1 then
            self.a = "A"
            self.d = "D - istinctively"
            self.a2 = "A - verage"
            self.m = "M - an"
        elseif rand == 2 then
            self.a = "A - wesome"
            self.d = "A - ttacker"
            self.a2 = "A - ction"
            self.m = "A - sshole"
        end
    end,
    ----------------- DRAWING -----------------
    drawTitle = function(self)
        love.graphics.setFont(WORLD.media.bigfantasyfont)
        love.graphics.print(self.a, 105, 250)
        love.graphics.print(self.d, 105, 300)
        love.graphics.print(self.a2, 105, 350)
        love.graphics.print(self.m, 105, 400)
        love.graphics.print("Press ENTER!", 100, 600)
    end,
    drawDebugMenu = function(self)
        love.graphics.setFont(WORLD.media.defaultfont)
        love.graphics.print("This is the DEBUG menu.", 10, 700)
        love.graphics.print(" Press ENTER to start playing!", 10, 720)
        love.graphics.print(" Press 1 to play only level 1!", 10, 740)
        love.graphics.print(" Press 2 to play only level 2!", 10, 760)
        love.graphics.print(" Press S to open the shop!", 10, 780)
        love.graphics.print(" Press Enter to start the STORY!", 10, 800)
    end,
    drawPaidRespect = function(self)
        if self.respectPaid then
            local randomAngle = love.math.random(-3.14, 3.14)
            local transformation = love.math.newTransform(240, 480, randomAngle, 1.3, 1.3, 240, 480)
            love.graphics.applyTransform(transformation)
            love.graphics.draw(WORLD.media.surprise.img)
            self.respectPaid = false
        else
            --TODO: Behalte tranformation selbst wenn F nicht mehr gedrückt
            love.graphics.setBackgroundColor(0, 0, 0, 0)
            love.graphics.draw(WORLD.media.surprise.img)
        end
    end,
    drawMenu = function(self)
        if self.enterPressed then
            self:drawFocussedButtonBorder()
            SUIT:draw()
            self:writeButtons()
        else
            self:drawTitle()
        end
    end,
    drawFocussedButtonBorder = function(self)
        love.graphics.setColor(1, 0, 0)
        if 0 < self.currentButtonId and self.currentButtonId < 4 then
            love.graphics.rectangle(
                "fill",
                self:getBorderX() - self.focussedButtonBorderWidth,
                self:getBorderY(self.currentButtonId) - self.focussedButtonBorderWidth,
                WORLD.HUD.media.hud.borderSmall:getWidth() + 2 * self.focussedButtonBorderWidth,
                WORLD.HUD.media.hud.borderSmall:getHeight() + 2 * self.focussedButtonBorderWidth
            )
        elseif self.currentButtonId == 4 then
            love.graphics.rectangle(
                "fill",
                self:getBorderX() + 80 - self.focussedButtonBorderWidth,
                self:getBorderY(self.currentButtonId) + 80 - self.focussedButtonBorderWidth,
                200 + 2 * self.focussedButtonBorderWidth,
                20 + 2 * self.focussedButtonBorderWidth
            )
        else
            print("Drawing currentButtonId " .. self.currentButtonId .. " failed.")
        end
        love.graphics.setColor(255, 255, 255)
    end,
    writeButtons = function(self)
        love.graphics.printf(
            "STORY MODE",
            self:getBorderX() + 50,
            self:getBorderY(1) + 40,
            WORLD.HUD.media.hud.borderSmall:getWidth()
        )
        love.graphics.printf(
            "ENDLESS MODE",
            self:getBorderX() + 35,
            self:getBorderY(2) + 40,
            WORLD.HUD.media.hud.borderSmall:getWidth()
        )
        love.graphics.printf(
            "CREDITS",
            self:getBorderX() + 100,
            self:getBorderY(3) + 40,
            WORLD.HUD.media.hud.borderSmall:getWidth()
        )
        love.graphics.printf(
            "VOLUME",
            self:getBorderX() + 100,
            self:getBorderY(4) + 40,
            WORLD.HUD.media.hud.borderSmall:getWidth()
        )
        SUIT.Slider(self.slider, self:getBorderX() + 80, self:getBorderY(4) + 80, 200, 20)
    end
}
