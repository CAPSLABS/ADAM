return {
    storyText = nil,
    storyIndex = 1,
    borderX = 0,
    borderY = 800,
    leftSpeakers = {},
    rightSpeakers = {},
    speakerDist = 80,
    speakerXLeft = -55,
    speakerXRight = 290,
    speakerY = 600,
    currentLine = "",
    canGoOn = true,
    parsed = false,
    cast = {
        --all paths are transformed to speaker objects
        adam = {
            path = "assets/cha_sprites/adam.png",
            rowLeft = 3,
            columnLeft = 0,
            rowRight = 5,
            columnRight = 2
        },
        lilith = {
            path = "assets/cha_sprites/lilith.png",
            rowLeft = 3,
            columnLeft = 0,
            rowRight = 1,
            columnRight = 0
        },
        villager = {
            path = "assets/cha_sprites/villager.png",
            rowLeft = 7,
            columnLeft = 0,
            rowRight = 5,
            columnRight = 0
        },
        sage = {
            path = "assets/cha_sprites/sage.png",
            rowLeft = 3,
            columnLeft = 0,
            rowRight = 1,
            columnRight = 0
        },
        shearspake = {
            path = "assets/cha_sprites/shearspake.png",
            rowLeft = 3,
            columnLeft = 0,
            rowRight = 5,
            columnRight = 0
        },
        christopher = {
            path = "assets/cha_sprites/christopher.png",
            rowLeft = 7,
            columnLeft = 0,
            rowRight = 1,
            columnRight = 0
        }
    },
    loadStory = function(self)
        if WORLD.currentLvl == 1 then
            local raw = Read_file("assets/text/01_village.txt")
            self.storyText = Split(raw)
            self:loadSpeakerObjects()
            self:processNextLine()
        end
    end,
    loadSpeakerObjects = function(self)
        for key, value in pairs(self.cast) do
            local new_speaker = require("src.speaker")
            new_speaker:init(key, value)
            self.cast[key] = Shallowcopy(new_speaker)
            -- here self.cast[key] are the correct, different objects, for eg lilith has the values of lilith
        end
    end,
    keyUpdate = function(self, key)
        if key == "return" then
            self.canGoOn = true
        end
    end,
    updateStory = function(self, dt)
        if love.keyboard.isDown("return") then
            if self.canGoOn then
                self.canGoOn = false
                self:processNextLine()
            end
        end
    end,
    processNextLine = function(self)
        local line = self.storyText[self.storyIndex]
        local identifier = string.sub(line, 1, 1)
        if identifier == "%" then
            self:parse(line)
        else
            self:setLine(line)
        end
        self.storyIndex = self.storyIndex + 1
        if self.parsed then
            self.parsed = false
            self:processNextLine()
        end
    end,
    setLine = function(self, line)
        self.currentLine = line
    end,
    parse = function(self, line)
        --self:addSpeaker(self.cast.lilith, "left")
        self:addSpeaker(self.cast.villager, "left")
        self:addSpeaker(self.cast.adam, "right")
        self:addSpeaker(self.cast.lilith, "right")
        self.parsed = true --causes the next line to be auto read-in
    end,
    addSpeaker = function(self, speaker, side)
        --todo make "slide in from side" animation
        speaker:setSide(side)
        if speaker.side == "left" then
            self.leftSpeakers[speaker.name] = speaker
        else
            self.rightSpeakers[speaker.name] = speaker
        end
    end,
    drawStory = function(self)
        local i = 0
        for name, each_speaker in pairs(self.leftSpeakers) do
            love.graphics.draw(
                each_speaker.drawable,
                each_speaker.currentQuad,
                self.speakerXLeft + (self.speakerDist * i),
                self.speakerY,
                0,
                4,
                4
            )
            i = i + 1
        end
        i = 0
        for name, each_speaker in pairs(self.rightSpeakers) do
            love.graphics.draw(
                each_speaker.drawable,
                each_speaker.currentQuad,
                self.speakerXRight - (self.speakerDist * i),
                self.speakerY,
                0,
                4,
                4
            )
            i = i + 1
        end
        love.graphics.draw(WORLD.media.hud.border, self.borderX, self.borderY)
        love.graphics.printf(
            self.currentLine,
            self.borderX + 30,
            self.borderY + 40,
            WORLD.media.hud.border:getWidth() - 50,
            "center"
        )
    end,
    removeSpeakers = function(self, speaker)
        --todo make "slide away from side" animation
        if speaker.side == "left" then
            table.remove(self.leftSpeakers, speaker.portrait)
        else
            table.remove(self.rightSpeakers, speaker.portrait)
        end
    end
}
