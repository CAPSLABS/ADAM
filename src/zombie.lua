return {
    hp = 10,
    dmg = 3,
    speed = 0.2,
    x = 0,
    y = 0,
    alive = true,
    reward = 3, --possibly function with variable reward?
    anim = nil,
    takingDmg = false, --TODO add iFrames and redBlink
    curAnim = "leftPump",
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

    getHit = function(self, dmg)
      self.hp=self.hp-dmg 
      if self.hp <= 0 then
        self:die()
      else

        --print("this is where i would display a dmg feedback animation")
        --print("IF I HAD ONE")
      end

    end,

    die = function(self)
    --ok, so its kinda hard to replace the animation with dying
    --and continue with the logic straight away
    --you need to be alive to not get removed 
    --so, you could set alive to sth like "dying", a third state
    --during dying, should collisison happen with boomerangs?
    --with other goblins?
    --during updating the animation, we need to check
    --if the animation is of a dying goblin, and when its on its last
    --dying frame, set alive to false
    --and then not collision checks if Gob is dead, but rather
    --the general update
      self.alive = false
      self.anim = anim8.newAnimation(self.media.imgGrid('1-7',3), 0.1)
    end,

    update = function(self,dt) 
        self.anim:update(dt)
        if self.anim.status == "paused" then
            self:dance()
        end
        if self.alive and self.curAnim == "walking" then
            self.y = self.y + (self.speed*200*dt)
            if self.y > world.y then
                self.alive = false
            --todo: start attacking village thingy here instead of just dying lol
            end
        end
    end,

    
    --everytime the cur. anim. is paused, we go to the next 
    --animations: left pump -> right pump -> star shape -> start walking towards player 
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