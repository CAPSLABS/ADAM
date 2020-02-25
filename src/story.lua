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
    currentLine = "",
    instructions = nil,
    parsed = false,
    firstLvl = true,
    map9changed = false,
    --giving_instructions = true,
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
        william = {
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
        local raw = Read_file("/assets/text/story_v2.txt")
        self.storyText = Split(raw, "\n")
        self:loadSpeakerObjects()
        love.graphics.setFont(WORLD.media.readfont)
    end,
    loadSpeakerObjects = function(self)
        for key, value in pairs(self.cast) do
            local new_speaker = require("src.speaker")
            new_speaker:init(key, value)
            self.cast[key] = Shallowcopy(new_speaker)
            -- here self.cast[key] are the correct, different objects, for eg lilith has the values of lilith
        end
    end,
    update = function(self, dt)
        for name, each_speaker in pairs(self.leftSpeakers) do
            if each_speaker.inAnimation then
                each_speaker:update()
            end
        end
        for name, each_speaker in pairs(self.rightSpeakers) do
            if each_speaker.inAnimation then
                each_speaker:update()
            end
        end
    end,
    processNextLine = function(self)
        local line = self.storyText[self.storyIndex]
        local identifier = string.sub(line, 1, 1)
        if identifier == "~" then
            self:parse(line)
        else
            self:wiggle(line)
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
        local instructions = Split(line, "~")
        local character = instructions[1]
        local action = instructions[2]
        if action == "LEFT" then
            self:addSpeaker(self.cast[character], "left")
            self.parsed = true --causes the next line to be auto read-in
        elseif action == "RIGHT" then
            self:addSpeaker(self.cast[character], "right")
            self.parsed = true --causes the next line to be auto read-in
        elseif action == "TURN" then
            self.cast[character]:changeDirection()
            self.parsed = true --causes the next line to be auto read-in
        elseif action == "EXIT" then
            self:removeSpeakers(self.cast[character])
            self.parsed = true --causes the next line to be auto read-in
        elseif action == "MAPCHANGE" then
            self:mapchange(character)
            self.parsed = true
        elseif action == "SAGE" then
            self:startShopping()
        elseif action == "NEXTLEVEL" then
            self:startLevel()
        elseif action == "INSTRUCTIONS" then
            self:setInstructionFont()
            self.parsed = true
        elseif action == "INSTRUCTIONS_END" then
            self:setRegularFont()
            self.parsed = true
        elseif action == "MUSIC" then
            MUSIC:startMusic(character) --"character" arg could be the song title, not necc. a character name
            self.parsed = true
        end
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
                each_speaker.y,
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
                each_speaker.y,
                0,
                4,
                4
            )
            i = i + 1
        end
        love.graphics.draw(WORLD.HUD.media.hud.border, self.borderX, self.borderY)

        love.graphics.printf(
            self.currentLine,
            self.borderX + 30,
            self.borderY + 40,
            WORLD.HUD.media.hud.border:getWidth() - 50,
            "center"
        )

        love.graphics.setFont(WORLD.media.smallreadfont)
        love.graphics.printf("ENTER to continue", 310, 930, 200)
        if self.instructions then
            love.graphics.setFont(WORLD.media.fantasyfont)
        else
            love.graphics.setFont(WORLD.media.readfont)
        end
    end,
    removeSpeakers = function(self, speaker)
        --todo make "slide away from side" animation
        if speaker.side == "left" then
            self.leftSpeakers[speaker.name] = nil
        else
            self.leftSpeakers[speaker.name] = nil
        end
    end,
    startLevel = function(self)
        self.instructions = false
        self:prepareNextStep()
        if self.firstLvl then
            self.firstLvl = false
            WORLD.currentLvl = 1
            InitGame(WORLD.currentLvl, 2)
        else
            WORLD.currentLvl = WORLD.currentLvl + 1
            InitGame(WORLD.currentLvl, 2)
        end
    end,
    startShopping = function(self)
        self:prepareNextStep()
        InitGame(WORLD.currentLvl, 4)
    end,
    wiggle = function(self, line)
        local speaker = string.lower(Split(line, ":")[1])
        for name, speakerObj in pairs(self.leftSpeakers) do
            if name == speaker then
                speakerObj:setWiggleAnim()
            end
        end
        for name, speakerObj in pairs(self.rightSpeakers) do
            if name == speaker then
                speakerObj:setWiggleAnim()
            end
        end
    end,
    prepareNextStep = function(self)
        self.leftSpeakers = {}
        self.rightSpeakers = {}
        self.currentLine = ""
    end,
    mapchange = function(self, extraInfo)
        if extraInfo == "special" then
            WORLD.map = 1
            LoadMap()
        elseif extraInfo == "credits" then
            CREDITS:load()
        else
            WORLD.map = WORLD.map + 1
            LoadMap()
        end
    end,
    setInstructionFont = function(self)
        -- self.giving_instructions = true
        self.leftSpeakers = {}
        self.rightSpeakers = {}
        self.instructions = true
        love.graphics.setFont(WORLD.media.fantasyfont)
    end
}
