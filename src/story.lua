return {
    storyText = nil,
    storyIndex = 1,
    borderX = 0,
    borderY = 200,
    loadStory = function(self)
        if WORLD.currentLvl == 1 then
            local raw = Read_file("assets/text/01_village.txt")
            self.storyText = Split(raw)
        end
    end,
    printNextLine = function(self)
        print(self.storyText[self.storyIndex])
        self.storyIndex = self.storyIndex + 1
    end,
    drawStory = function(self)
        love.graphics.draw(WORLD.media.hud.border, self.borderX, self.borderY)
    end
}
