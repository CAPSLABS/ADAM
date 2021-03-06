return {
    name = "lizard",
    hp = 18,
    dmg = 5,
    speed = 0.8,
    x = 0,
    y = 0,
    level = 0,
    alive = true,
    reward = 3, --possibly function with variable reward?
    anim = nil,
    iFrameSec = 0.2,
    iFrameSecMax = 0.2,
    curAnim = "", --can be walkRight, walkLeft, walkDown, dying
    gotHit = false,
    --the approximate width and height of a lizard (smaller then image)
    width = 30,
    height = 50,
    --on which Y posis the lizard will change directions
    directionChangePosis = {},
    sideWalkGoalX = nil, --till which x posi the lizard will run before running down again
    sideWalkDir = nil,
    --the sprite begins ~15 pixels to the right of the image
    getLeftX = function(self)
        return self.x + 15
    end,
    getRightX = function(self)
        return self.x + 15 + self.width
    end,
    getTopY = function(self)
        return self.y + 15
    end,
    getBottomY = function(self)
        return self.y + 15 + self.height
    end,
    media = {
        img = "assets/enemies/lizard.png",
        imgGrid = nil,
        imgWidth = 64,
        imgHeight = 64
    },
    portrait = nil,
    portraitX = 4, -- x-th column in img for the portrait
    portraitY = 10, -- y-th row in img for the portrait
    --instantiator:
    newSelf = function(self, level)
        local baby = Shallowcopy(self)
        local spawn = math.random(0, 1)
        if spawn == 0 then --default posi is 0, no need to set to left side
            self.walkRight(baby)
        else
            baby.x = WORLD.x - self.width -- substracting width avoids clipping out to the right
            self.walkLeft(baby) --we pass baby instead of self
        end
        local directionChanges = math.random(0, 4)
        while directionChanges > 0 do
            table.insert(self.directionChangePosis, self:getRandomY())
            directionChanges = directionChanges - 1
        end
        table.sort(self.directionChangePosis)
        baby.level = level
        return baby
    end,
    getRandomX = function(self, half)
        --used to set sideWalkGoalX, how far to the side the lizard goes - its returns the x point on wich
        --the lizzo will walk down again
        local x = nil
        if half == "right" then
            x = math.random(0, self.x - 32)
        else
            x = math.random(self.x - self.width, WORLD.x - 40)
        end
        return x
    end,
    getSideOfScreen = function(self)
        if self.x >= WORLD.x / 2 then
            return "right"
        else
            return "left"
        end
    end,
    getRandomY = function(self)
        --use this to determine on which posis the lizard will walk to the left or right
        --192 is the height on which enemies stand to attack the city
        return math.random(1, WORLD.x - 180)
    end,
    walkLeft = function(self)
        self.curAnim = "walkLeft"
        self.anim = ANIMATE.newAnimation(self.media.imgGrid("1-9", 10), 0.08)
        self.sideWalkGoalX = self:getRandomX("right")
    end,
    walkRight = function(self)
        self.curAnim = "walkRight"
        self.anim = ANIMATE.newAnimation(self.media.imgGrid("1-9", 12), 0.08)
        self.sideWalkGoalX = self:getRandomX("left")
    end,
    getHit = function(self, dmg, dt)
        if not self.gotHit then
            self.gotHit = true
            self.hp = self.hp - dmg
            if (self.hp <= 0) and (self.curAnim ~= "dying") then
                --make sure to not die while already in the process of dying
                self:die()
            end
        end
    end,
    drop = function(self)
        assert(self.level >= 7, "Lizard:drop, self level was below 4 with: " .. self.level)
        local randomNumber = math.random()
        if self.level >= 7 then
            -- drops hearts with probability 10%
            if randomNumber <= 0.1 then
                WORLD:dropHeart(self)
            end
        end
    end,
    die = function(self)
        self.curAnim = "dying"
        if not WORLD.wonLevel then
            WORLD.player.money = WORLD.player.money + self.reward
            if
                WORLD.levels[WORLD.currentLvl].winType == "kill" and
                    WORLD.levels[WORLD.currentLvl].enemies.lizard.killToWin and
                    (WORLD.levels[WORLD.currentLvl].enemies.lizard.counter <
                        WORLD.levels[WORLD.currentLvl].enemies.lizard.goal)
             then
                WORLD.levels[WORLD.currentLvl].enemies.lizard.counter =
                    WORLD.levels[WORLD.currentLvl].enemies.lizard.counter + 1
            end
        end
        self.anim = ANIMATE.newAnimation(self.media.imgGrid("1-6", 21), 0.5, "pauseAtEnd")
    end,
    update = function(self, dt)
        self.anim:update(dt)
        if self.anim.status == "paused" then
            if self.curAnim == "dying" then
                self.alive = false
            end
        end
        if (self.curAnim == "walkDown") then
            self.y = self.y + (self.speed * 200 * dt)
            if self.directionChangePosis[1] ~= nil then
                if self.y >= self.directionChangePosis[1] then
                    table.remove(self.directionChangePosis, 1)
                    local half = self:getSideOfScreen()
                    if half == "left" then
                        self:walkRight()
                    else
                        self:walkLeft()
                    end
                end
            elseif self.y > (WORLD.y - 190) then
                self.curAnim = "attack"
                self.anim = ANIMATE.newAnimation(self.media.imgGrid("1-6", 7), 0.3, "pauseAtEnd")
            end
        elseif (self.curAnim == "walkLeft") then
            self.x = self.x - (self.speed * 200 * dt)
            if self.x <= self.sideWalkGoalX then
                self.curAnim = "walkDown"
                self.anim = ANIMATE.newAnimation(self.media.imgGrid("1-9", 11), 0.08)
            end
        elseif (self.curAnim == "walkRight") then
            self.x = self.x + (self.speed * 200 * dt)
            if self.x >= self.sideWalkGoalX then
                self.curAnim = "walkDown"
                self.anim = ANIMATE.newAnimation(self.media.imgGrid("1-9", 11), 0.08)
            end
        elseif (self.curAnim == "attack") and (self.anim.status == "paused") then
            WORLD.cityHealth = WORLD.cityHealth - self.dmg
            if self.y == 0 then
                self.anim = ANIMATE.newAnimation(self.media.imgGrid("1-6", 7), 0.3, "pauseAtEnd")
            else
                self.curAnim = "walkDown"
                self.anim = ANIMATE.newAnimation(self.media.imgGrid("1-9", 11), 0.08)
            end
        end
        if self.gotHit then
            self.iFrameSec = self.iFrameSec - (1 * dt)
            if self.iFrameSec <= 0 then
                self.gotHit = false
                self.iFrameSec = self.iFrameSecMax
            end
        end
    end
}
