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
                love.graphics.setColor(255, 255, 255, 1)
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
            self.loaded = false
            self.fade2BlackDone = false
            self.rollingDone = false
            self.fade2NormalDone = false
            self.creditText = nil
            self.creditIndex = 1
            self.timerTillNextLine = 0.5
            self.timerTillNextLineMax = 1
            self.scrollSpeed = 1.7
            self.currentLinesDisplayed = {}
            MUSIC:startMusic("mainMenu")
            MENU.gameOpenFadeIn = true
            FADER.alpha = 0
            love.graphics.setFont(WORLD.media.bigfantasyfont) --this should probably be triggered upon transitioning to GAMESTATE 1
            -- go back to title screen
            MENU.enterPressed = false
            -- load title text and title screen enemy - not needed since one enemy is already loaded
            --MENU:load()
            -- set story index back to one so we can start again
            STORY.storyIndex = 1
            -- set back player skills - loadPlayer() replaces the current player object with a fresh new player object
            WORLD:loadPlayer()
            -- only in debug regain all that sweet sweet money
            if DEBUG then
                WORLD.player.money = 10000
            end
            -- set back skill borders - create fresh hud and load it
            WORLD.HUD = Hud:Create()
            WORLD:loadHud()
            -- reset story, remove all speakers
            STORY.leftSpeakers = {}
            STORY.rightSpeakers = {}
            -- set world back to gamestate
            InitGame(#WORLD.levels,1)
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
        if not self.fade2BlackDone then
            _G.map:draw()
            --WORLD:drawEnemyStuff()
            love.graphics.setColor(255, 255, 255, FADER.alpha)
        end
        for i, line in ipairs(self.currentLinesDisplayed) do
            love.graphics.printf(line.text, 20, line.y, WORLD.x - 50, "center")
        end
    end
}
