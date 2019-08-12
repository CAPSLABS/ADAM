return {
        hp = 1,
        dmg = 1,
        speed = 0.7,
        x = 0,
        y = 0,
        alive = true,
        reward = 1, --possibly function with variable reward?
        anim = nil,
        curAnim = "walking",
        dmgAnim = nil,
        --the approximate width and height of the goblin within 1 image
        width = 30, 
        height = 50,


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
            return baby
        end,

        getHit = function(self, dmg)
            self.hp=self.hp-dmg 
            if self.hp <= 0 then
                self:die()
                return "dead"
            else
                print("this is where i would display a dmg feedback animation")
                print("IF I HAD ONE")
            end

        end,

        die = function(self)
            if self.curAnim == "walking" then 
                self.curAnim = "dying"
                self.anim = anim8.newAnimation(self.media.imgGrid('1-7', 5), 0.07, "pauseAtEnd")
            end
        end,

        update = function(self,dt)
            self.anim:update(dt)
            if self.anim.status == "paused" then
                self.alive = false
            end
            
            if self.curAnim=="walking" then
                self.y = self.y + (self.speed*200*dt)
                if self.y > world.y then
                     self.alive = false
                     --todo: start attacking village thingy here instead
                     --of just dying lol
                end
            end
        end,
}