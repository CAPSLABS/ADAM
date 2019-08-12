--[[
--		Menu
--		@date 4.8.2019
--		@authors David, Phil
--]]

return {
	-- Menu Text
    options = function(self)
        if debug then
            love.graphics.print("This is the DEBUG menu.",10,750)
            love.graphics.print(" Press ENTER to start to play awesomedefenderactionmurderer!",10,760)
            love.graphics.print(" Press 1 to play only level 1!",10,770)
            love.graphics.print(" Press 2 to play only level 2!",10,780)
            love.graphics.print(" Press S to open the shop!",10,790)

        else 
            love.graphics.print("This is the menu.",10,750)
            love.graphics.print(" Press ENTER to start to play awesomedefenderactionmurderer!",10,760)
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
                love.load(1)
            elseif love.keyboard.isDown("2") then
                gamestate=2
                love.load(2)
            elseif love.keyboard.isDown("s") then
                gamestate=4
                love.load()
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
