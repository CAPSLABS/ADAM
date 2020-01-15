return {
    name = "boss",
    hp = 200,
    dmg = 1,
    speed = 0.3,
    x = 0,
    y = 0,
    level = 0,
    alive = true,
    reward = 3, --possibly function with variable reward?
    anim = nil,
    iFrameSec = 0.27,
    iFrameSecMax = 0.27,
    --Intro Sequence: can be facingUp, facingLeft, charging, holdShield, shieldInFront, getAxe, swingLeft, swingRight
    --Later: walking, attack, dying, summoning
    curAnim = "facingUp",
    gotHit = false,
    -- spawn things
    timer = 0, -- changing variable for fireball spawning
    timerMax = 0.5, -- fixed spawn starting value
    lightningTimer = 0,
    lightningTimerMax = 2,
    --the approximate width and height of the boss (smaller then image)
    width = 30,
    height = 50,
    --the sprite begins ~15 pixels to the right of the image
    getLeftX = function(self)
        return self.x + 15
    end,
    getRightX = function(self)
        return self.x + 15 + self.width
    end,
    getTopY = function(self)
        return self.y + 15
    end,
    getBottomY = function(self)
        return self.y + 15 + self.height
    end,
    media = {
        img = "assets/enemies/trollking.png",
        imgGrid = nil,
        imgWidth = 64,
        imgHeight = 64
    },
    portrait = nil,
    portraitX = 7, -- x-th column in img for the portrait
    portraitY = 2, -- y-th row in img for the portrait
    --instantiator:
    newSelf = function(self, level)
        local baby = Shallowcopy(self)
        baby.x = WORLD.x / 2 - self.width
        baby.y = 150
        baby.anim = ANIMATE.newAnimation(self.media.imgGrid("1-1", 1), 2.2, "pauseAtEnd")
        baby.curAnim = "facingUp"
        baby.level = level
        return baby
    end,
    getHit = function(self, dmg, dt)
        if not self.gotHit then
            self.gotHit = true
            self.hp = self.hp - dmg
            if (self.hp <= 0) and (self.curAnim ~= "dying") then
                --make sure to not die while already in the process of dying
                self:die()
            end
        end
    end,
    drop = function(self)
        -- does not drop anything
    end,
    die = function(self)
        self.curAnim = "dying"
        if not WORLD.wonLevel then
            WORLD.player.money = WORLD.player.money + self.reward
            if
                WORLD.levels[WORLD.currentLvl].winType == "kill" and
                    WORLD.levels[WORLD.currentLvl].enemies.boss.killToWin and
                    (WORLD.levels[WORLD.currentLvl].enemies.boss.counter <
                        WORLD.levels[WORLD.currentLvl].enemies.boss.goal)
             then
                WORLD.levels[WORLD.currentLvl].enemies.boss.counter =
                    WORLD.levels[WORLD.currentLvl].enemies.boss.counter + 1
            end
        end
        self.anim = ANIMATE.newAnimation(self.media.imgGrid("1-6", 21), 0.3, "pauseAtEnd")
    end,
    update = function(self, dt)
        -- update animation
        self.anim:update(dt)

        -- Switch the animation if it is paused
        if self.anim.status == "paused" then
            if self.curAnim == "dying" then
                self.alive = false
            else
                self:dance(dt)
            end
        end

        -- spawn fireballs after certain duration as long as dancing has not stopped
        self.timer = self.timer + dt
        if self.timer >= self.timerMax then
            self:spawnFireballs()
            self.timer = 0
        end

        -- spawn lightning
        if self.curAnim == "charging" then
            -- while charging spawn lightning continuously faster
            self.lightningTimer = self.lightningTimer + dt
            if self.lightningTimer >= self.lightningTimerMax then
                WORLD.lightningActive = true
                self.lightningTimerMax = self.lightningTimerMax - (self.lightningTimer / 3)
                self.lightningTimer = 0
            end
        end

        -- what happens at each animation
        if (self.curAnim == "walking") then
            self.y = self.y + (self.speed * 200 * dt)
            if self.y > (WORLD.y - 190) then
                self.curAnim = "attack"
                self.anim = ANIMATE.newAnimation(self.media.imgGrid("1-6", 19), 0.3, "pauseAtEnd")
            end
        elseif (self.curAnim == "attack") and (self.anim.status == "paused") then
            WORLD.cityHealth = WORLD.cityHealth - self.dmg
            self.anim = ANIMATE.newAnimation(self.media.imgGrid("1-6", 19), 0.3, "pauseAtEnd")
        end

        if self.gotHit then
            self.iFrameSec = self.iFrameSec - (1 * dt)
            if self.iFrameSec <= 0 then
                self.gotHit = false
                self.iFrameSec = self.iFrameSecMax
            end
        end
    end,
    spawnFireballs = function(self)
        local newFireball =
            WORLD.statsRaw["fireball"]:newSelf(
            self.level,
            self.x,
            self.y
            --(self.media.imgHeight / 2)
        )
        table.insert(WORLD.enemies, newFireball)
    end,
    --everytime the cur. anim. is paused, we go to the next
    --dance class 101
    dance = function(self, dt)
        assert(self.anim.status == "paused", "boss:dance, animation was still playing, cannot switch to next")
        if self.curAnim == "facingUp" then
            -- if facingUp is paused, switch to look left animation
            self.anim = ANIMATE.newAnimation(self.media.imgGrid("1-1", 2), 1, "pauseAtEnd")
            self.curAnim = "facingLeft"
        elseif self.curAnim == "facingLeft" then
            -- switch from facingLeft to charging animation
            self.anim = ANIMATE.newAnimation(self.media.imgGrid("1-6", 3), 1, "pauseAtEnd")
            self.curAnim = "charging"
        elseif self.curAnim == "charging" then
            -- switch from charging to holdShield animation
            self.anim = ANIMATE.newAnimation(self.media.imgGrid("1-5", 7), {["1-1"] = 2, ["2-5"] = 0.2}, "pauseAtEnd")
            self.curAnim = "holdShield"
        elseif self.curAnim == "holdShield" then
            -- switch holdShield to shieldInFront animation
            self.anim = ANIMATE.newAnimation(self.media.imgGrid("6-6", 7), 1.3, "pauseAtEnd")
            self.curAnim = "shieldInFront"
        elseif self.curAnim == "shieldInFront" then
            -- switch shieldInFront to getAxe animation
            self.anim =
                ANIMATE.newAnimation(
                self.media.imgGrid("1-6", 15),
                {["1-2"] = 0, ["3-5"] = 0.05, ["6-6"] = 0.5},
                "pauseAtEnd"
            )
            self.curAnim = "getAxe"
            -- spawn one lightning
            WORLD.lightningActive = true
        elseif self.curAnim == "getAxe" then
            -- switch to swingLeft
            self.anim =
                ANIMATE.newAnimation(self.media.imgGrid("6-1", 14), {["6-2"] = 0.05, ["1-1"] = 0.1}, "pauseAtEnd")
            self.curAnim = "swingLeft"
        elseif self.curAnim == "swingLeft" then
            -- switch to swingRight
            self.anim =
                ANIMATE.newAnimation(self.media.imgGrid("6-1", 16), {["6-2"] = 0.05, ["1-1"] = 0.1}, "pauseAtEnd")
            self.curAnim = "swingRight"
        elseif self.curAnim == "swingRight" then
            -- switch to swingFront
            self.anim = ANIMATE.newAnimation(self.media.imgGrid("1-6", 15), {["1-5"] = 0.05, ["6-6"] = 1}, "pauseAtEnd")
            self.curAnim = "swingFront"
            -- spawn one lightning
            WORLD.lightningActive = true
        elseif self.curAnim == "swingFront" then
            -- switch to walking
            self.anim = ANIMATE.newAnimation(self.media.imgGrid("1-7", 11), 0.1, "pauseAtEnd")
            self.curAnim = "walking"
        elseif self.curAnim == "walking" then
            self.anim = ANIMATE.newAnimation(self.media.imgGrid("1-7", 11), 0.1, "pauseAtEnd")
        end
    end,
    drawDanceEffects = function(self)
        if self.curAnim == "facingLeft" then
            WORLD:drawScreenShake(-1, 1)
        elseif self.curAnim == "charging" then
            WORLD:drawScreenShake(-2, 2)
        elseif
            self.curAnim == "shieldInFront" or self.curAnim == "swingLeft" or self.curAnim == "swingRight" or
                self.curAnim == "swingFront"
         then
            WORLD:drawScreenShake(-2, 2)
        --WORLD:drawScreenShake(-2, 2)
        --WORLD:drawLightning(self.dt)
        end
        --TODO: continue
        --TODO: fix drawLightning
    end
}
