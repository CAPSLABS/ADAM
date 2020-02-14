return {
    -- basic stats:
    alive = true,
    hearts = 3,
    maxHearts = 3,
    startOfLvlMoney = 0,
    money = 0,
    speed = 230,
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
    anim = nil,
    upRightAnim = nil,
    upLeftAnim = nil,
    downAnim = nil,
    --start pos
    x = 200,
    y = 700,
    verticalDir = 1, --1=up, 2=down
    horizontalDir = 1, --1=left, 2=right
    --attacks:
    -- a
    boomLevel = 1,
    boomCooldown = 1,
    canBoom = true,
    booms = {},
    -- s
    fireLevel = 0,
    fireCooldown = 6,
    fireDuration = 3.5,
    canFire = true,
    fires = {},
    -- d
    berserkLevel = 0,
    berserkCooldown = 10,
    canBerserk = true,
    berserkDuration = 3,
    inBerserk = false,
    berserkAlpha = 0,
    -- f
    goFastLevel = 0,
    goFastCooldown = 12,
    canGoFast = true,
    sonicAcceleration = 12,
    currentAcceleration = 0,
    sonicRingMaxRuntime = 2,
    sonicRings = {},
    sonicDuration = 2,
    inSonic = false,
    -- space
    burstLevel = 0,
    burstCooldown = 20,
    canBurst = true,
    bursting = false,
    explosionMaxRuntime = 1.3,
    -- i frames
    gotHit = false,
    iFrameSec = 1.5,
    iFrameSecMax = 1.5,
    media = {
        img = "assets/cha_sprites/adam.png",
        boom = "assets/hud/boom/boomerang.png",
        fire = "assets/hud/fire/fireScaled.png",
        berserk = "assets/hud/berserk/berserk_smoke.png"
    },
    moveLeft = function(self, dt)
        self:setLeftAnim()
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
        self:setRightAnim()
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
    changeVerticalDirDown = function(self)
        if self.verticalDir == 1 then
            self.verticalDir = 2
            self.anim = self.downAnim
        end
    end,
    changeVerticalDirUp = function(self)
        if self.verticalDir == 2 then
            self.verticalDir = 1
            self.anim = self.upLeftAnim
        end
    end,
    setLeftAnim = function(self)
        if self.verticalDir == 1 then
            if self.horizontalDir == 2 then
                self.horizontalDir = 1
                self.anim = self.upLeftAnim
            end
        end
    end,
    setRightAnim = function(self)
        if self.verticalDir == 1 then
            if self.horizontalDir == 1 then
                self.horizontalDir = 2
                self.anim = self.upRightAnim
            end
        end
    end,
    --a
    throwBoom = function(self, dt)
        if not self.inBerserk then
            if self.canBoom then
                table.insert(
                    self.booms,
                    {
                        anim = ANIMATE.newAnimation(self.media.boomGrid("1-8", 1), 0.01),
                        x = self.x,
                        y = self.y,
                        dmg = 1,
                        verticalDir = self.verticalDir
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
                    verticalDir = self.verticalDir
                }
            )
        end
    end,
    --s
    spitFire = function(self)
        if self.fireLevel ~= 0 then
            local yOffset = 0
            if self.verticalDir == 1 then
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
                verticalDir = self.verticalDir
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
            WORLD.HUD.media.hudSkillBorder.a = WORLD.HUD.media.hud.silver
            WORLD.player.boomCooldown = WORLD.player.boomCooldown / 2
            PLAYERRAW.boomCooldown = PLAYERRAW.boomCooldown / 2
        elseif self.boomLevel == 3 then
            WORLD.HUD.media.hudSkillBorder.a = WORLD.HUD.media.hud.gold
            WORLD.player.boomCooldown = WORLD.player.boomCooldown / 2
            PLAYERRAW.boomCooldown = PLAYERRAW.boomCooldown / 2
        end
    end,
    lvlUpFire = function(self)
        self.fireLevel = self.fireLevel + 1
        if self.fireLevel == 2 then
            WORLD.HUD.media.hudSkillBorder.s = WORLD.HUD.media.hud.silver
            WORLD.player.fireCooldown = WORLD.player.fireCooldown / 2
            PLAYERRAW.fireCooldown = PLAYERRAW.fireCooldown / 2
        elseif self.fireLevel == 3 then
            WORLD.HUD.media.hudSkillBorder.s = WORLD.HUD.media.hud.gold
            WORLD.player.fireCooldown = WORLD.player.fireCooldown / 2
            PLAYERRAW.fireCooldown = PLAYERRAW.fireCooldown / 2
        end
    end,
    lvlUpBerserk = function(self)
        self.berserkLevel = self.berserkLevel + 1
        if self.berserkLevel == 2 then
            WORLD.HUD.media.hudSkillBorder.d = WORLD.HUD.media.hud.silver
            WORLD.player.berserkCooldown = WORLD.player.berserkCooldown / 2
            PLAYERRAW.berserkCooldown = PLAYERRAW.berserkCooldown / 2
        elseif self.berserkLevel == 3 then
            WORLD.HUD.media.hudSkillBorder.d = WORLD.HUD.media.hud.gold
            WORLD.player.berserkCooldown = WORLD.player.berserkCooldown / 2
            PLAYERRAW.berserkCooldown = PLAYERRAW.berserkCooldown / 2
        end
    end,
    lvlUpFast = function(self)
        self.goFastLevel = self.goFastLevel + 1
        if self.goFastLevel == 2 then
            WORLD.HUD.media.hudSkillBorder.f = WORLD.HUD.media.hud.silver
            WORLD.player.goFastCooldown = WORLD.player.goFastCooldown / 2
            PLAYERRAW.goFastCooldown = PLAYERRAW.goFastCooldown / 2
        elseif self.goFastLevel == 3 then
            WORLD.HUD.media.hudSkillBorder.f = WORLD.HUD.media.hud.gold
            WORLD.player.goFastCooldown = WORLD.player.goFastCooldown / 2
            PLAYERRAW.goFastCooldown = PLAYERRAW.goFastCooldown / 2
        end
    end,
    lvlUpBurst = function(self)
        self.burstLevel = self.burstLevel + 1
        if self.burstLevel == 2 then
            WORLD.HUD.media.hudSkillBorder.space = WORLD.HUD.media.hud.silver
            WORLD.player.burstCooldown = WORLD.player.burstCooldown / 2
            PLAYERRAW.burstCooldown = PLAYERRAW.burstCooldown / 2
        elseif self.burstLevel == 3 then
            WORLD.HUD.media.hudSkillBorder.space = WORLD.HUD.media.hud.gold
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
            self:throwBoom(dt)
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
            if boom.verticalDir == 1 then
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
            if fire.verticalDir == 1 then
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
        WORLD:selectDeathScreen()
        GAMESTATE = 3
    end,
    reset = function(self, moneyreset)
        if moneyreset then
            self.money = self.startOfLvlMoney
        end
        if self.inBerserk then
            self.inBerserk = false
            self.canBerserk = true
            self.berserkDuration = PLAYERRAW.berserkDuration
        end
        if self.inSonic then
            self.inSonic = false
            self.canGoFast = true
            self.sonicDuration = PLAYERRAW.sonicDuration
            self.currentAcceleration = PLAYERRAW.currentAcceleration
        end
        if self.bursting then
            self.bursting = false
            self.canBurst = true
            WORLD.exploding = false
        end
        self.fires = {}
        self.booms = {}
        self.sonicRings = {}
        self.gotHit = false
        self.iFrameSec = self.iFrameSecMax
        self.burstCooldown = PLAYERRAW.burstCooldown
        self.berserkCooldown = PLAYERRAW.berserkCooldown
        self.fireCooldown = PLAYERRAW.fireCooldown
        self.boomCooldown = PLAYERRAW.boomCooldown
        self.goFastCooldown = PLAYERRAW.goFastCooldown
    end,
    -- i know this seems to be an odd place for such a pretty function, but trust me, i can explain!
    buySpecialOffer = function(self)
        WORLD.cityHealth = WORLD.cityHealth + (WORLD.cityHealth * SHOP.wallPercMultiplier)
        if WORLD.cityHealth > WORLD.cityHealthMax then
            WORLD.cityHealth = WORLD.cityHealthMax
        end
        SHOP.clicked = true
        WORLD:updateHealth()
        return true
    end
}
