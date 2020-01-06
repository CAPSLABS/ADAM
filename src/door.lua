return {
    name = "door",
    hp = 200,
    dmg = 0,
    speed = 0,
    x = 0,
    y = 0,
    level = 0,
    alive = true,
    reward = 10, --possibly function with variable reward?
    anim = nil,
    iFrameSec = 0.27,
    iFrameSecMax = 0.27,
    curAnim = nil, --has no animations
    gotHit = false,
    --the approximate width and height of a zombie (smaller then image)
    width = 480,
    height = 128,
    --the sprite begins ~15 pixels to the right of the image
    getLeftX = function(self)
        return self.x
    end,
    getRightX = function(self)
        return self.width
    end,
    getTopY = function(self)
        return self.y
    end,
    getBottomY = function(self)
        return self.height
    end,
    media = {
        img = "assets/door.png",
        imgGrid = nil,
        imgWidth = 480,
        imgHeight = 127
    },
    portrait = nil,
    portraitX = 0, -- x-th column in img for the portrait
    portraitY = 0, -- y-th row in img for the portrait
    --instantiator:
    newSelf = function(self, level)
        local baby = Shallowcopy(self)
        baby.x = math.random(0, (WORLD.x - self.width)) -- substracting width avoids clipping out to the right
        baby.anim = ANIMATE.newAnimation(self.media.imgGrid("1-1", 1), 0.08, "pauseAtEnd")
        baby.level = level
        return baby
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
        -- does not drop anything
    end,
    die = function(self)
        self.curAnim = "dying"
        if not WORLD.wonLevel then
            WORLD.player.money = WORLD.player.money + self.reward
            if
                WORLD.levels[WORLD.currentLvl].winType == "kill" and
                    WORLD.levels[WORLD.currentLvl].enemies.door.killToWin and
                    (WORLD.levels[WORLD.currentLvl].enemies.door.counter <
                        WORLD.levels[WORLD.currentLvl].enemies.door.goal)
             then
                WORLD.levels[WORLD.currentLvl].enemies.door.counter =
                    WORLD.levels[WORLD.currentLvl].enemies.door.counter + 1
            end
        end
        --self.anim = ANIMATE.newAnimation(self.media.imgGrid("1-6", 21), 0.3, "pauseAtEnd")
    end,
    update = function(self, dt)
        --self.anim:update(dt)
        --if self.anim.status == "paused" then
        if self.curAnim == "dying" then
            self.alive = false
        end
        --end
        if self.gotHit then
            self.iFrameSec = self.iFrameSec - (1 * dt)
            if self.iFrameSec <= 0 then
                self.gotHit = false
                self.iFrameSec = self.iFrameSecMax
            end
        end
    end
}
