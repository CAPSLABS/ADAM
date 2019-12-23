return {
    player = nil,
    -- all enemies currently on the field
    enemies = {},
    -- all dropped items currently on the field
    drops = {},
    x = 32 * 15,
    y = 32 * 30,
    currentLvl = nil,
    runtime = 0,
    -- true if explosion animation runs
    exploding = false,
    -- true if current level condition has been satisfied
    wonLevel = false,
    -- Counts keypress after level has been won. Advance to next level if this is >= 0.
    continueButton = nil,
    cityHealthMax = 100,
    cityHealth = 100,
    healthPerc = 1,
    media = {
        defaultfont = nil,
        fantasyfont = nil,
        bigfantasyfont = nil,
        surprise = {
            img = "assets/what.jpg"
        },
        hud = {
            berserk = "assets/hud/berserk/berserk.png",
            berserkUsed = "assets/hud/berserk/berserkUsed.png",
            boom = "assets/hud/boom/boom64.png",
            boomUsed = "assets/hud/boom/boom64used.png",
            explo = "assets/hud/explo/explo.png",
            exploUsed = "assets/hud/explo/exploUsed.png",
            fast = "assets/hud/fast/fast.png",
            fastUsed = "assets/hud/fast/fastUsed.png",
            fire = "assets/hud/fire/fire.png",
            fireUsed = "assets/hud/fire/fireUsed.png",
            healthFrame = "assets/hud/healthbar/healthFrame.png",
            health = "assets/hud/healthbar/health.png",
            heart = "assets/hud/healthbar/heart.png",
            money = "assets/hud/money/coin.png",
            a = "assets/hud/controls/a.png",
            s = "assets/hud/controls/s.png",
            d = "assets/hud/controls/d.png",
            f = "assets/hud/controls/f.png",
            space = "assets/hud/controls/space.png",
            brown = "assets/hud/border/brown.png",
            silver = "assets/hud/border/silver.png",
            gold = "assets/hud/border/gold.png",
            border = "assets/hud/border/border.png",
            borderSmall = "assets/hud/border/border384.png"
        },
        hudSkillBorder = {
            a = nil,
            s = nil,
            d = nil,
            f = nil,
            space = nil
        },
        hudPos = {
            --SKILLS:
            xOffset = 30,
            yOffset = 850,
            skillDistance = 90,
            healthX = 100,
            healthY = 920,
            moneyX = 310,
            moneyY = 5,
            heartX = -50,
            heartY = 5,
            heartDistance = 40,
            letterX = 35,
            letterY = 855,
            letterDistance = 90,
            -- KILL COUNTERS
            counterX = 420,
            counterY = 110
        },
        explosion = {
            img = "assets/explosion.png",
            runtime = 0,
            maxRuntime = 1.3,
            scale = 0,
            scaledWidth = 0,
            scaledHeight = 0,
            shakeMagnitude = 5
        }
        --items = {
        --    heart = "assets/hud/healthbar/heart_cropped.png"
        --}
    },
    levels = {
        --level1
        {
            mapPath = "ebene1tilemap",
            enemies = {
                goblin = {
                    killCounter = 0, -- counts how many goblins have been murdered in this level
                    killGoal = 1, -- counts how many goblins we need to murder in this level
                    killToWin = true, -- defeating goblins is necessary to win
                    timer = 0.4, -- inital value is value of timerMax, a changing variable
                    timerMax = 0.4, -- initial value until first mob comes, marks the actual countdown time
                    spawnFct = function(self, runtime)
                        -- returns the next timerMax value (waiting time until next goblin spawns)
                        -- Sigmoid mirrored on y axis shifted by 2 along x axis
                        -- Reaches timer = 0.51 in ~46 seconds
                        return (1 / (1 + math.exp(0.1 * runtime))) + 0.5
                    end
                }
            },
            --winType = "kill", -- We win by killing goblins
            winType = "endure",
            runtimeGoal = 10,
            --winCondition = function(self, dt)
            --    if self.enemies.goblin.killCounter >= self.enemies.goblin.killGoal then
            --        return true
            --    end
            --    return false
            --end
            winCondition = function(self, runtime, dt)
                if runtime >= self.runtimeGoal then
                    return true
                end
                return false
            end
        },
        --level 2
        {
            mapPath = "ebene2tilemap",
            cityHealthMax = 100,
            cityHealth = 100,
            enemies = {
                goblin = {
                    timer = 0.2,
                    timerMax = 0.2,
                    killCounter = 0,
                    killGoal = 3,
                    killToWin = true,
                    spawnFct = function(self, runtime)
                        -- Sigmoid mirrored on y axis shifted up by 0.5 (minimum is 0.5)
                        -- Reaches timer = 0.51 in ~46 seconds
                        return (1 / (1 + math.exp(0.1 * runtime))) + 0.5
                    end
                },
                zombie = {
                    timer = 1,
                    timerMax = 1,
                    killCounter = 0,
                    killGoal = 1,
                    killToWin = true,
                    spawnFct = function(self, runtime)
                        -- Reaches timer = 1.51 in ~51 seconds
                        return (1 / (1 + math.exp(0.09 * runtime))) + 1.5
                    end
                }
            },
            winType = "kill", -- We win by killing zombies only
            winCondition = function(self, runtime, dt)
                if
                    self.enemies.goblin.killCounter >= self.enemies.goblin.killGoal and
                        self.enemies.zombie.killCounter >= self.enemies.zombie.killGoal
                 then
                    return true
                end
                return false
            end
        },
        --menu (always last)
        {
            mapPath = "ebene1tilemap",
            enemies = {
                goblin = {
                    timer = 0.0,
                    timerMax = 0.0,
                    spawnFct = function(self, runtime)
                        return 0.0
                    end
                }
            },
            winCondition = function(self, runtime, dt)
                return false
            end
        }
    },
    statsRaw = {
        goblin = require("src.goblin"),
        zombie = require("src.zombie")
    },
    itemsRaw = {
        items = require("src.items")
    },
    ------------ LOADING --------------

    --enemies are expected to implement:
    --media.img(filepath, string)
    --media width (the width of the enemy image in pixels, int)
    --media height (the height of the enemy image in pixels, int)
    loadEnemies = function(self)
        for key, enemy in pairs(self.statsRaw) do
            enemy.media.img = love.graphics.newImage(enemy.media.img)
            enemy.media.imgGrid =
                ANIMATE.newGrid(
                enemy.media.imgWidth,
                enemy.media.imgHeight,
                enemy.media.img:getWidth(),
                enemy.media.img:getHeight()
            )
            enemy.portrait =
                love.graphics.newQuad(
                enemy.media.imgWidth * enemy.portraitX,
                enemy.media.imgHeight * enemy.portraitY,
                enemy.media.imgWidth,
                enemy.media.imgHeight,
                enemy.media.img:getWidth(),
                enemy.media.img:getHeight()
            )
        end
    end,
    loadPlayer = function(self)
        for key, imgPath in pairs(self.player.media) do
            self.player.media[key] = love.graphics.newImage(imgPath)
        end
        self.player.media.boomGrid =
            ANIMATE.newGrid(48, 48, self.player.media.boom:getWidth(), self.player.media.boom:getHeight())
        self.player.media.playerGrid =
            ANIMATE.newGrid(64, 64, self.player.media.img:getWidth(), self.player.media.img:getHeight())
        self.player.upAnim = ANIMATE.newAnimation(self.player.media.playerGrid("1-4", 2), 0.1)
        self.player.downAnim = ANIMATE.newAnimation(self.player.media.playerGrid("1-4", 1), 0.1)
        self.player.anim = self.player.upAnim
    end,
    loadMedia = function(self)
        self.media.surprise.img = love.graphics.newImage(self.media.surprise.img)
        self.media.explosion.img = love.graphics.newImage(self.media.explosion.img)
        self.media.defaultfont = love.graphics.getFont()
        self.media.fantasyfont = love.graphics.newFont("assets/font/Komi.ttf", 15)
        self.media.bigfantasyfont = love.graphics.newFont("assets/font/Komi.ttf", 30)
    end,
    loadHud = function(self)
        for key, imgPath in pairs(self.media.hud) do
            self.media.hud[key] = love.graphics.newImage(imgPath)
        end
    end,
    loadItems = function(self)
        for key, item in pairs(self.itemsRaw.items) do
            item.img = love.graphics.newImage(item.img)
        end
    end,
    ------------ UPDATING --------------

    --enemies are expected to implement:
    --update(anim function)
    --alive (bool)
    --reward (int)
    updateEnemies = function(self, dt)
        for i, enemy in ipairs(self.enemies) do
            enemy:update(dt)
            if not enemy.alive then
                table.remove(self.enemies, i)
                enemy:drop()
            end
        end
    end,
    spawnEnemies = function(self, dt)
        self.runtime = self.runtime + dt
        for enemyName, enemySpawnInfo in pairs(self.levels[self.currentLvl].enemies) do
            enemySpawnInfo.timer = enemySpawnInfo.timer - dt
            if enemySpawnInfo.timer <= 0 then
                enemySpawnInfo.timerMax = enemySpawnInfo:spawnFct(self.runtime)
                local newEnemy = self.statsRaw[enemyName]:newSelf(self.currentLvl)
                table.insert(self.enemies, newEnemy)
                enemySpawnInfo.timer = enemySpawnInfo.timerMax
            end
        end
    end,
    upscaleExplosion = function(self, dt, maxRuntime)
        if self.media["explosion"].runtime + dt < maxRuntime then
            -- +0.1 needed, without it the scaling wouldn't start
            self.media["explosion"].scale = (self.media["explosion"].scale + 0.1) ^ self.media["explosion"].runtime
            self.media["explosion"].runtime = self.media["explosion"].runtime + dt
            self.media["explosion"].scaledWidth = self.media["explosion"].scale * self.media["explosion"].img:getWidth()
            self.media["explosion"].scaledHeight =
                self.media["explosion"].scale * self.media["explosion"].img:getHeight()
        else
            if self.player.bursting then
                self.player.bursting = false
            end
            self.exploding = false
            self.media["explosion"].runtime = 0
            self:checkStartGame()
        end
    end,
    checkEnemyExplosionCollision = function(self, startX, startY)
        -- Check for collision of explosion with enemies
        -- NOTE: current x, y, width and height from explosion are de-/increased with the scaling factor.
        for i, enemy in ipairs(self.enemies) do
            if
                CheckCollision(
                    enemy:getLeftX(),
                    enemy:getTopY(),
                    enemy.width,
                    enemy.height,
                    startX - self.media["explosion"].scaledWidth / 2,
                    startY - self.media["explosion"].scaledHeight / 2,
                    self.media["explosion"].scaledWidth,
                    self.media["explosion"].scaledHeight
                )
             then
                enemy.y = enemy.y - self.media["explosion"].scale
                enemy:getHit(1)
            end
        end
    end,
    updateExplosion = function(self, dt, startX, startY, maxRuntime)
        if self.exploding then
            self:upscaleExplosion(dt, maxRuntime)
            self:checkEnemyExplosionCollision(startX, startY)
        end
    end,
    checkStartGame = function(self)
        --make sure this points to the last level, menu
        print(self.currentLvl)
        if self.currentLvl == 3 then
            InitGame(1, 6)
        end
    end,
    checkBoomCollision = function(self, enemy, dt)
        -- boom collision
        for j, boom in ipairs(self.player.booms) do
            if CheckCollision(enemy:getLeftX(), enemy:getTopY(), enemy.width, enemy.height, boom.x, boom.y, 48, 48) then
                enemy:getHit(boom.dmg, dt)
                table.remove(self.player.booms, j)
            end
        end
    end,
    checkFireCollision = function(self, enemy, dt)
        -- check fire collision:
        for j, fire in ipairs(self.player.fires) do
            if
                CheckCollision(
                    enemy:getLeftX(),
                    enemy:getTopY(),
                    enemy.width,
                    enemy.height,
                    fire.x,
                    fire.y,
                    fire.width,
                    fire.height
                )
             then
                enemy:getHit(fire.dmg, dt)
            end
        end
    end,
    checkSonicRingCollision = function(self, enemy, dt)
        -- check sonic rings collision
        for j, ring in ipairs(self.player.sonicRings) do
            if
                CheckCollision(
                    enemy:getLeftX(),
                    enemy:getTopY(),
                    enemy.width,
                    enemy.height,
                    ring.x - ring.radius,
                    ring.y - ring.radius,
                    2 * ring.radius,
                    2 * ring.radius
                )
             then
                enemy:getHit(ring.dmg, dt)
            end
        end
    end,
    checkPlayerCollision = function(self, enemy, dt)
        -- check player collision:
        if
            CheckCollision(
                enemy:getLeftX(),
                enemy:getTopY(),
                enemy.width,
                enemy.height,
                self.player:getLeftX(),
                self.player:getTopY(),
                self.player.width,
                self.player.height
            )
         then
            enemy:die()
            if not self.player.inSonic then
                self.player.hearts = self.player.hearts - 1
                if self.player.hearts == 0 then
                    self.player:die()
                end
            end
        end
    end,
    checkItemCollision = function(self, dt)
        for i, item in ipairs(self.drops) do
            -- check for collision with player
            if
                CheckCollision(
                    item.x,
                    item.y,
                    item.img:getWidth(),
                    item.img:getHeight(),
                    self.player:getLeftX(),
                    self.player:getTopY(),
                    self.player.width,
                    self.player.height
                )
             then
                item:effect()
                table.remove(self.drops, i)
            end
            -- boom collision
            for j, boom in ipairs(self.player.booms) do
                if CheckCollision(item.x, item.y, item.img:getWidth(), item.img:getHeight(), boom.x, boom.y, 48, 48) then
                    item:effect()
                    table.remove(self.drops, i)
                end
            end
        end
    end,
    handleCollisions = function(self, dt)
        for i, enemy in ipairs(self.enemies) do
            if not enemy.gotHit and enemy.curAnim ~= "dying" then
                self:checkBoomCollision(enemy, dt)
                self:checkFireCollision(enemy, dt)
                self:checkSonicRingCollision(enemy, dt)
                self:checkPlayerCollision(enemy, dt)
            end
        end
        self:checkItemCollision(dt)
    end,
    checkPlayerActionInput = function(self, dt)
        -- MOVEMENT
        if love.keyboard.isDown("left") then
            self.player:moveLeft(dt)
        elseif love.keyboard.isDown("right") then
            self.player:moveRight(dt)
        end

        if love.keyboard.isDown("down") then
            self.player:changeDirDown()
        elseif love.keyboard.isDown("up") then
            self.player:changeDirUp()
        end
        -- ATTACKS (do not elseif or one cannot activate skills simultaniously!)
        if love.keyboard.isDown("a") then
            self.player:throwBoom(dt)
        end
        if love.keyboard.isDown("s") and self.player.canFire then
            self.player:spitFire()
        end
        if love.keyboard.isDown("d") and self.player.canBerserk then
            self.player:goBerserk(dt)
        end
        if love.keyboard.isDown("f") and self.player.canGoFast then
            self.player:gottaGoFast(dt)
        end
        if love.keyboard.isDown("space") and self.player.canBurst then
            self.player:burst(dt)
        end
    end,
    updateHealth = function(self)
        self.healthPerc = self.cityHealth / self.cityHealthMax
        if self.healthPerc < 0 then
            self.alive = false
            GAMESTATE = 3
        end
    end,
    checkWinCondition = function(self, dt)
        if self.levels[self.currentLvl]:winCondition(self.runtime, dt) and not self.wonLevel then
            -- set flag that we won
            self.wonLevel = true
            -- kill all remaining enemies
            for i, enemy in pairs(self.enemies) do
                enemy:die()
            end
            -- stop enemies from spawning
            for enemyName, enemySpawnInfo in pairs(self.levels[self.currentLvl].enemies) do
                --TODO: unsafe but works
                enemySpawnInfo.timer = 10000
            end
        end
        if self.wonLevel then
            if
                SUIT.ImageButton(
                    WORLD.media.hud.borderSmall,
                    240 - (self.media.hud.borderSmall:getWidth() / 2),
                    480 - (self.media.hud.borderSmall:getHeight() / 2)
                ).hit
             then
                self.currentLvl = self.currentLvl + 1
                InitGame(self.currentLvl)
            end
        end
    end,
    ------------ DRAWING --------------

    drawPlayerStuff = function(self)
        if self.player.inSonic == true then
            -- make him golden
            love.graphics.setColor(1, 0.8313, 0, 1)
            self.player.anim:draw(self.player.media.img, self.player.x, self.player.y)
            -- draw golden rings
            for i, ring in ipairs(self.player.sonicRings) do
                love.graphics.setColor(1, 0.8313, 0, ring.alpha)
                love.graphics.circle("line", ring.x, ring.y, ring.radius)
            end
            -- prevent that the whole screen is also golden
            love.graphics.setColor(255, 255, 255, 255)
        else
            --TODO check if we want to draw up or down
            self.player.anim:draw(self.player.media.img, self.player.x, self.player.y)
        end

        --WEAPONS
        for i, boom in ipairs(self.player.booms) do
            boom.anim:draw(self.player.media.boom, boom.x, boom.y)
        end
        for i, fire in ipairs(self.player.fires) do
            if fire.dir == 1 then
                love.graphics.draw(self.player.media.fire, fire.x, fire.y)
            else
                love.graphics.draw(
                    self.player.media.fire,
                    fire.x,
                    fire.y,
                    0,
                    1,
                    -1,
                    0,
                    self.player.media.fire:getHeight()
                )
            end
        end
        --ABILITIES
        if self.player.inBerserk == true then
            love.graphics.draw(self.player.media.berserk, self.player.x, self.player.y - 5, 0, 1.5, 1.5)
            self:drawScreenShake(-2, 2)
        end
    end,
    drawEnemyStuff = function(self)
        for i, enemy in ipairs(self.enemies) do
            if enemy.gotHit then
                love.graphics.setColor(1, 0, 0, 1)
                enemy.anim:draw(enemy.media.img, enemy.x, enemy.y)
                love.graphics.setColor(255, 255, 255, 255)
            else
                enemy.anim:draw(enemy.media.img, enemy.x, enemy.y)
            end
        end
    end,
    drawItemStuff = function(self)
        for i, item in ipairs(self.drops) do
            love.graphics.draw(item.img, item.x, item.y)
        end
    end,
    drawSkillBorders = function(self)
        if self.media.hudSkillBorder.a then
            love.graphics.draw(self.media.hudSkillBorder.a, self.media.hudPos.xOffset, self.media.hudPos.yOffset)
        end
        if self.media.hudSkillBorder.s then
            love.graphics.draw(
                self.media.hudSkillBorder.s,
                self.media.hudPos.xOffset + self.media.hudPos.skillDistance,
                self.media.hudPos.yOffset
            )
        end
        if self.media.hudSkillBorder.d then
            love.graphics.draw(
                self.media.hudSkillBorder.d,
                self.media.hudPos.xOffset + (self.media.hudPos.skillDistance * 2),
                self.media.hudPos.yOffset
            )
        end
        if self.media.hudSkillBorder.f then
            love.graphics.draw(
                self.media.hudSkillBorder.f,
                self.media.hudPos.xOffset + (self.media.hudPos.skillDistance * 3),
                self.media.hudPos.yOffset
            )
        end
        if self.media.hudSkillBorder.space then
            love.graphics.draw(
                self.media.hudSkillBorder.space,
                self.media.hudPos.xOffset + (self.media.hudPos.skillDistance * 4),
                self.media.hudPos.yOffset
            )
        end
    end,
    drawHud = function(self)
        self:drawSkills()
        self:drawHealthBar()
        self:drawHearts()
        self:drawButtons()
        self:drawSkillBorders()
        self:drawMoney()
        self:drawKillCounters()
        self:drawLevelTimer()
    end,
    drawSkills = function(self)
        if self.player.canBoom == true then
            love.graphics.draw(self.media.hud.boom, self.media.hudPos.xOffset, self.media.hudPos.yOffset)
        else
            love.graphics.draw(self.media.hud.boomUsed, self.media.hudPos.xOffset, self.media.hudPos.yOffset)
        end
        if self.player.inBerserk then
            -- make the boom box bling
            love.graphics.setColor(1, 0.8313, 0, self.player.berserkAlpha)
            love.graphics.rectangle(
                "fill",
                self.media.hudPos.xOffset,
                self.media.hudPos.yOffset,
                self.media.hud.boom:getWidth(),
                self.media.hud.boom:getHeight()
            )
            love.graphics.setColor(255, 255, 255, 255)
        end
        if self.player.canFire == true and (self.player.fireLevel ~= 0) then
            love.graphics.draw(
                self.media.hud.fire,
                self.media.hudPos.xOffset + self.media.hudPos.skillDistance,
                self.media.hudPos.yOffset
            )
        else
            love.graphics.draw(
                self.media.hud.fireUsed,
                self.media.hudPos.xOffset + self.media.hudPos.skillDistance,
                self.media.hudPos.yOffset
            )
        end
        if self.player.canBerserk == true and (self.player.berserkLevel ~= 0) then
            love.graphics.draw(
                self.media.hud.berserk,
                self.media.hudPos.xOffset + (2 * self.media.hudPos.skillDistance),
                self.media.hudPos.yOffset
            )
        else
            love.graphics.draw(
                self.media.hud.berserkUsed,
                self.media.hudPos.xOffset + (2 * self.media.hudPos.skillDistance),
                self.media.hudPos.yOffset
            )
        end
        if self.player.canGoFast == true and (self.player.goFastLevel ~= 0) then
            love.graphics.draw(
                self.media.hud.fast,
                self.media.hudPos.xOffset + (3 * self.media.hudPos.skillDistance),
                self.media.hudPos.yOffset
            )
        else
            love.graphics.draw(
                self.media.hud.fastUsed,
                self.media.hudPos.xOffset + (3 * self.media.hudPos.skillDistance),
                self.media.hudPos.yOffset
            )
        end
        if self.player.canBurst == true and (self.player.burstLevel ~= 0) then
            love.graphics.draw(
                self.media.hud.explo,
                self.media.hudPos.xOffset + (4 * self.media.hudPos.skillDistance),
                self.media.hudPos.yOffset
            )
        else
            love.graphics.draw(
                self.media.hud.exploUsed,
                self.media.hudPos.xOffset + (4 * self.media.hudPos.skillDistance),
                self.media.hudPos.yOffset
            )
        end
    end,
    drawHealthBar = function(self)
        love.graphics.draw(
            self.media.hud.health,
            self.media.hudPos.healthX,
            self.media.hudPos.healthY,
            0,
            self.healthPerc,
            1
        )
        love.graphics.draw(self.media.hud.healthFrame, self.media.hudPos.healthX, self.media.hudPos.healthY)
    end,
    drawMoney = function(self)
        --todo make sparkle and rarely turn (no need for anim, use x rotation)
        love.graphics.draw(self.media.hud.money, self.media.hudPos.moneyX, self.media.hudPos.moneyY, 0, 0.5)
        love.graphics.setFont(WORLD.media.bigfantasyfont)
        love.graphics.print(self.player.money, self.media.hudPos.moneyX + 90, self.media.hudPos.moneyY + 35)
    end,
    drawHearts = function(self) --a heart for kids
        for heart in Range(self.player.hearts) do
            love.graphics.draw(
                self.media.hud.heart,
                self.media.hudPos.heartX + (self.media.hudPos.heartDistance * heart - 1),
                self.media.hudPos.heartY,
                0,
                0.5
            )
        end
    end,
    drawButtons = function(self)
        love.graphics.draw(self.media.hud.a, self.media.hudPos.letterX, self.media.hudPos.letterY, 0, 0.65)
        love.graphics.draw(
            self.media.hud.s,
            (self.media.hudPos.letterX + self.media.hudPos.letterDistance * 1),
            self.media.hudPos.letterY,
            0,
            0.65
        )
        love.graphics.draw(
            self.media.hud.d,
            (self.media.hudPos.letterX + self.media.hudPos.letterDistance * 2),
            self.media.hudPos.letterY,
            0,
            0.65
        )
        love.graphics.draw(
            self.media.hud.f,
            (self.media.hudPos.letterX + self.media.hudPos.letterDistance * 3),
            self.media.hudPos.letterY,
            0,
            0.65
        )
        love.graphics.draw(
            self.media.hud.space,
            (self.media.hudPos.letterX + self.media.hudPos.letterDistance * 4),
            self.media.hudPos.letterY
        )
    end,
    drawKillCounters = function(self)
        if self.levels[self.currentLvl].winType == "kill" then
            -- scale down the kill counter a little
            local scaling = love.math.newTransform(0, 0, 0, 0.8, 0.8, 0, 0)
            love.graphics.push()
            love.graphics.applyTransform(scaling)
            local enemyCount = 1
            for enemyName, enemySpawnInfo in pairs(self.levels[self.currentLvl].enemies) do
                -- if enemy on hitlist
                if enemySpawnInfo.killToWin then
                    -- let background be transparent black
                    love.graphics.setColor(0, 0, 0, 0.5)
                    love.graphics.rectangle(
                        "fill",
                        self.media.hudPos.counterX,
                        self.media.hudPos.counterY * enemyCount,
                        self.media.hud.brown:getWidth(),
                        self.media.hud.brown:getHeight()
                    )
                    -- reset black color
                    love.graphics.setColor(255, 255, 255, 255)
                    -- draw brown frame
                    love.graphics.draw(
                        self.media.hud.brown,
                        self.media.hudPos.counterX,
                        self.media.hudPos.counterY * enemyCount
                    )
                    -- draw enemy pic into frame
                    love.graphics.draw(
                        self.statsRaw[enemyName].media.img,
                        self.statsRaw[enemyName].portrait,
                        self.media.hudPos.counterX,
                        self.media.hudPos.counterY * enemyCount
                    )
                    -- write killCounter
                    love.graphics.setFont(WORLD.media.bigfantasyfont)
                    love.graphics.printf(
                        enemySpawnInfo.killCounter .. "/" .. enemySpawnInfo.killGoal,
                        self.media.hudPos.counterX + self.media.hud.brown:getWidth() + 5,
                        self.media.hudPos.counterY * enemyCount,
                        (500 - (0.8 * self.media.hudPos.counterX + 0.8 * self.media.hud.brown:getWidth())),
                        "center"
                    )
                    enemyCount = enemyCount + 1
                end
            end
            enemyCount = 0
            love.graphics.pop()
        end
    end,
    drawLevelTimer = function(self)
        if self.levels[self.currentLvl].winType == "endure" then
            -- scale down the kill counter a little, make it gradually more red until we reach zero
            local scaling = love.math.newTransform(0, 0, 0, 0.8, 0.8, 0, 0)
            love.graphics.push()
            love.graphics.applyTransform(scaling)
            love.graphics.setFont(WORLD.media.bigfantasyfont)
            if self.runtime >= self.levels[self.currentLvl].runtimeGoal then
                -- runtime goal reached
                local time = DisplayTime(0)
                love.graphics.printf(time, self.media.hudPos.counterX + 5, self.media.hudPos.counterY, 150, "left")
            else
                -- runtime goal not reached
                love.graphics.setColor(
                    1,
                    1 - self.runtime / self.levels[self.currentLvl].runtimeGoal,
                    1 - self.runtime / self.levels[self.currentLvl].runtimeGoal,
                    1
                )
                local time = DisplayTime(self.levels[self.currentLvl].runtimeGoal - self.runtime)
                love.graphics.printf(time, self.media.hudPos.counterX + 5, self.media.hudPos.counterY, 150, "left")
                love.graphics.setColor(255, 255, 255, 255)
            end
            love.graphics.pop()
        end
    end,
    drawScreenShake = function(self, min, max)
        local xShift = love.math.random(min, max)
        local yShift = love.math.random(min, max)
        love.graphics.translate(xShift, yShift)
    end,
    drawExplosionStuff = function(self, startX, startY)
        if self.exploding then
            if self.media["explosion"].runtime < self.media["explosion"].maxRuntime then
                self:drawScreenShake(-self.media["explosion"].shakeMagnitude, self.media["explosion"].shakeMagnitude)
                -- The transformation coordinate system (upper left corner of pic) is in position (240,850) and is shifted in both directions by 39px,
                -- which is the center of the pic
                local scaling =
                    love.math.newTransform(
                    startX,
                    startY,
                    0,
                    self.media["explosion"].scale,
                    self.media["explosion"].scale,
                    self.media["explosion"].img:getWidth() / 2,
                    self.media["explosion"].img:getWidth() / 2
                )
                love.graphics.push()
                love.graphics.applyTransform(scaling)
                love.graphics.draw(self.media["explosion"].img, 0, 0)
                love.graphics.pop()
            end
        end
    end,
    drawWinScreen = function(self)
        if self.wonLevel then
            love.graphics.setFont(WORLD.media.bigfantasyfont)
            love.graphics.print("YOU WIN!", 152, 250)
            SUIT.draw() -- draw continue button
            love.graphics.printf("CONTINUE", 0, 450, 480, "center")
        end
    end,
    drawHitBoxes = function(self, explosionX, explosionY)
        if GAMESTATE == 2 then
            love.graphics.rectangle(
                "line",
                self.player:getLeftX(),
                self.player:getTopY(),
                self.player.width,
                self.player.height
            )
            for i, boom in ipairs(self.player.booms) do
                love.graphics.rectangle("line", boom.x, boom.y, 48, 48)
            end
            for i, enemy in ipairs(self.enemies) do
                love.graphics.rectangle("line", enemy:getLeftX(), enemy:getTopY(), enemy.width, enemy.height)
            end
            for i, fire in ipairs(self.player.fires) do
                love.graphics.rectangle("line", fire.x, fire.y, fire.width, fire.height)
            end
        end
        if self.exploding then
            love.graphics.rectangle(
                "line",
                explosionX - self.media["explosion"].scaledWidth / 2,
                explosionY - self.media["explosion"].scaledHeight / 2,
                self.media["explosion"].scaledWidth,
                self.media["explosion"].scaledHeight
            )
        end
    end
}
