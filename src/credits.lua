return {
    loaded = false,
    fade2BlackDone = false,
    rollingDone = false,
    fade2NormalDone = false,
    creditText = nil,
    creditIndex = 1,
    timerTillNextLine = 0.5,
    timerTillNextLineMax = 1,
    scrollSpeed = 1.7, --multiplier for text movin up
    currentLinesDisplayed = {}, --remove and add lines here, these are getting drawn
    --maybe make them an object containin text and y pos and center everything?
    load = function(self)
        if not self.loaded then
            GAMESTATE = 7
            local raw = Read_file("assets/text/credits.txt")
            self.creditText = Split(raw, "\n")
            MUSIC:startMusic("credits")
            self.loaded = true
        end
    end,
    update = function(self, dt)
        self:increaseLineYs()
        if not self.fade2BlackDone then
            local done = FADER:fadeToBlack(dt)
            if done then
                love.graphics.setFont(WORLD.media.bigreadfont)
                self.fade2BlackDone = true
                FADER.alpha = 1
            end
        elseif not self.rollingDone then
            self.timerTillNextLine = self.timerTillNextLine - dt
            if self.timerTillNextLine <= 0 then
                self:addLine()
                self.timerTillNextLine = self.timerTillNextLineMax
            end
        else
            love.graphics.setFont(WORLD.media.bigfantasyfont)
            MUSIC:startMusic("mainMenu")
            MENU.gameOpenFadeIn = false
            GAMESTATE = 1
        end
    end,
    increaseLineYs = function(self)
        for i, line in ipairs(self.currentLinesDisplayed) do
            line.y = line.y - self.scrollSpeed
            if line.y < -50 then
                table.remove(self.currentLinesDisplayed, i)
                if #self.currentLinesDisplayed == 0 then
                    self.rollingDone = true
                end
            end
        end
    end,
    addLine = function(self)
        local lineText = self.creditText[self.creditIndex]
        if lineText ~= nil then
            local line = {
                text = lineText,
                y = WORLD.y
            }
            table.insert(self.currentLinesDisplayed, line)
            self.creditIndex = self.creditIndex + 1
        end
    end,
    draw = function(self)
        for i, line in ipairs(self.currentLinesDisplayed) do
            love.graphics.printf(line.text, 20, line.y, WORLD.x - 50, "center")
        end
    end
}
