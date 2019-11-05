--[[
--		Menu
--		@date 4.8.2019
--		@authors David, Phil
--]]

return {
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
            world.player.bursting=true
            world.exploding = true
        elseif love.keyboard.isDown("return") then
            world.player.bursting=true
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

}
