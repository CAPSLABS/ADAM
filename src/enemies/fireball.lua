return {
    name = "fireball",
    hp = 15,
    dmg = 1,
    speed = 3,
    x = 0,
    y = 0,
    level = 0, -- level in which the goblin was spawned
    alive = true,
    reward = 0, --possibly function with variable reward?
    anim = nil,
    curAnim = nil, --can be surrounding, targeting, dying
    angle = 0, -- needed for smooth surrounding of boss
    surroundRadius = 75, -- radius of circle for surrounding the boss
    interpolationFactor = 0, -- smth bigger than 0, needed for smooth targeting
    lastKnownPlayerX = 0,
    lastKnownPlayerY = 0,
    gotHit = false,
    --the approximate width and height of the fireball within 1 image
    width = 32,
    --10,
    height = 54,
    --28,
    iFrameSec = 0.2,
    iFrameSecMax = 0.2,
    --the sprite begins ~15 pixels to the right of the image
    getLeftX = function(self)
        return self.x + 15
    end,
    getRightX = function(self)
        return self:getLeftX() + self.width + 30
    end,
    getTopY = function(self)
        return self.y
    end,
    getBottomY = function(self)
        return self.y + self.height
    end,
    media = {
        img = "assets/enemies/fireball.png",
        imgGrid = nil,
        imgWidth = 64,
        imgHeight = 64
    },
    portrait = nil,
    portraitX = 0, -- x-th row in img for the portrait
    portraitY = 0, -- y-th column in img for the portrait
    --instantiator:
    newSelf = function(self, level, bossX, bossY)
        --place new fireball a bit left to the boss
        local baby = Shallowcopy(self)
        baby.x = bossX
        baby.y = bossY
        baby.anim = ANIMATE.newAnimation(self.media.imgGrid("1-4", 1), 0.07)
        baby.curAnim = "surrounding"
        baby.level = level
        return baby
    end,
    getHit = function(self, dmg)
        if not self.gotHit then
            self.gotHit = true
            self.hp = self.hp - dmg
            if (self.hp <= 0) and (self.curAnim ~= "dyingButCanStillHit") then --and (self.curAnim == "walking") then
                self:die()
            end
        end
    end,
    drop = function(self)
        --does not drop anything
    end,
    die = function(self)
        self.curAnim = "dyingButCanStillHit"
        self.anim = ANIMATE.newAnimation(self.media.imgGrid("1-4", 1), 0.4, "pauseAtEnd")
    end,
    dieNonHurting = function(self)
        self.curAnim = "dying"
        self.anim = ANIMATE.newAnimation(self.media.imgGrid("1-4", 1), 0.4, "pauseAtEnd")
    end,
    update = function(self, dt, bossX, bossY)
        -- update animations
        self.anim:update(dt)
        -- increase angle
        self.angle = self.angle + self.speed * dt
        if (self.anim.status == "paused") and (self.curAnim == "dyingButCanStillHit" or "dying") then
            self.alive = false
            self.interpolationFactor = 0
        elseif self.curAnim == "dyingButCanStillHit" then
            -- move towards the player while dyingButCanStillHit
            self.y = self.y + self.speed * 150 * dt
        elseif self.curAnim == "surrounding" then
            -- surround the boss's center
            self.x = bossX + self.surroundRadius * math.cos(self.angle)
            self.y = bossY + self.surroundRadius * math.sin(self.angle)
        elseif self.curAnim == "targeting" then
            -- remember last player location until we reach height y = 600
            if self.y <= 600 then
                self.lastKnownPlayerX = WORLD.player.x
                self.lastKnownPlayerY = WORLD.player.y
            end
            -- target the player, this animation is set by the boss
            self.interpolationFactor = self.interpolationFactor + dt / 15
            self.x = (1 - self.interpolationFactor) * self.x + self.interpolationFactor * self.lastKnownPlayerX
            self.y = (1 - self.interpolationFactor) * self.y + self.interpolationFactor * self.lastKnownPlayerY
            if self.interpolationFactor >= 0.2 then
                self:dieNonHurting()
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
