return {
    hp = 1,
    dmg = 1,
    speed = 0.7,
    x = 0,
    y = 0,
    alive = true,
    reward = 1, --possibly function with variable reward?
    anim = nil,
    --curAnim, can be walking or dying  
    gotHit = false,
    --the approximate width and height of the goblin within 1 image
    width = 30, 
    height = 50,

    iFrameSec = 0.1,
    iFrameSecMax = 0.1,

    --the sprite begins ~15 pixels to the right of the image
    getLeftX    = function(self) return self.x+15 end, 
    getRightX   = function(self) return self.x+15+self.width+5 end,
    getTopY     = function(self) return self.y end, 
    getBottomY  = function(self) return self.y+self.height end,
    media = {
            img = 'assets/goblinSword.png',
            imgWidth = 65,
            imgHeight = 64,
    },
    
    --instantiator:
    newSelf =function(self)
        baby=shallowcopy(self)
        baby.x = math.random(0, (world.x - self.width)) -- substracting width avoids clipping out to the right
        baby.anim = anim8.newAnimation(self.media.imgGrid('1-7', 1), 0.07)
        baby.curAnim = "walking"
        return baby
    end,

    getHit = function(self, dmg, dt)
        if not self.gotHit then
            self.gotHit=true
            self.hp=self.hp-dmg 
            if (self.hp <= 0) and (self.curAnim == "walking") then
                self:die()
            end
        end
    end,

    die = function(self)
        self.curAnim = "dying"
        self.anim = anim8.newAnimation(self.media.imgGrid('1-7', 5), 0.05, "pauseAtEnd")
    end,

    update = function(self,dt)
        self.anim:update(dt)
        if (self.anim.status == "paused") and (self.curAnim == "dying") then
            self.alive = false
        end

        if self.curAnim=="dying" then
            self.y = self.y + (self.speed*150*dt)
        end
        
        if self.curAnim=="walking" then
            self.y = self.y + (self.speed*200*dt)
            if self.y > world.y then
                 self.alive = false
                 --todo: start attacking village thingy here instead
                 --of just dying lol
            end
        end

        if self.gotHit then
            self.iFrameSec = self.iFrameSec - (1*dt)
            if self.iFrameSec <= 0 then
                self.gotHit  = false
                self.iFrameSec = self.iFrameSecMax
            end
        end
    end, 
}