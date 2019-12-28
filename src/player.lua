return {
    -- basic stats:
    alive = true,
    hearts = 3,
    maxHearts = 3,
    money = 0,
    speed = 250,
    --the approximate width and height of the character (smaller than image)
    width = 24,
    height = 45,
    --the sprite begins ~20 pixels to the right of the image
    getLeftX = function(self)
        return self.x + 20
    end,
    getRightX = function(self)
        return self.x + 20 + self.width + 3
    end,
    getTopY = function(self)
        return self.y + 10
    end,
    getBottomY = function(self)
        return self.y + 10 + self.height
    end,
    --start pos
    x = 200,
    y = 700,
    dir = 1, --1=up, 2=down
    --attacks:
    -- a
    boomLevel = 1,
    boomCooldown = 1,
    canBoom = true,
    booms = {},
    -- s
    fireLevel = 0,
    fireCooldown = 10,
    canFire = true,
    fires = {},
    -- d
    berserkLevel = 0,
    berserkCooldown = 10,
    canBerserk = true,
    -- f
    goFastLevel = 0,
    goFastCooldown = 10,
    canGoFast = true,
    sonicAcceleration = 12,
    currentAcceleration = 0,
    sonicRingMaxRuntime = 2,
    sonicRings = {},
    -- space
    burstLevel = 0,
    burstCooldown = 20,
    canBurst = true,
    bursting = false,
    explosionMaxRuntime = 1.3,
    -- MODES
    fireDuration = 3,
    berserkDuration = 3,
    inBerserk = false,
    berserkAlpha = 0,
    --
    sonicDuration = 2,
    inSonic = false,
    -- i frames
    gotHit = false,
    iFrameSec = 1,
    iFrameSecMax = 1,
    media = {
        img = "assets/HeroScaled.png",
        boom = "assets/boomerang.png",
        fire = "assets/fireScaled.png",
        berserk = "assets/berserk.png"
    },
    moveLeft = function(self, dt)
        if (self:getLeftX()) > 0 then
            if self.inSonic then
                self.x = self.x - (self.currentAcceleration * dt)
                self.currentAcceleration = self.currentAcceleration + self.sonicAcceleration
            else
                self.x = self.x - (self.speed * dt)
            end
        end
        self.anim:update(dt)
    end,
    moveRight = function(self, dt)
        if (self:getRightX()) < WORLD.x then
            if self.inSonic then
                self.x = self.x + self.currentAcceleration * dt
                self.currentAcceleration = self.currentAcceleration + self.sonicAcceleration
            else
                self.x = self.x + (self.speed * dt)
            end
        end
        self.anim:update(dt)
    end,
    changeDirDown = function(self)
        if self.dir == 1 then
            self.dir = 2
            self.anim = self.downAnim
        end
    end,
    changeDirUp = function(self)
        if self.dir == 2 then
            self.dir = 1
            self.anim = self.upAnim
        end
    end,
    --a
    throwBoom = function(self, dt)
        if self.inBerserk == false then
            if self.canBoom then
                table.insert(
                    self.booms,
                    {
                        anim = ANIMATE.newAnimation(self.media.boomGrid("1-8", 1), 0.01),
                        x = self.x,
                        y = self.y,
                        dmg = 1,
                        dir = self.dir
                    }
                )
                self.canBoom = false
                self.boomCooldown = PLAYERRAW.boomCooldown
            end
        else --NO LIMITS WEEEEEEE
            table.insert(
                self.booms,
                {
                    anim = ANIMATE.newAnimation(self.media.boomGrid("1-8", 1), 0.01),
                    x = self.x,
                    y = self.y,
                    dmg = 1,
                    dir = self.dir
                }
            )
        end
    end,
    --s
    spitFire = function(self)
        if self.fireLevel ~= 0 then
            local yOffset = 0
            if self.dir == 1 then
                yOffset = 370
            else
                yOffset = -self.height
            end
            local newFire = {
                img = self.media.fire,
                time = self.fireDuration,
                x = self.x - 40,
                y = self.y - yOffset,
                width = self.media.fire:getWidth(),
                height = self.media.fire:getHeight(),
                dmg = 2,
                dir = self.dir
            }
            table.insert(self.fires, newFire)
            self.canFire = false
            self.fireCooldown = PLAYERRAW.fireCooldown
        end
    end,
    --d
    goBerserk = function(self, dt)
        if self.berserkLevel ~= 0 then
            self.inBerserk = true
            self.canBerserk = false
            self.berserkCooldown = PLAYERRAW.berserkCooldown
        end
    end,
    --f
    gottaGoFast = function(self, dt)
        if self.goFastLevel ~= 0 then
            self.inSonic = true
            self.canGoFast = false
            self.goFastCooldown = PLAYERRAW.goFastCooldown
        end
    end,
    --space
    burst = function(self, dt)
        if self.burstLevel ~= 0 then
            WORLD.exploding = true
            self.bursting = true
            self.canBurst = false
            self.burstCooldown = PLAYERRAW.burstCooldown
        end
    end,
    lvlUpBoom = function(self)
        self.boomLevel = self.boomLevel + 1
        if self.boomLevel == 2 then
            WORLD.media.hudSkillBorder.a = WORLD.media.hud.silver
            WORLD.player.boomCooldown = WORLD.player.boomCooldown / 2
            PLAYERRAW.boomCooldown = PLAYERRAW.boomCooldown / 2
        elseif self.boomLevel == 3 then
            WORLD.media.hudSkillBorder.a = WORLD.media.hud.gold
            WORLD.player.boomCooldown = WORLD.player.boomCooldown / 2
            PLAYERRAW.boomCooldown = PLAYERRAW.boomCooldown / 2
        end
    end,
    lvlUpFire = function(self)
        self.fireLevel = self.fireLevel + 1
        if self.fireLevel == 2 then
            WORLD.media.hudSkillBorder.s = WORLD.media.hud.silver
            WORLD.player.fireCooldown = WORLD.player.fireCooldown / 2
            PLAYERRAW.fireCooldown = PLAYERRAW.fireCooldown / 2
        elseif self.fireLevel == 3 then
            WORLD.media.hudSkillBorder.s = WORLD.media.hud.gold
            WORLD.player.fireCooldown = WORLD.player.fireCooldown / 2
            PLAYERRAW.fireCooldown = PLAYERRAW.fireCooldown / 2
        end
    end,
    lvlUpBerserk = function(self)
        self.berserkLevel = self.berserkLevel + 1
        if self.berserkLevel == 2 then
            WORLD.media.hudSkillBorder.d = WORLD.media.hud.silver
            WORLD.player.berserkCooldown = WORLD.player.berserkCooldown / 2
            PLAYERRAW.berserkCooldown = PLAYERRAW.berserkCooldown / 2
        elseif self.berserkLevel == 3 then
            WORLD.media.hudSkillBorder.d = WORLD.media.hud.gold
            WORLD.player.berserkCooldown = WORLD.player.berserkCooldown / 2
            PLAYERRAW.berserkCooldown = PLAYERRAW.berserkCooldown / 2
        end
    end,
    lvlUpFast = function(self)
        self.goFastLevel = self.goFastLevel + 1
        if self.goFastLevel == 2 then
            WORLD.media.hudSkillBorder.f = WORLD.media.hud.silver
            WORLD.player.goFastCooldown = WORLD.player.goFastCooldown / 2
            PLAYERRAW.goFastCooldown = PLAYERRAW.goFastCooldown / 2
        elseif self.goFastLevel == 3 then
            WORLD.media.hudSkillBorder.f = WORLD.media.hud.gold
            WORLD.player.goFastCooldown = WORLD.player.goFastCooldown / 2
            PLAYERRAW.goFastCooldown = PLAYERRAW.goFastCooldown / 2
        end
    end,
    lvlUpBurst = function(self)
        self.burstLevel = self.burstLevel + 1
        if self.burstLevel == 2 then
            WORLD.media.hudSkillBorder.space = WORLD.media.hud.silver
            WORLD.player.burstCooldown = WORLD.player.burstCooldown / 2
            PLAYERRAW.burstCooldown = PLAYERRAW.burstCooldown / 2
        elseif self.burstLevel == 3 then
            WORLD.media.hudSkillBorder.space = WORLD.media.hud.gold
            WORLD.player.burstCooldown = WORLD.player.burstCooldown / 2
            PLAYERRAW.burstCooldown = PLAYERRAW.burstCooldown / 2
        end
    end,
    update = function(self, dt)
        self:updateCooldowns(dt)
        self:updateModeDurations(dt)
        self:updateBooms(dt) --moves,animates&deletes boomerangs
        self:updateFire(dt)
        self:updateIFrames(dt)
    end,
    updateCooldowns = function(self, dt)
        --TODO underflow protection needed y/N?
        -- possibly check if between max and 0 before calculations?
        --if my_number >= 1 and my_number <= 20 then
        self.boomCooldown = self.boomCooldown - (1 * dt)
        if self.boomCooldown < 0 then
            self.canBoom = true
        end

        self.fireCooldown = self.fireCooldown - (1 * dt)
        if self.fireCooldown < 0 then
            self.canFire = true
        end

        self.berserkCooldown = self.berserkCooldown - (1 * dt)
        if self.berserkCooldown < 0 then
            self.canBerserk = true
        end

        self.goFastCooldown = self.goFastCooldown - (1 * dt)
        if self.goFastCooldown < 0 then
            self.canGoFast = true
            self.currentAcceleration = 0
        end

        self.burstCooldown = self.burstCooldown - (1 * dt)
        if self.burstCooldown < 0 then
            self.canBurst = true
        end
    end,
    updateIFrames = function(self, dt)
        if self.gotHit then
            self.iFrameSec = self.iFrameSec - (1 * dt)
            if self.iFrameSec <= 0 then
                self.gotHit = false
                self.iFrameSec = self.iFrameSecMax
            end
        end
    end,
    updateModeDurations = function(self, dt)
        if self.inBerserk then
            self.berserkDuration = self.berserkDuration - (1 * dt)
            self.berserkAlpha =
                0.5 * math.sin(2 * math.pi * (PLAYERRAW.berserkDuration - self.berserkDuration) - math.pi / 2) + 0.5
            if self.berserkDuration < 0 then
                self.inBerserk = false
                self.berserkDuration = PLAYERRAW.berserkDuration
            end
        end
        if self.inSonic then
            self.sonicDuration = self.sonicDuration - dt
            self:updateSonicRings(dt)
            if self.sonicDuration < 0 then
                self.inSonic = false
                self.sonicDuration = PLAYERRAW.sonicDuration
                -- clear rings table so rings are not seeable in next sonic mode call
                for i = 0, #self.sonicRings do
                    self.sonicRings[i] = nil
                end
            end
        end
    end,
    updateSonicRings = function(self, dt)
        local sonicRing = {
            x = self.x + 32, -- x of circle center
            y = self.y + 32, -- y of circle center
            dmg = 1,
            alpha = 1,
            radius = 80,
            duration = self.sonicRingMaxRuntime
        }
        table.insert(self.sonicRings, sonicRing)
        for i, ring in ipairs(self.sonicRings) do
            ring.duration = ring.duration - dt
            ring.alpha = ring.alpha - 1.5 * dt
            if ring.duration < 0 then
                table.remove(self.sonicRings, i)
            end
        end
    end,
    updateBooms = function(self, dt)
        for i, boom in ipairs(self.booms) do
            boom.anim:update(dt)
            if boom.dir == 1 then
                boom.y = boom.y - (350 * dt)
            else
                boom.y = boom.y + (350 * dt)
            end
            if (boom.y < 0) or (boom.y > WORLD.y) then
                table.remove(self.booms, i)
            end
        end
    end,
    updateFire = function(self, dt) --todo make non map specific, rather give duration that can be upgraded
        for i, fire in ipairs(self.fires) do
            if fire.dir == 1 then
                fire.y = fire.y - (25 * dt)
            else
                fire.y = fire.y + (25 * dt)
            end
            fire.time = fire.time - (1 * dt)
            if fire.time < 0 then
                table.remove(self.fires, i)
            end
        end
    end,
    --updateSelf = function(self,dt)
    --self.anim:update(dt)
    --end,
    getHit = function(self)
        if not self.gotHit then
            self.hearts = self.hearts - 1
            self.gotHit = true
            if self.hearts == 0 then
                self:die()
            end
        end
    end,
    die = function(self)
        self.alive = false
        GAMESTATE = 3
    end
}
