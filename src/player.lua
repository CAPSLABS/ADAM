return {
    -- basic stats:
    alive = true,
    hp = 1,
    money = 0, 
    speed = 200,
    --the approximate width and height of the character (smaller then image)
    width = 24,
    height= 45,

    --the sprite begins ~20 pixels to the right of the image
    getLeftX    = function(self) return self.x+20 end, 
    getRightX   = function(self) return self.x+20+self.width+3 end,
    getTopY     = function(self) return self.y+10 end, 
    getBottomY  = function(self) return self.y+10+self.height end,
    --start pos
    x = 200, 
    y = 700,
    dir = 1,  --1=up, 2=down
    --attacks:
    -- a
    boomCooldown = 0.5,
    canThrow = true,
    booms = {},
    -- s
    breathCooldown = 8,
    canBreath = true,
    fires = {},
    -- d
    berserkCooldown = 15,
    canBerserk = true,
    -- f 
    sonicCooldown = 10,
    canRunFast = true,
    sonicAcceleration = 10,
    currentAcceleration = 0,
    -- space
    burstCooldown = 2,
    canBurst = true,
    bursting = false,
    explosionMaxRuntime = 1,

    -- MODES
    fireDuration = 3,
    berserkDuration = 3,
    inBerserk = false,
    --
    sonicDuration = 2, 
    inSonic = false,

    media = {
        img = "assets/HeroScaled.png",

        boom = "assets/boomerang.png",

        fire = "assets/fireScaled.png",
        berserk = "assets/berserk.png",
    },

    moveLeft = function(self,dt)
        if (self:getLeftX()) > 0 then 
            if self.inSonic then
                self.x = self.x - (self.currentAcceleration * dt)
                self.currentAcceleration = self.currentAcceleration + self.sonicAcceleration
            else
                self.x = self.x - (self.speed*dt)
            end
        end
        self.anim:update(dt)
    end,

    moveRight = function(self,dt)
        if (self:getRightX()) < world.x then 
            if self.inSonic then
                self.x = self.x + self.currentAcceleration * dt
                self.currentAcceleration = self.currentAcceleration + self.sonicAcceleration
            else
                self.x = self.x + (self.speed*dt) 
            end
        end
        self.anim:update(dt)
    end,

    changeDirDown = function(self)
        if self.dir == 1 then
            self.dir=2
            self.anim = self.downAnim
        end
    end,

    changeDirUp = function(self)
        if self.dir == 2 then
            self.dir=1
            self.anim = self.upAnim
        end
    end, 

    --a
    throwBoom = function(self,dt)
        if self.inBerserk == false then
            if self.canThrow then 
                table.insert(self.booms, {anim = anim8.newAnimation(self.media.boomGrid('1-8',1), 0.01), x = self.x, y = self.y, dmg = 1, dir = self.dir})
                self.canThrow = false
                self.boomCooldown = playerRaw.boomCooldown
            end
        else --NO LIMITS WEEEEEEE 
            table.insert(self.booms, {anim = anim8.newAnimation(self.media.boomGrid('1-8',1), 0.01), x = self.x, y = self.y, dmg = 1, dir = self.dir})
        end
    end,

    --s
    spitFire = function(self)
        if self.dir == 1 then
            yOffset = 370
        else 
            yOffset = -420
        end

        local newFire = {img = self.media.fire, 
                        time=self.fireDuration, 
                        x = self.x - 40, 
                        y = self.y - yOffset, 
                        width= self.media.fire:getWidth(),
                        height=self.media.fire:getHeight(),
                        dmg = 2,
                        dir = self.dir}
        table.insert(self.fires, newFire)
        self.canBreath=false
        self.breathCooldown = playerRaw.breathCooldown
    end,

    --d
    goBerserk = function(self,dt)
        self.inBerserk=true
        self.canBerserk=false
        self.berserkCooldown = playerRaw.berserkCooldown
    end,

    --f
    gottaGoFast = function(self,dt)
        self.inSonic = true
        self.canRunFast = false
        self.sonicCooldown = playerRaw.sonicCooldown
    end,

    --space
    burst = function(self,dt)
        self.bursting = true
        self.canBurst = false
        self.burstCooldown = playerRaw.burstCooldown
    end,

    updateCooldowns = function(self,dt)
        --TODO underflow protection needed y/N? 
        -- possibly check if between max and 0 before calculations?
        --if my_number >= 1 and my_number <= 20 then
        self.boomCooldown = self.boomCooldown - (1 * dt)
        if self.boomCooldown < 0 then
            self.canThrow = true
        end

        self.breathCooldown = self.breathCooldown - (1 * dt)
        if self.breathCooldown < 0 then
            self.canBreath = true
        end

        self.berserkCooldown = self.berserkCooldown - (1 * dt)
        if self.berserkCooldown < 0 then
            self.canBerserk = true
        end

        self.sonicCooldown = self.sonicCooldown - (1 * dt)
        if self.sonicCooldown < 0 then
            self.canRunFast = true
        end

        self.burstCooldown = self.burstCooldown - (1 * dt)
        if self.burstCooldown < 0 then
            self.canBurst = true
        end

    end, 

    updateModeDurations =function(self,dt)
        if self.inBerserk then
            self.berserkDuration = self.berserkDuration - (1*dt)
            if self.berserkDuration < 0 then
                self.inBerserk=false
                self.berserkDuration = playerRaw.berserkDuration
            end
        end
        if self.inSonic then
            self.sonicDuration = self.sonicDuration - dt
            if self.sonicDuration < 0 then
                self.inSonic = false
                self.sonicDuration = playerRaw.sonicDuration
            end
        end
    end,

    updateBooms = function(self,dt)
        for i, boom in ipairs(self.booms) do
            boom.anim:update(dt)
            if boom.dir == 1 then
                boom.y = boom.y - (350 * dt)
            else
                boom.y = boom.y + (350 * dt)
            end

            if (boom.y < 0) or (boom.y > world.y) then 
                table.remove(self.booms, i)
            end
        end
    end,

    updateFire = function(self,dt) --todo make non map specific, rather give duration that can be upgraded
        for i , fire in ipairs(self.fires) do
            if fire.dir == 1 then
                fire.y = fire.y - (25 * dt)
            else 
                fire.y = fire.y + (25 * dt)
            end
            fire.time = fire.time - (1*dt)
            if fire.time < 0 then
                table.remove(self.fires, i)
            end
        end
    end,

    --updateSelf = function(self,dt)
        --self.anim:update(dt)
    --end,

    die = function(self)
        self.alive = false
        gamestate = 3

    end
}   
