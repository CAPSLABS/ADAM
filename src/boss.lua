return {
    name = "boss",
    hp = 10,
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
    intro = true,
    -- spawn things
    fireballCount = 0,
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
    ------------ GENERAL INTERFACE ------------

    newSelf = function(self, level)
        local baby = Shallowcopy(self)
        baby.x = WORLD.x / 2 - self.width
        baby.y = 150
        baby.anim = ANIMATE.newAnimation(self.media.imgGrid("1-1", 1), 2.2, "pauseAtEnd")
        baby.curAnim = "facingUp"
        baby.level = level
        WORLD.spawn = false -- stop the spawning of enemies
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

        if self.intro then
            self:updateIntroShit(dt)
        else
            self:bossAI(dt)
        end

        -- check iFrames
        if self.gotHit then
            self:updateIFrames(dt)
        end
    end,
    ------------ INTRO STUFF ------------

    updateIntroShit = function(self, dt)
        -- Switch the animation if it is paused
        if self.anim.status == "paused" then
            if self.curAnim == "dying" then
                self.alive = false
            else
                -- TODO: this is only off for debugging
                --self:dance(dt)
                -- TODO: remove this after finishing AI
                self.intro = false
                self.curAnim = "idle"
            end
        end
        -- spawn fireballs after certain duration as long as dancing has not stopped
        self.statemachine["spawnFireballs"]:spawnFireballs(dt, self)

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
    end,
    updateIFrames = function(self, dt)
        self.iFrameSec = self.iFrameSec - (1 * dt)
        if self.iFrameSec <= 0 then
            self.gotHit = false
            self.iFrameSec = self.iFrameSecMax
        end
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
            -- switch to idle (which switches to boss AI)
            self.anim = ANIMATE.newAnimation(self.media.imgGrid("1-7", 11), 0.1, "pauseAtEnd")
            self.curAnim = "idle"
            self.intro = false
        end
    end,
    ------------ BOSS AI ------------
    -- Boss actions: idle, jump, spawnFireballs, throwFireballs, spawnLightning, summonEnemies
    -- Initially boss is idle. Rules are:
    -- if idle, then if fireballs there     -> 0% idle, 20% jump, 0% spawnFireballs, 50% throwFireballs, 15% spawnLightning, 15% summonEnemies
    -- if jumped                            -> 20% idle, 10% jump, 20% spawnFireballs, 0% throwFireballs, 25% spawnLightning, 25% summonEnemies
    -- if spawnFireballs                    -> 15% idle, 15% jump, 10% spawnFireballs, 60% throwFireballs, 0% spawnLightning, 0% summonEnemies
    -- if throwFireballs                    -> 0% idle, 30% jump, 20% spawnFireballs, 0% throwFireballs, 25% spawnLightning, 25% summonEnemies
    -- if spawnLightning                    -> 20% idle, 20% jump, 20% spawnFireballs, 20% throwFireballs, 0% spawnLightning, 20% summonEnemies
    -- if summonEnemies                     -> 40% idle, 0% jump, 25% spawnFireballs, 0% throwFireballs, 0% spawnLightning, 35% summonEnemies
    statemachine = {
        -- each state has multiple transitions {probability, nextAction} where probability is the probability
        -- that nextAction will be selected as the next action, and an animation() function choosing the fitting animation
        idle = {
            {0.2, "jump"},
            {0.5, "throwFireballs"},
            {0.15, "spawnLightning"},
            {0.15, "summonEnemies"},
            loopCounter = 0,
            animation = function(self, grid) -- must return an animation
                return ANIMATE.newAnimation(
                    grid("1-2", 15),
                    0.3,
                    function(anim, loops)
                        self.loopCounter = self.loopCounter + loops
                        if self.loopCounter >= 4 then
                            self.loopCounter = 0
                            anim:pauseAtEnd()
                        end
                    end
                )
            end,
            update = function(self, _, boss)
                -- don't change position, just return old position
                return {boss.x, boss.y}
            end
        },
        jump = {
            {0.2, "idle"},
            {0.1, "jump"},
            {0.2, "spawnFireballs"},
            {0.25, "spawnLightning"},
            {0.25, "summonEnemies"},
            animation = function(self, grid)
                return ANIMATE.newAnimation(grid("1-6", 15), {["1-5"] = 0.05, ["6-6"] = 1}, "pauseAtEnd")
            end,
            selectedTargetPoint = false,
            targetX = 0,
            targetY = 0,
            computedApex = false,
            apexX = 0,
            interpolationFactor = 0,
            update = function(self, dt, boss)
                -- select target point
                if not self.selectedTargetPoint then
                    self.targetX = math.random(100, 380)
                    self.targetY = math.random(100, 630)
                    self.selectedTargetPoint = true
                end
                -- compute apex point which is of form (x,0)
                if not self.computedApex then
                    self.apexX = (self.targetX + boss.x) / 2
                    self.computedApex = true
                end
                -- compute new positions according to bezier curve of second order (which is a parable)
                if self.selectedTargetPoint and self.computedApex then
                    local newBossCoords = {0, 0}
                    self.interpolationFactor = self.interpolationFactor + 0.4 * dt
                    if self.interpolationFactor <= 1 then
                        -- still within jump: compute new boss coords
                        newBossCoords[1] =
                            (boss.x - 2 * self.apexX + self.targetX) * self.interpolationFactor ^ 2 +
                            2 * (self.apexX - boss.x) * self.interpolationFactor +
                            boss.x
                        -- NOTE: since we always choose apexY = 0, this formula is the simplified version of the above formula
                        newBossCoords[2] =
                            (boss.y + self.targetY) * self.interpolationFactor ^ 2 +
                            -2 * boss.y * self.interpolationFactor +
                            boss.y
                    else
                        -- jump over, reset values, new coords are where we already are
                        self.selectedTargetPoint = false
                        self.computedApex = false
                        self.interpolationFactor = 0
                        newBossCoords[1] = boss.x
                        newBossCoords[2] = boss.y
                    end
                    return newBossCoords
                else
                    return {boss.x, boss.y}
                end
            end
        },
        spawnFireballs = {
            {0.15, "idle"},
            {0.15, "jump"},
            {0.1, "spawnFireballs"},
            {0.6, "throwFireballs"},
            timer = 0,
            timerMax = 0.48,
            fireballCount = 0,
            animation = function(self, grid)
                return ANIMATE.newAnimation(grid("1-6", 3), 1, "pauseAtEnd")
            end,
            spawnFireballs = function(self, dt, boss)
                self.timer = self.timer + dt
                if self.timer >= self.timerMax then
                    local newFireball = WORLD.statsRaw["fireball"]:newSelf(self.level, boss.x, boss.y)
                    table.insert(WORLD.enemies, newFireball)
                    self.timer = 0
                end
            end,
            update = function(self, dt, boss)
                self:spawnFireballs(dt, boss)
                boss.fireballCount = boss.fireballCount + 1
                return {boss.x, boss.y}
            end
        },
        throwFireballs = {
            {0.3, "jump"},
            {0.2, "spawnFireballs"},
            {0.25, "spawnLightning"},
            {0.25, "summonEnemies"},
            alreadyThrown = false, -- needed to stop throwing fireballs every time update is called
            animation = function(self, grid)
                self.alreadyThrown = false
                return ANIMATE.newAnimation(grid("1-13", 19), 0.2, "pauseAtEnd")
            end,
            update = function(self, dt, boss)
                if boss.fireballCount >= 1 and not self.alreadyThrown then
                    for i, enemy in ipairs(WORLD.enemies) do
                        local tmp = math.random()
                        if enemy.name == "fireball" and tmp <= 0.6 then
                            enemy.curAnim = "targeting"
                            boss.fireballCount = boss.fireballCount - 1
                        end
                    end
                    self.alreadyThrown = true
                end
                return {boss.x, boss.y}
            end
        },
        spawnLightning = {
            {0.2, "idle"},
            {0.2, "jump"},
            {0.2, "spawnFireballs"},
            {0.2, "throwFireballs"},
            {0.2, "summonEnemies"},
            animation = function(self, grid)
                if math.random() >= 0.5 then
                    return ANIMATE.newAnimation(grid("6-9", 10), 0.1, "pauseAtEnd")
                else
                    return ANIMATE.newAnimation(grid("6-9", 12), 0.1, "pauseAtEnd")
                end
            end,
            update = function(self, dt, boss)
                WORLD.lightningActive = true
                return {boss.x, boss.y}
            end
        },
        summonEnemies = {
            {0.4, "idle"},
            {0.25, "spawnFireballs"},
            {0.35, "summonEnemies"},
            animation = function(self, grid)
                return ANIMATE.newAnimation(grid("1-6", 13), {["1-5"] = 0.3, ["6-6"] = 1}, "pauseAtEnd")
            end,
            update = function(self, dt, boss)
                WORLD.spawn = true
                return {boss.x, boss.y}
            end
        },
        dying = {
            animation = function(self, grid)
                return ANIMATE.newAnimation(
                    grid("1-6", 21),
                    {["1-2"] = 0.5, ["3-4"] = 0.7, ["5-5"] = 1.1, ["6-6"] = 1.5},
                    "pauseAtEnd"
                )
            end,
            update = function(self, dt, boss)
                boss.alive = false
                return {boss.x, boss.y}
            end
        }
    },
    chooseNextAction = function(self)
        -- Edge case: Somehow it is possible to be dying when entering this function, in that case stay dead.
        -- Don't rise from the dead. Get some help.
        if self.curAnim == "dying" then
            WORLD.spawn = false
            return "dying"
        end
        -- Throw random number, then check which transition it leads to
        local probability = math.random()
        local summedProbability = 0
        local nextState = ""
        for i, transitionInfo in ipairs(self.statemachine[self.curAnim]) do
            if
                type(transitionInfo) == "table" and type(transitionInfo[1]) == "number" and
                    type(transitionInfo[2]) == "string"
             then
                summedProbability = summedProbability + transitionInfo[1]
                assert(summedProbability <= 1, "bossAI:chooseNextAction, summedProbability was over 1")
                if probability <= summedProbability then
                    nextState = transitionInfo[2]
                    break
                end
            end
        end
        assert(nextState ~= "", "bossAI:chooseNextAction, nextState has not been found")
        -- the boss level normally does not spawn enemies. If it should, it is activated, and by this line deactivated again
        WORLD.spawn = false
        -- Set the corresponding animation for nextState
        self.anim = self.statemachine[nextState]:animation(self.media.imgGrid)
        return nextState
    end,
    bossAI = function(self, dt)
        if self.curAnim == "dying" then
            if self.anim.status == "paused" then
                -- He ded
                self.alive = false
                return
            else
                -- Switch the animation if it is paused
                self.curAnim = self:chooseNextAction()
            end
        else
            -- Update values
            local updatedValues = self.statemachine[self.curAnim]:update(dt, self)
            self.x = updatedValues[1]
            self.y = updatedValues[2]
        end
    end,
    ------------ DRAWING ------------

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
        elseif self.curAnim == "spawnFireballs" then
            WORLD:drawScreenShake(-1, 1)
        end
    end
}
