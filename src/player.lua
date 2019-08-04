return {
    scale=0.3,
    -- basic stats:
    alive = true,
    hp = 1,
    money = 0, 
    speed = 200,
    --start pos
    x = 200, 
    y = 700,
    direction = "up",
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

    -- MODES
    fireDuration = 3,
    berserkDuration = 3,
    inBerserk = false,
    --
    sonicDuration = 3, 
    inSonic = false,

    media = {
        img = "assets/HeroFull.png",
            
        boom = "assets/boomerang.png",
        fire = "assets/fire.png",

        berserk = "assets/berserk.png",
    },


    moveLeft = function(self,dt)
        if self.x > 0 then --TODO better check left side of sized player
            self.x = self.x - (self.speed*dt)
        end
    end,

    moveRight = function(self,dt)
        if (self.x + self.media.img:getWidth()*self.scale) < env.x then --TODO check right side of sized self
           self.x = self.x + (self.speed*dt) 
        end
    end,

    --a
    throwBoom = function(self,dt)
        if self.inBerserk == false then
            if self.canThrow then 
                table.insert(self.booms, {anim = anim8.newAnimation(self.media.boomGrid('1-8',1), 0.01), x = self.x, y = self.y})
                self.canThrow = false
                self.boomCooldown = playerRaw.boomCooldown
            end
        else --NO LIMITS WEEEEEEE (maaaaybe we should reduce this to once per frame/dt at least?)
            table.insert(self.booms, {anim = anim8.newAnimation(self.media.boomGrid('1-8',1), 0.01), x = self.x, y = self.y})
        end
    end,

    --s
    spitFire = function(self,dt)
        --TODO self should have leftside/middle/rightside functions for such things and collision 
        -- and not calculate image width here
        table.insert(self.fires, {img = self.media.fire, time=self.fireDuration, x = self.x + (self.media.img:getWidth()/2)-140, y = self.y-300})
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
        --TODO implement

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

        --TODO sonic mode
    end, 

    updateModeDurations =function(self,dt)
        if self.inBerserk then
            self.berserkDuration = self.berserkDuration - (1*dt)
            if self.berserkDuration < 0 then
                self.inBerserk=false
                self.berserkDuration = playerRaw.berserkDuration
            end
        end
        --TODO sonic mode

    end,


    updateBooms = function(self,dt)
        for i, boomerang in ipairs(self.booms) do
            boomerang.anim:update(dt)
            boomerang.y = boomerang.y - (350 * dt)

            if boomerang.y < 0 then 
                table.remove(self.booms, i)
            end
        end
    end,

    updateFire = function(self,dt) --todo make non map specific, rather give duration that can be upgraded
        for i , fire in ipairs(self.fires) do
            fire.y = fire.y - (20 * dt)
            fire.time = fire.time - (1*dt)
            if fire.time < 0 then
                table.remove(self.fires, i)
            end
        end
    end,

    updateSelf = function(self,dt)
        self.anim:update(dt)
    end,

    die = function(self)
        self.alive = false
        gamestate = 3

    end
}   
