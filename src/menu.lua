--[[
--		Menu
--		@date 4.8.2019
--		@authors David, Phil
--]]

return {

    -- Whether F has been pressed in the game over screen
    respectPaid = false,
    
    ----------------- UPDATING -----------------

	-- Menu Text
    options = function(self)
        if debug then
            love.graphics.setFont(world.media.defaultfont)
            love.graphics.print("This is the DEBUG menu.",10,700)
            love.graphics.print(" Press ENTER to start playing!",10,720)
            love.graphics.print(" Press 1 to play only level 1!",10,740)
            love.graphics.print(" Press 2 to play only level 2!",10,760)
            love.graphics.print(" Press S to open the shop!",10,780)

        else 
            love.graphics.setFont(world.media.fantasyfont)
            love.graphics.print("A - wesome",150,350)
            love.graphics.print("D - efender",150,370)
            love.graphics.print("A - action",150,390)
            love.graphics.print("M - urderer"  ,150,410)
            love.graphics.print(" Press ENTER to start to playing!",40,500)
        end
    end,

    -- Controls in Menu screen
    checkLoadingInput = function(self)
        if love.keyboard.isDown("space") then
            world.exploding = true
        elseif love.keyboard.isDown("return") then
            world.exploding = true
        end
        if debug==true then
            if love.keyboard.isDown("1") then
                gamestate=2
                initGame(1)
            elseif love.keyboard.isDown("2") then
                gamestate=2
                initGame(2)
            elseif love.keyboard.isDown("s") then
                gamestate=4
            end
        end
	end,

	-- Controls during game or during gameover
	checkRestartInput = function(self)
    	if love.keyboard.isDown("escape") then
            love.event.push("quit") 
        elseif love.keyboard.isDown("r") and (world.player.alive==false) then
            love.event.quit("restart")
        end
	end,

    checkGameOverInput = function(self)
        if love.keyboard.isDown("escape") then
            love.event.push("quit") 
        elseif love.keyboard.isDown("r") then
            love.event.quit("restart")
        elseif love.keyboard.isDown("f") then
            respectPaid = true
        end
    end,

    playAirhornSound = function(self)
        if respectPaid then
            local airhorn = love.audio.newSource("assets/sounds/air_horn_sound.mp3","static")
            airhorn:play()
        end
    end,

    ----------------- DRAWING -----------------

    drawPaidRespect = function(self,imgPath)
        if respectPaid then
            local randomAngle = love.math.random(-3.14,3.14)
            local transformation = love.math.newTransform(240,480,randomAngle,1.3,1.3,240,480)
            love.graphics.applyTransform(transformation)
            love.graphics.draw(imgPath)
            respectPaid = false
        else
            --TODO: Behalte tranformation selbst wenn F nicht mehr gedrückt
            love.graphics.draw(imgPath)
        end
    end,

}
