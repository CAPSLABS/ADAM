return {
    hp = 1,
    dmg = 1,
    speed = 0.7,
    x = 0,
    y = 0,
    alive = true,
    reward = 1, --possibly function with variable reward?
    anim = nil,
    --curAnim, can be walking, dying, attacking
    gotHit = false,
    --the approximate width and height of the goblin within 1 image
    width = 30,
    height = 50,
    iFrameSec = 0.2,
    iFrameSecMax = 0.2,
    --the sprite begins ~15 pixels to the right of the image
    getLeftX = function(self)
        return self.x + 15
    end,
    getRightX = function(self)
        return self.x + 15 + self.width + 5
    end,
    getTopY = function(self)
        return self.y
    end,
    getBottomY = function(self)
        return self.y + self.height
    end,
    media = {
        img = "assets/goblinSword.png",
        imgWidth = 65,
        imgHeight = 64
    },
    --instantiator:
    newSelf = function(self)
        local baby = Shallowcopy(self)
        baby.x = math.random(-self:getLeftX(), (WORLD.x - self:getRightX())) -- substracting width avoids clipping out to the right
        baby.anim = ANIMATE.newAnimation(self.media.imgGrid("1-7", 1), 0.07)
        baby.curAnim = "walking"
        return baby
    end,
    getHit = function(self, dmg)
        STORY:printNextLine()
        if not self.gotHit then
            self.gotHit = true
            self.hp = self.hp - dmg
            if (self.hp <= 0) and (self.curAnim ~= "dying") then --and (self.curAnim == "walking") then
                self:die()
            end
        end
    end,
    die = function(self)
        self.curAnim = "dying"
        self.anim = ANIMATE.newAnimation(self.media.imgGrid("1-7", 5), 0.06, "pauseAtEnd")
        -- should point to menu, make sure
        if WORLD.currentLvl ~= 3 then
            if not WORLD.wonLevel then
                WORLD.player.money = WORLD.player.money + self.reward
                WORLD.levels[WORLD.currentLvl].enemies.goblin.killCounter =
                    WORLD.levels[WORLD.currentLvl].enemies.goblin.killCounter + 1
            end
        end
    end,
    update = function(self, dt)
        self.anim:update(dt)
        if (self.anim.status == "paused") and (self.curAnim == "dying") then
            self.alive = false
        elseif self.curAnim == "dying" then
            --print("goblin:update, was not paused and dying, so i am slowly")
            self.y = self.y + (self.speed * 50 * dt)
        elseif self.curAnim == "walking" then
            self.y = self.y + (self.speed * 200 * dt)
            if self.y > (WORLD.y - 190) then
                self.curAnim = "attack"
                self.anim = ANIMATE.newAnimation(self.media.imgGrid("7-10", 1), 0.3, "pauseAtEnd")
            end
        elseif (self.curAnim == "attack") and (self.anim.status == "paused") then
            WORLD.cityHealth = WORLD.cityHealth - self.dmg
            self.anim = ANIMATE.newAnimation(self.media.imgGrid("7-10", 1), 0.3, "pauseAtEnd")
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
