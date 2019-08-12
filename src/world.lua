return {
    player = nil,
    enemies = {},
    x = 32*15,
    y = 32*30,
    currentLvl=nil,
    media = {
        explosion = {
            img = "assets/explosion.png",
            runtime = 0,
            maxRuntime = 2,
            scale = 0,
        }
    },
    levels = {
        --level1
        {mapPath = "ebene1tilemap",
        spawnTimer =
            {
                goblin=0.4, --enemyType&spawnRate
            },
        spawnTimerMax=
            {
                goblin=0.4,
            }
        },
        --level 2
        {mapPath = "ebene2tilemap",
        spawnTimer=
            {
                goblin=0.2,
                zombie=1.5,
            },
        spawnTimerMax=
            {
                goblin=0.2,
                zombie=1.5,
            },
        },
        --menu (always last)
        {mapPath = "ebene1tilemap",
        spawnTimer=
            {
                goblin=0,
            },
        spawnTimerMax=
            {
                goblin=0,
            }
        },
    }, 
    statsRaw = { --used for creating new instances with max values
        --TODO could reduce initial load time here be making a func that checks which 
        --enemies have currentLvl.spawnTime values and only load those  
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
        self.player.media.boomGrid= anim8.newGrid(48, 48, self.player.media.boom:getWidth(), self.player.media.boom:getHeight())
        self.player.media.playerGrid= anim8.newGrid(64, 64, self.player.media.img:getWidth(), self.player.media.img:getHeight())
        self.player.upAnim = anim8.newAnimation(self.player.media.playerGrid('1-4',2), 0.1)
        self.player.downAnim = anim8.newAnimation(self.player.media.playerGrid('1-4',1), 0.1)
        self.player.anim = self.player.upAnim
    end,

    loadMedia = function(self)
        for key, params in pairs(self.media) do
            -- up to now the only media is the explosion pic. If animations are involved, change all of this
            if key == "explosion" then
                self.media[key].img = love.graphics.newImage(params.img)
                self.media[key].runtime = params.runtime
                self.media[key].maxRuntime = params.maxRuntime
                self.media[key].scale = params.scale
            end
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
            end
        end
    end,

    spawnEnemies = function(self,dt)
        for enemy,timer in pairs(self.levels[self.currentLvl].spawnTimer) do
            self.levels[self.currentLvl].spawnTimer[enemy] = timer - (1*dt)
            if timer < 0 then --put enemy in the table and reset timer:[self.currentLvl].spawnTimer[enemy])
                self.levels[self.currentLvl].spawnTimer[enemy] = self.levels[self.currentLvl].spawnTimerMax[enemy]
                local newEnemy = self.statsRaw[enemy]:newSelf() 
                table.insert(self.enemies, newEnemy)
            end
        end
    end,

    updateExplosion = function(self,dt)
        if self.media["explosion"].runtime < self.media["explosion"].maxRuntime then
            -- +1 needed, without it the scaling wouldn't start
            self.media["explosion"].scale = (self.media["explosion"].scale + 0.1)^self.media["explosion"].runtime
            self.media["explosion"].runtime = self.media["explosion"].runtime + dt
        else
            -- Make explosion more and more transparent
            -- use love.graphics.stencil giving it a function / mask that defines which pixels to choose
            -- use stencil test to mark img pixels as make more transparent
            -- use setColor to make them more transparent / or use pixelshader
        end
    end,

    handleCollisions = function(self)
        for i, enemy in ipairs(self.enemies) do
            --check boom collision:
            for j, boom in ipairs(self.player.booms) do
                if CheckCollision(  enemy:getLeftX(),enemy:getTopY(),
                                    enemy.width, enemy.height, 
                                    boom.x, boom.y, 
                                    48, 48) then
                    if enemy:getHit(boom.dmg) == "dead" then
                        self.player.money = self.player.money+enemy.reward
                        print(self.player.money)
                    end

                    table.remove(self.player.booms, j)
                end
            end
            -- check fire collision:
            for j, fire in ipairs(self.player.fires) do
                if CheckCollision(  enemy:getLeftX(), enemy:getTopY(), 
                                    enemy.width, enemy.height,
                                    fire.x, fire.y, 
                                    fire.width, fire.height) then
                    if enemy:getHit(fire.dmg) == "dead" then
                        self.player.money = self.player.money+enemy.reward
                    end
                end
            end
            -- check player collision:
            if CheckCollision(  enemy:getLeftX(), enemy:getTopY(), 
                                enemy.width, enemy.height, 
                                self.player:getLeftX(), self.player:getTopY(), 
                                self.player.width, self.player.height) then
                self.player:die()
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

        if self.player.inBerserk == true then
            love.graphics.draw(self.player.media.berserk, self.player.x, self.player.y-5, 0,1.5,1.5)
        end
    end,

    drawEnemyStuff = function(self)
        for i, enemy in ipairs(self.enemies) do
            enemy.anim:draw(enemy.media.img, enemy.x, enemy.y)
        end
    end,

    drawExplosionStuff = function(self,dt)
        if self.media["explosion"].runtime < self.media["explosion"].maxRuntime then
            -- The transformation coordinate system (upper left corner of pic) is in position (240,850) and is shifted in both directions by 39px, which is the center of the pic
            local startX = 240
            local startY = 850
            local scaling = love.math.newTransform(startX, startY, 0, self.media["explosion"].scale, self.media["explosion"].scale, self.media["explosion"].img:getWidth()/2, self.media["explosion"].img:getWidth()/2)
            love.graphics.push()
            love.graphics.applyTransform(scaling)
            love.graphics.draw(self.media["explosion"].img, 0, 0)
            love.graphics.pop()
            -- Check for collision of explosion with enemies
            -- NOTE: current x, y, width and height from explosion are de-/increased with the scaling factor. 
            -- Since we cannot get them from the img object, we manually recompute them here
            for i, enemy in ipairs(self.enemies) do
                if CheckCollision(enemy:getLeftX(), enemy:getTopY(), enemy.width, enemy.height, 
                                startX-self.media["explosion"].scale*self.media["explosion"].img:getWidth()/2, 
                                startY-self.media["explosion"].scale*self.media["explosion"].img:getHeight()/2, 
                                self.media["explosion"].scale*self.media["explosion"].img:getWidth(), 
                                self.media["explosion"].scale*self.media["explosion"].img:getHeight()) then
                    enemy.y = enemy.y - self.media["explosion"].scale
                    enemy.anim:draw(enemy.media.img, enemy.x, enemy.y)
                end
            end
        else 
            self.enemies = {}
            gamestate = 2
            love.load(1)
        end
    end,

    drawHitBoxes = function(self)
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
        elseif gamestate == 5 then
            love.graphics.rectangle("line",
                                    240-self.media["explosion"].scale*self.media["explosion"].img:getWidth()/2,
                                    850-self.media["explosion"].scale*self.media["explosion"].img:getHeight()/2, 
                                    self.media["explosion"].scale*self.media["explosion"].img:getWidth(), 
                                    self.media["explosion"].scale*self.media["explosion"].img:getHeight())
        end
    end
}