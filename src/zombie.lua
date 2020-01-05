return {
    name = "zombie",
    hp = 6,
    dmg = 1,
    speed = 0.2,
    x = 0,
    y = 0,
    level = 0,
    alive = true,
    reward = 3, --possibly function with variable reward?
    anim = nil,
    iFrameSec = 1.05,
    iFrameSecMax = 1.05,
    curAnim = "leftPump", --can be walking, dying, leftPump, rightPump, star
    gotHit = false,
    --the approximate width and height of a zombie (smaller then image)
    width = 30,
    height = 50,
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
        img = "assets/zombie.png",
        imgWidth = 64,
        imgHeight = 64
    },
    portrait = nil,
    portraitX = 0, -- x-th column in img for the portrait
    portraitY = 2, -- y-th row in img for the portrait
    --instantiator:
    newSelf = function(self, level)
        local baby = Shallowcopy(self)
        baby.x = math.random(0, (WORLD.x - self.width)) -- substracting width avoids clipping out to the right
        baby.anim = ANIMATE.newAnimation(self.media.imgGrid("2-7", 7), 0.08, "pauseAtEnd")
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
        assert(self.level >= 4, "Zombie:drop, self level was below 4 with: " .. self.level)
        -- lvl 1-3: does not drop anything
        local randomNumber = math.random()
        if self.level == 4 then
            -- lvl 4: drops hearts with probability 10%
            if randomNumber <= 0.1 then
                WORLD:dropHeart(self)
            end
        elseif self.level == 5 or self.level == 6 then
            -- lvl 5: drops hearts with probability 15%
            if randomNumber <= 0.15 then
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
                    (WORLD.levels[WORLD.currentLvl].enemies.zombie.counter <
                        WORLD.levels[WORLD.currentLvl].enemies.zombie.goal)
             then
                WORLD.levels[WORLD.currentLvl].enemies.zombie.counter =
                    WORLD.levels[WORLD.currentLvl].enemies.zombie.counter + 1
            end
        end
        self.anim = ANIMATE.newAnimation(self.media.imgGrid("1-6", 21), 0.3, "pauseAtEnd")
    end,
    update = function(self, dt)
        self.anim:update(dt)
        if self.anim.status == "paused" then
            if self.curAnim == "dying" then
                self.alive = false
            else
                self:dance()
            end
        end
        if (self.curAnim == "walking") then
            self.y = self.y + (self.speed * 200 * dt)
            if self.y > (WORLD.y - 190) then
                self.curAnim = "attack"
                self.anim = ANIMATE.newAnimation(self.media.imgGrid("1-6", 19), 0.3, "pauseAtEnd")
            end
        elseif (self.curAnim == "attack") and (self.anim.status == "paused") then
            WORLD.cityHealth = WORLD.cityHealth - self.dmg
            self.anim = ANIMATE.newAnimation(self.media.imgGrid("1-6", 19), 0.3, "pauseAtEnd")
        end

        if self.gotHit then
            self.iFrameSec = self.iFrameSec - (1 * dt)
            if self.iFrameSec <= 0 then
                self.gotHit = false
                self.iFrameSec = self.iFrameSecMax
            end
        end
    end,
    --everytime the cur. anim. is paused, we go to the next
    --animations: left pump -> right pump -> star shape -> start walking towards player
    --dance class 101
    dance = function(self, dt)
        if self.curAnim == "leftPump" then
            self.anim = ANIMATE.newAnimation(self.media.imgGrid("2-7", 7), 0.08, "pauseAtEnd"):flipH()
            self.curAnim = "rightPump"
        elseif self.curAnim == "rightPump" then
            self.anim = ANIMATE.newAnimation(self.media.imgGrid("1-7", 3), 0.2, "pauseAtEnd")
            self.curAnim = "star"
        elseif self.curAnim == "star" then
            self.anim = ANIMATE.newAnimation(self.media.imgGrid("1-9", 11), 0.1)
            self.curAnim = "walking"
        end
    end
}
