return {
    hp = 8,
    dmg = 5,
    speed = 0.2,
    x = 0,
    y = 0,
    alive = true,
    reward = 3, --possibly function with variable reward?
    anim = nil,
    iFrameSec = 0.75,
    iFrameSecMax = 0.75,
    curAnim = "leftPump", --can be walking, dying, leftPump, rightPump, star 
    gotHit = false,
    --the approximate width and height of a zombie (smaller then image)
    width = 30, 
    height = 50,
    
    --the sprite begins ~15 pixels to the right of the image
    getLeftX    = function(self) return self.x+15 end, 
    getRightX   = function(self) return self.x+15+self.width end,
    getTopY     = function(self) return self.y+15 end, 
    getBottomY  = function(self) return self.y+15+self.height end,


    media = {
        img = 'assets/zombie.png',
        imgWidth = 64,
        imgHeight = 64,
    },
    
    --instantiator:
    newSelf =function(self)
        baby=shallowcopy(self)
        baby.x = math.random(0, (world.x - self.width)) -- substracting width avoids clipping out to the right
        baby.anim = anim8.newAnimation(self.media.imgGrid('2-7',7), 0.08, "pauseAtEnd")
        return baby
    end,


    getHit = function(self, dmg, dt)
        if not self.gotHit then
            self.gotHit=true
            self.hp=self.hp-dmg 
            if (self.hp <= 0) and (self.curAnim ~= "dying") then
                --make sure to not die while already in the process of dying
                self:die()
            end
        end
    end,

    die = function(self)
        self.curAnim = "dying"
        self.anim = anim8.newAnimation(self.media.imgGrid('1-6',21), 0.3, "pauseAtEnd")
    end,

    update = function(self,dt) 
        self.anim:update(dt)
        if self.anim.status == "paused" then
            if self.curAnim == "dying" then
                self.alive = false
            else
                self:dance()
            end
        end
        if (self.curAnim=="walking") then
            self.y = self.y + (self.speed*200*dt)
            if self.y > (world.y-190) then
                self.curAnim = "attack"
                self.anim = anim8.newAnimation(self.media.imgGrid('1-6', 19), 0.3, "pauseAtEnd")
            end
        elseif (self.curAnim=="attack") and (self.anim.status == "paused") then
            world.cityHealth=world.cityHealth-self.dmg
            self.anim = anim8.newAnimation(self.media.imgGrid('1-6', 19), 0.3,"pauseAtEnd")
        end
        
        if self.gotHit then
            self.iFrameSec = self.iFrameSec - (1*dt)
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
            self.anim = anim8.newAnimation(self.media.imgGrid('2-7',7), 0.08, "pauseAtEnd"):flipH()
            self.curAnim="rightPump"
        elseif self.curAnim == "rightPump" then
            self.anim = anim8.newAnimation(self.media.imgGrid('1-7',3), 0.2, "pauseAtEnd")
            self.curAnim = "star"
        elseif self.curAnim == "star" then
            self.anim = anim8.newAnimation(self.media.imgGrid('1-9',11), 0.1)
            self.curAnim = "walking"
        end
    end,
}