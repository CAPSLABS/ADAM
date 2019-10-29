return {
    player = nil,
    enemies = {},
    x = 32*15,
    y = 32*30,
    currentLvl=nil,
    runtime = 0,
    exploding = false,
    media = {
        defaultfont= nil,
        fantasyfont=nil,
        surprise= {
            img = "assets/what.jpg"
        },
        hud ={
            berserk=    "assets/hud/berserk/berserk.png",
            berserkUsed="assets/hud/berserk/berserkUsed.png",
            boom=       "assets/hud/boom/boom64.png",
            boomUsed=   "assets/hud/boom/boom64used.png",
            explo =     "assets/hud/explo/explo.png",
            exploUsed=  "assets/hud/explo/exploUsed.png",
            fast =      "assets/hud/fast/fast.png",
            fastUsed=   "assets/hud/fast/fastUsed.png",
            fire=       "assets/hud/fire/fire.png",
            fireUsed=   "assets/hud/fire/fireUsed.png",
            healthBack=  "assets/hud/healthbar/health300.png",
            health="assets/hud/healthbar/fullHealth300.png"
        },
        hudPos ={
            --SKILLS:
            yOffset = 850,
            xOffset = 30,
            distance= 90,

            healthX = 100,
            healthY = 900

        },
        explosion = {
            img = "assets/explosion.png",
            runtime = 0,
            maxRuntime = 1.3,
            scale = 0,
            scaledWidth = 0,
            scaledHeight = 0,
            shakeMagnitude = 5,
        },
    },
    levels = {
        --level1
        {mapPath = "ebene1tilemap",
        cityHealthMax = 100,
        cityHealth = 100,
        spawnTimer = {
                goblin = {
                    timer = 0.4, -- inital value is value of timerMax, a changing variable
                    timerMax = 0.4, -- initial value until first mob comes, marks the actual countdown time
                    spawnFct = function(self,runtime)
                        -- Sigmoid mirrored on y axis shifted by 2 along x axis
                        -- Reaches timer = 0.51 in ~46 seconds
                        return (1 / (1 + math.exp(0.1*runtime))) + 0.5
                    end,
                },
            },
        },
        --level 2
        {mapPath = "ebene2tilemap",
        cityHealthMax = 100,
        cityHealth = 100,
        spawnTimer=
            {
                goblin = {
                    timer = 0.2,
                    timerMax = 0.2,
                    spawnFct = function(self,runtime)
                        -- Sigmoid mirrored on y axis shifted up by 0.5 (minimum is 0.5)
                        -- Reaches timer = 0.51 in ~46 seconds
                        return (1 / (1 + math.exp(0.1*runtime))) + 0.5
                    end,
                },
                zombie = {
                    timer = 1,
                    timerMax = 1,
                    spawnFct = function(self,runtime)
                        -- Reaches timer = 1.51 in ~51 seconds
                        return (1 / (1 + math.exp(0.09*runtime))) + 1.5
                    end,
                }
            },
        },
        --menu (always last)
        {mapPath = "ebene1tilemap",
        spawnTimer=
            {
                goblin = {
                    timer = 0.0,
                    timerMax = 0.0,
                    spawnFct = function(self,runtime)
                        return 0.0
                    end,
                },
            },
        },
    }, 
    statsRaw = { 
        goblin = require("src.goblin"),
        zombie = require("src.zombie")
    },

    ------------ LOADING --------------

    --enemies are expected to implement: 
        --media.img(filepath, string)
        --media width (the width of the enemy image in pixels, int)
        --media height (the height of the enemy image in pixels, int)
    loadEnemies = function(self)
        for key, enemy in pairs(self.statsRaw) do
            enemy.media.img = love.graphics.newImage(enemy.media.img)
            enemy.media.imgGrid = anim8.newGrid(enemy.media.imgWidth, enemy.media.imgHeight, enemy.media.img:getWidth(), enemy.media.img:getHeight())
        end
    end,

    loadPlayer = function(self)
        for key, imgPath in pairs(self.player.media) do
            self.player.media[key] = love.graphics.newImage(imgPath) 
        end
        self.player.media.boomGrid = anim8.newGrid(48, 48, self.player.media.boom:getWidth(), self.player.media.boom:getHeight())
        self.player.media.playerGrid = anim8.newGrid(64, 64, self.player.media.img:getWidth(), self.player.media.img:getHeight())
        self.player.upAnim = anim8.newAnimation(self.player.media.playerGrid('1-4',2), 0.1)
        self.player.downAnim = anim8.newAnimation(self.player.media.playerGrid('1-4',1), 0.1)
        self.player.anim = self.player.upAnim
    end,

    loadMedia = function(self)
        self.media.surprise.img=love.graphics.newImage(self.media.surprise.img)
        self.media.explosion.img = love.graphics.newImage(self.media.explosion.img)
        self.media.defaultfont = love.graphics.getFont()
        self.media.fantasyfont = love.graphics.newFont("assets/font/Komi.ttf", 15) 
    end,

    loadHud = function(self)
        for key, imgPath in pairs(self.media.hud) do
            self.media.hud[key] = love.graphics.newImage(imgPath) 
        end

        --self.media.hud.boom = love.graphics.newImage(self.media.hud.boom)
        --self.media.hud.boomUsed = love.graphics.newImage(self.media.hud.boomUsed)
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
            end
        end
    end,

    spawnEnemies=function(self,dt)
        self.runtime = self.runtime + dt
        for enemyName,enemySpawnInfo in pairs(self.levels[self.currentLvl].spawnTimer) do
            enemySpawnInfo.timer = enemySpawnInfo.timer - dt
            if enemySpawnInfo.timer <= 0 then 
                enemySpawnInfo.timerMax = enemySpawnInfo:spawnFct(self.runtime)
                local newEnemy = self.statsRaw[enemyName]:newSelf() 
                table.insert(self.enemies, newEnemy)
                enemySpawnInfo.timer = enemySpawnInfo.timerMax
            end
        end
    end,

    upscaleExplosion = function(self,dt,maxRuntime)
        if self.media["explosion"].runtime < maxRuntime then
            -- +0.1 needed, without it the scaling wouldn't start
            self.media["explosion"].scale = (self.media["explosion"].scale + 0.1)^self.media["explosion"].runtime
            self.media["explosion"].runtime = self.media["explosion"].runtime + dt
            self.media["explosion"].scaledWidth = self.media["explosion"].scale*self.media["explosion"].img:getWidth()
            self.media["explosion"].scaledHeight = self.media["explosion"].scale*self.media["explosion"].img:getHeight()
        end
    end,

    checkEnemyExplosionCollision = function(self,startX,startY) 
        -- Check for collision of explosion with enemies
        -- NOTE: current x, y, width and height from explosion are de-/increased with the scaling factor. 
        for i, enemy in ipairs(self.enemies) do
            if CheckCollision(enemy:getLeftX(), enemy:getTopY(), enemy.width, enemy.height, 
                            startX-self.media["explosion"].scaledWidth/2,
                            startY-self.media["explosion"].scaledHeight/2, 
                            self.media["explosion"].scaledWidth, 
                            self.media["explosion"].scaledHeight) then
                enemy.y = enemy.y - self.media["explosion"].scale
            end
        end
    end,

    updateExplosion = function(self,dt,startX,startY,maxRuntime)
        if self.exploding then
            if self.player.bursting then 
                self:upscaleExplosion(dt,self.player.explosionMaxRuntime)
                if self.media["explosion"].runtime >= maxRuntime then
                    self.player.bursting = false
                end
            else
                self:upscaleExplosion(dt,self.media["explosion"].maxRuntime)
            end
            self:checkEnemyExplosionCollision(startX,startY)
        end
    end,

    handleCollisions = function(self, dt)
        for i, enemy in ipairs(self.enemies) do
            if not enemy.gotHit and enemy.curAnim ~= "dying" then
                -- boom collision
                for j, boom in ipairs(self.player.booms) do
                    if CheckCollision(  enemy:getLeftX(),enemy:getTopY(),
                                        enemy.width, enemy.height, 
                                        boom.x, boom.y, 
                                        48, 48) then
                        enemy:getHit(boom.dmg, dt)
                        table.remove(self.player.booms, j)
                    end
                end
                -- check fire collision:
                for j, fire in ipairs(self.player.fires) do
                    if CheckCollision(  enemy:getLeftX(), enemy:getTopY(), 
                                        enemy.width, enemy.height,
                                        fire.x, fire.y, 
                                        fire.width, fire.height) then
                        enemy:getHit(fire.dmg, dt)
                    end
                end
                -- check player collision:
                if CheckCollision(  enemy:getLeftX(), enemy:getTopY(), 
                                    enemy.width, enemy.height, 
                                    self.player:getLeftX(), self.player:getTopY(), 
                                    self.player.width, self.player.height) then
                    if(self.player.inSonic) then
                        enemy:die()
                    else
                        self.player:die()
                    end
                end
            end

        end
    end,

    checkPlayerActionInput = function(self,dt)
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
            self.player:throwBoom(dt) end
        if love.keyboard.isDown("s") and self.player.canBreath then
            self.player:spitFire() end
        if love.keyboard.isDown("d") and self.player.canBerserk then 
            self.player:goBerserk(dt) end
        if love.keyboard.isDown("f") and self.player.canRunFast then 
            self.player:gottaGoFast(dt) end
        if love.keyboard.isDown("space") and self.player.canBurst then
            self.exploding = true
            self.player:burst(dt) 
        end
    end,

    updateHealth = function(self)
        healthPerc = (self.levels[self.currentLvl].cityHealth / self.levels[self.currentLvl].cityHealthMax)*100
        --TODO use healthPerc to draw only that perc of fullHealth or modify a number that drawing always uses
        --either x scaling (xs) or make a quad to crop
    end,


    ------------ DRAWING --------------

    drawPlayerStuff = function(self)
        --TODO check if we want to draw up or down
        self.player.anim:draw(self.player.media.img, self.player.x, self.player.y)
        --WEAPONS
        for i, boom in ipairs(self.player.booms) do
            boom.anim:draw(self.player.media.boom, boom.x, boom.y)
        end
        for i, fire in ipairs(self.player.fires) do
            if fire.dir == 1 then
                love.graphics.draw(self.player.media.fire, fire.x, fire.y)
            else 
                love.graphics.draw(self.player.media.fire, fire.x, fire.y, 0,1,-1)
            end
        end
        --ABILITIES
        if self.player.inBerserk == true then
            love.graphics.draw(self.player.media.berserk, self.player.x, self.player.y-5, 0,1.5,1.5)
        end
    end,

    drawEnemyStuff = function(self)
        for i, enemy in ipairs(self.enemies) do
            if enemy.gotHit then
                love.graphics.setColor(1,0,0,1)
                enemy.anim:draw(enemy.media.img, enemy.x, enemy.y)
                love.graphics.setColor( 255, 255, 255, 255)
            else
                enemy.anim:draw(enemy.media.img, enemy.x, enemy.y)
            end
        end
    end,

    drawHud = function(self)
        --for skill, img in pairs(self.media.hud) do
        --    love.graphics.draw(self.media.hud.boom, self.media.hudPos.xOffset, self.media.hudPos.yOffset)
        --    print(skill, img)
        --end
        if self.player.canThrow == true then
            love.graphics.draw(self.media.hud.boom, self.media.hudPos.xOffset, self.media.hudPos.yOffset)
        else
            love.graphics.draw(self.media.hud.boomUsed, self.media.hudPos.xOffset, self.media.hudPos.yOffset)
        end
        if self.player.canBreath == true then
            love.graphics.draw(self.media.hud.fire, self.media.hudPos.xOffset + self.media.hudPos.distance, self.media.hudPos.yOffset)
        else
            love.graphics.draw(self.media.hud.fireUsed, self.media.hudPos.xOffset + self.media.hudPos.distance, self.media.hudPos.yOffset)
        end
        if self.player.canBerserk == true then
            love.graphics.draw(self.media.hud.berserk, self.media.hudPos.xOffset + (2 * self.media.hudPos.distance), self.media.hudPos.yOffset)
        else
            love.graphics.draw(self.media.hud.berserkUsed, self.media.hudPos.xOffset + (2 * self.media.hudPos.distance), self.media.hudPos.yOffset)
        end
        if self.player.canRunFast == true then
            love.graphics.draw(self.media.hud.fast, self.media.hudPos.xOffset + (3 * self.media.hudPos.distance), self.media.hudPos.yOffset)
        else
            love.graphics.draw(self.media.hud.fastUsed, self.media.hudPos.xOffset + (3 * self.media.hudPos.distance), self.media.hudPos.yOffset)
        end
        if self.player.canBurst == true then
            love.graphics.draw(self.media.hud.explo, self.media.hudPos.xOffset + (4 * self.media.hudPos.distance), self.media.hudPos.yOffset)
        else
            love.graphics.draw(self.media.hud.exploUsed, self.media.hudPos.xOffset + (4 * self.media.hudPos.distance), self.media.hudPos.yOffset)
        end

        --HEALTHBAR
        love.graphics.draw(self.media.hud.healthBack, self.media.hudPos.healthX, self.media.hudPos.healthY)
        love.graphics.draw(self.media.hud.health, self.media.hudPos.healthX, self.media.hudPos.healthY)
    end,

    drawExplosionScreenShake = function(self)
        local xShift = love.math.random(-self.media["explosion"].shakeMagnitude,self.media["explosion"].shakeMagnitude)
        local yShift = love.math.random(-self.media["explosion"].shakeMagnitude,self.media["explosion"].shakeMagnitude)
        love.graphics.translate(xShift,yShift)
    end,

    drawExplosionStuff = function(self,dt,startX,startY)
        if self.exploding then
            if self.media["explosion"].runtime < self.media["explosion"].maxRuntime then
                -- The transformation coordinate system (upper left corner of pic) is in position (240,850) and is shifted in both directions by 39px, which is the center of the pic
                local xShift = love.math.random(-self.media["explosion"].shakeMagnitude,self.media["explosion"].shakeMagnitude)
                local yShift = love.math.random(-self.media["explosion"].shakeMagnitude,self.media["explosion"].shakeMagnitude)
                love.graphics.translate(xShift,yShift)
                --local startX = 240
                --local startY = 850
                local scaling = love.math.newTransform(startX, startY, 0, self.media["explosion"].scale, self.media["explosion"].scale, self.media["explosion"].img:getWidth()/2, self.media["explosion"].img:getWidth()/2)
                love.graphics.push()
                love.graphics.applyTransform(scaling)
                love.graphics.draw(self.media["explosion"].img, 0, 0)
                love.graphics.pop()
            else 
                self.exploding = false
                self.media["explosion"].runtime = 0
                if not self.player.bursting then
                    initGame(self.currentLvl)
                end
            end
        end
    end,

    drawHitBoxes = function(self,explosionX,explosionY)
        if gamestate == 2 then
            love.graphics.rectangle("line", 
                                        self.player:getLeftX(), 
                                        self.player:getTopY(), 
                                        self.player.width, 
                                        self.player.height)
            for i, boom in ipairs(self.player.booms) do
                love.graphics.rectangle("line", 
                                        boom.x, 
                                        boom.y, 
                                        48, 
                                        48)
            end
            for i, enemy in ipairs(self.enemies) do
                love.graphics.rectangle("line", 
                                        enemy:getLeftX(), 
                                        enemy:getTopY(), 
                                        enemy.width, 
                                        enemy.height)
            end
            for i, fire in ipairs(self.player.fires) do
                love.graphics.rectangle("line", 
                                        fire.x, 
                                        fire.y, 
                                        fire.width, 
                                        fire.height)
            end
        end
        if self.exploding then
            love.graphics.rectangle("line",
                                    explosionX-self.media["explosion"].scaledWidth/2,
                                    explosionY-self.media["explosion"].scaledHeight/2, 
                                    self.media["explosion"].scaledWidth, 
                                    self.media["explosion"].scaledHeight)
        end
    end
}