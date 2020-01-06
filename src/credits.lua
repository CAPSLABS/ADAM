return {
    loaded = false,
    fade2BlackDone = false,
    rollingDone = false,
    fade2NormalDone = false,
    creditText = nil,
    creditIndex = 1,
    timerTillNextLine = 2,
    timerTillNextLineMax = 2,
    scrollSpeed = 100, --multiplier for text movin up
    currentLinesDisplayed = {}, --remove and add lines here, these are getting drawn
    --maybe make them an object containgn text and y pos and center everything?
    load = function(self)
        if not self.loaded then
            WORLD.credits = true --triggers updates & draw calls
            local raw = Read_file("assets/text/story.txt")
            self.creditText = Split(raw, "\n")
            MUSIC:startMusic("credits")
            self.loaded = true
        end
    end,
    update = function(self, dt)
        if WORLD.credits then
            if not self.fade2BlackDone then
                local done = FADER:fadeToBlack(dt)
                if done then
                    self.fade2BlackDone = true
                end
            elseif not self.rollingDone then
                --self.rollingDone = true
                --ACTUAL CREDITS
                print("keep rollin")
            elseif not self.fade2NormalDone then
                --FADING OUT
                local done = FADER:fadeOut(dt)
                if done then
                    self.fade2NormalDone = true
                end
            else
                --END HERE, only called once
                WORLD.credits = false
                MUSIC:startMusic("mainMenu")
            end
        end
    end
}
