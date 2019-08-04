return {
    player = nil,
    enemies = {},
    x = 32*15,
    y = 32*30,
    currentLvl=1,
    levels = {
        --level1
        {mapPath = "ebene1tilemap",
        spawnTimer =
            {
                goblin=0.4, --enemyType&spawnRate
                --zombie=2.0,
            }
        },
        --level 2
        {mapPath = "ebene2tilemap",
        spawnTimer=
            {
                goblin=0.1,
                --zombie=0.8,
            }
        }
    }, 
    statsRaw = { --used for creating new instances with max values
        --TODO could reduce initial load time here be making a func that checks which 
        --enemies have currentLvl.spawnTime values and only load those  
        goblin = require("src.goblin"),
        --zombie = require("src.zombie")
    },

    loadLevel = function(self) --loads images and animations
        self:loadEnemies()  
        self:loadPlayer() 
    end,

    --enemies are expected to implement: 
        --media.img(path string)
        --width (the width of the enemy in pixels, int)
        --height (the height of the enemy in pixels, int)
    loadEnemies = function(self)
        for key, enemy in pairs(self.statsRaw) do
            enemy.media.img = love.graphics.newImage(enemy.media.img) 
            enemy.media.imgGrid = anim8.newGrid(enemy.width, enemy.height, enemy.media.img:getWidth(), enemy.media.img:getHeight())
        end
    end,

    loadPlayer = function(self)
        for key, imgPath in pairs(self.player.media) do
            self.player.media[key] = love.graphics.newImage(imgPath) 
        end
        self.player.media.boomGrid= anim8.newGrid(48, 48, playerRaw.media.boom:getWidth(), playerRaw.media.boom:getHeight())
    end,

    --enemies are expected to implement: 
        --update(anim function)
        --alive (bool) & reward (int) 
    updateEnemies = function(self, dt) 
        for i, enemy in ipairs(self.enemies) do
            enemy:update(dt)
            if not enemy.alive then
                table.remove(self.enemies, i)
                self.player.money = self.player.money+enemy.reward
            end
        end
    end,

    spawnEnemies = function(self,dt)
        for enemy,timer in pairs(self.levels[self.currentLvl].spawnTimer) do
            self.levels[self.currentLvl].spawnTimer[enemy] = timer - (1*dt)
            if timer < 0 then --put enemy in the table and reset timer:[self.currentLvl].spawnTimer[enemy])
                self.levels[self.currentLvl].spawnTimer[enemy] = envRaw.levels[self.currentLvl].spawnTimer[enemy]
                local randomStartX = math.random(0, self.x - self.statsRaw[enemy].width) -- substracting width avoids clipping out to the right
                local walkAnim = anim8.newAnimation(self.statsRaw[enemy].media.imgGrid('1-7', 1), 0.07)
                local newEnemy = self.statsRaw[enemy]:newSelf(randomStartX, walkAnim) 
                table.insert(self.enemies, newEnemy)
            end
        end
    end,

    handleCollisions = function(self)
        for i, enemy in ipairs(self.enemies) do
            --check boom collision:
            for j, boom in ipairs(self.player.booms) do
                if CheckCollision(enemy.x, enemy.y, enemy.width, enemy.height, 
                                boom.x, boom.y, 48, 48) then
                    enemy:getHit(1)
                    table.remove(self.player.booms, j)
                end
            end
            -- check fire collision:
            for j, fire in ipairs(self.player.fires) do
                if CheckCollision(enemy.x, enemy.y, enemy.width, enemy.height,
                                fire.x, fire.y, fire.img:getWidth()*0.5, fire.img:getHeight()*0.5) then
                    enemy:getHit(2)
                end
            end
            -- check player collision:
            if CheckCollision(enemy.x, enemy.y, enemy.width, enemy.height, 
                                self.player.x, self.player.y, 
                                self.player.media.imgUp:getWidth()*self.player.scale, 
                                self.player.media.imgUp:getHeight()*self.player.scale) then
                self.player.alive=false
            end
        end
    end,

    drawPlayerStuff = function(self)
    --TODO check if we want to draw up or down
        if self.player.alive then
            love.graphics.draw(self.player.media.imgUp, self.player.x, self.player.y, 0, self.player.scale, self.player.scale)
        else
            love.graphics.print("Press 'F' to pay respect.\n\nPress 'R' to restart", love.graphics:getWidth()/2-50, love.graphics:getHeight()/2-10)
        end
            --WEAPONS
        for i, boom in ipairs(self.player.booms) do
            boom.anim:draw(self.player.media.boom, boom.x, boom.y)
        end
        for i, fire in ipairs(self.player.fires) do
            love.graphics.draw(self.player.media.fire, fire.x, fire.y, 0,0.5, 0.5)
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
}