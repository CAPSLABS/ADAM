--[[
--		Menu
--		@date 4.8.2019
--		@authors David, Phil
--]]

return {

	-- Menu Text
    options = function(self)
        love.graphics.print("This is the menu.",10,750)
        love.graphics.print(" Press C to start to play awesomedefenderactionmurderer!",10,760)
        love.graphics.print(" Press 1 to play only level 1!",10,770)
        love.graphics.print(" Press 2 to play only level 2!",10,780)
    end,

    -- Controls in Menu screen
    checkLoadingInput = function(self)
    	if love.keyboard.isDown("c") then
            gamestate=5
        elseif love.keyboard.isDown("1") then
            gamestate=2
            love.load(1)
        elseif love.keyboard.isDown("2") then
            gamestate=2
            love.load(2)
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
