--[[
--		Menu
--		@date 4.8.2019
--		@authors David, Phil
--]]

Menu = { 
	background = "assets/menubackground.png", 
}

function Menu:init()
	self.background = love.graphics.newImage(self.background)
end

function Menu:draw()
	for i = 0, love.graphics.getWidth() / self.background:getWidth() do
        for j = 0, love.graphics.getHeight() / self.background:getHeight() do
            love.graphics.draw(self.background, i * self.background:getWidth(), j * self.background:getHeight())
        end
    end
    love.graphics.print("This is the menu.",10,800)
	love.graphics.print(" Press C to start to play awesomedefenderactionmurderer!",10,810)
	love.graphics.print(" Press 1 to play only level 1!",10,820)
	love.graphics.print(" Press 2 to play only level 2!",10,830)
end

