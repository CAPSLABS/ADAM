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
    -- Sound obj having
    airhorn = nil,
    ----------------- UPDATING -----------------

    loadMenuSounds = function(self)
        self.airhorn = love.audio.newSource("assets/sounds/air_horn_sound.mp3", "static")
    end,
    -- Menu Text
    options = function(self)
        if DEBUG then
            love.graphics.setFont(WORLD.media.defaultfont)
            love.graphics.print("This is the DEBUG menu.", 10, 700)
            love.graphics.print(" Press ENTER to start playing!", 10, 720)
            love.graphics.print(" Press 1 to play only level 1!", 10, 740)
            love.graphics.print(" Press 2 to play only level 2!", 10, 760)
            love.graphics.print(" Press S to open the shop!", 10, 780)
        else
            love.graphics.setFont(WORLD.media.fantasyfont)
            love.graphics.print("A - wesome", 150, 350)
            love.graphics.print("D - efender", 150, 370)
            love.graphics.print("A - action", 150, 390)
            love.graphics.print("M - urderer", 150, 410)
            love.graphics.print(" Press ENTER to start to playing!", 40, 500)
        end
    end,
    -- Controls in Menu screen
    checkLoadingInput = function(self)
        if love.keyboard.isDown("space") then
            WORLD.player.bursting = true
            WORLD.exploding = true
        elseif love.keyboard.isDown("return") then
            WORLD.player.bursting = true
            WORLD.exploding = true
        end
        if DEBUG == true then
            if love.keyboard.isDown("1") then
                InitGame(1)
            elseif love.keyboard.isDown("2") then
                InitGame(2)
            elseif love.keyboard.isDown("s") then
                GAMESTATE = 4
            end
        end
    end,
    -- Controls during game or during gameover
    checkRestartInput = function(self)
        if love.keyboard.isDown("escape") then
            love.event.push("quit")
        elseif love.keyboard.isDown("r") and (WORLD.player.alive == false) then
            love.event.quit("restart")
        end
    end,
    checkGameOverInput = function(self)
        if love.keyboard.isDown("escape") then
            love.event.push("quit")
        elseif love.keyboard.isDown("r") then
            love.event.quit("restart")
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
                self.airhorn:play()
            end
        elseif self.airhorn:isPlaying() and self.lastInput ~= "f" then
            self.airhorn:stop()
        end
    end,
    ----------------- DRAWING -----------------

    drawPaidRespect = function(self, imgPath)
        if self.respectPaid then
            local randomAngle = love.math.random(-3.14, 3.14)
            local transformation = love.math.newTransform(240, 480, randomAngle, 1.3, 1.3, 240, 480)
            love.graphics.applyTransform(transformation)
            love.graphics.draw(imgPath)
            self.respectPaid = false
        else
            --TODO: Behalte tranformation selbst wenn F nicht mehr gedrückt
            love.graphics.draw(imgPath)
        end
    end
}
