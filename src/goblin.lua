return {
    name = "goblin",
    hp = 1,
    dmg = 1,
    speed = 0.7,
    x = 0,
    y = 0,
    level = 0, -- level in which the goblin was spawned
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
        imgGrid = nil,
        imgWidth = 65,
        imgHeight = 64
    },
    portrait = nil,
    portraitX = 0, -- x-th row in img for the portrait
    portraitY = 0, -- y-th column in img for the portrait
    --instantiator:
    newSelf = function(self, level)
        local baby = Shallowcopy(self)
        baby.x = math.random(-self:getLeftX(), (WORLD.x - self:getRightX())) -- substracting width avoids clipping out to the right
        baby.anim = ANIMATE.newAnimation(self.media.imgGrid("1-7", 1), 0.07)
        baby.curAnim = "walking"
        baby.level = level
        return baby
    end,
    getHit = function(self, dmg)
        if not self.gotHit then
            self.gotHit = true
            self.hp = self.hp - dmg
            if (self.hp <= 0) and (self.curAnim ~= "dying") then --and (self.curAnim == "walking") then
                self:die()
            end
        end
    end,
    drop = function(self)
        local randomNumber = math.random()
        -- lvl 1: does not drop anything
        if self.level == 2 or self.level == 4 then
            -- lvl 2 or lvl 4: only drops hearts with probability 4%
            if randomNumber <= 0.03 then
                WORLD:dropHeart(self)
            end
        elseif self.level == 3 then
            -- lvl 3: hearts probability 4%, hint probability 10%
            if randomNumber <= 0.03 then
                WORLD:dropHeart(self)
            elseif 0.03 < randomNumber and randomNumber <= 0.19 then
                WORLD:dropHint(self)
            end
        elseif self.level == 5 or self.level == 6 then
            -- lvl 5: higher spawn rate of hearts, 10 %
            if randomNumber <= 0.1 then
                WORLD:dropHeart(self)
            end
        end
    end,
    die = function(self)
        self.curAnim = "dying"
        self.anim = ANIMATE.newAnimation(self.media.imgGrid("1-7", 5), 0.06, "pauseAtEnd")
        -- should point to menu, make sure - Menu is always the last level
        -- TODO: make flag to where one can read when we are in a menu
        if WORLD.currentLvl ~= #WORLD.levels then
            if not WORLD.wonLevel then
                WORLD.player.money = WORLD.player.money + self.reward
                if
                    WORLD.levels[WORLD.currentLvl].winType == "kill" and
                        WORLD.levels[WORLD.currentLvl].enemies.goblin.killToWin and
                        (WORLD.levels[WORLD.currentLvl].enemies.goblin.counter <
                            WORLD.levels[WORLD.currentLvl].enemies.goblin.goal)
                 then
                    WORLD.levels[WORLD.currentLvl].enemies.goblin.counter =
                        WORLD.levels[WORLD.currentLvl].enemies.goblin.counter + 1
                end
            end
        end
    end,
    update = function(self, dt)
        self.anim:update(dt)
        if (self.anim.status == "paused") and (self.curAnim == "dying") then
            self.alive = false
        elseif self.curAnim == "dying" then
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
