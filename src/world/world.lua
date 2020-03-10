require("src.world.hud")
World = {}

World.__index = World
function World:Create()
    local this = {
        HUD = Hud:Create(),
        -- player object
        player = nil,
        -- change to 2 or 3
        map = 1,
        -- all enemies currently on the field
        enemies = {},
        -- all dropped items currently on the field
        drops = {},
        x = 32 * 15,
        y = 32 * 30,
        -- level we are currently playing
        currentLvl = 11,
        -- total runtime of a level
        runtime = 0,
        -- true if explosion animation runs
        exploding = false,
        -- true if current level winning condition has been satisfied
        wonLevel = false,
        -- true if spawning should be active
        spawn = true,
        -- position of boss in enemies table
        posOfBoss = 1,
        -- effect stuff
        lightningAlpha = 1,
        lightningActive = false,
        -- Counts keypress after level has been won. Advance to next level if this is >= 0.
        continueButton = nil,
        cityHealthMax = 50,
        cityHealth = 50,
        healthPerc = 1,
        --endless mode flags:
        endlessmode = false,
        shoppedThisIteration = false,
        iteration = 1,
        media = {
            readfont = nil,
            bigreadfont = nil,
            smallreadfont= nil,
            defaultfont = nil,
            fantasyfont = nil,
            bigfantasyfont = nil,
            surprise = {
                img = nil,
                imgP = "assets/deathscreen/whatP.jpg",
                imgD = "assets/deathscreen/whatD.jpg"
            },
            explosion = {
                img = "assets/hud/explo/explosion.png",
                runtime = 0,
                maxRuntime = 1.3,
                scale = 0,
                scaledWidth = 0,
                scaledHeight = 0,
                shakeMagnitude = 5
            }
        },
        levels = {
            --level 1: Kill 10 goblins - tutorial
            {
                enemies = {
                    goblin = {
                        counter = 0, -- counts how many goblins have been murdered in this level
                        goal = 10, -- counts how many goblins we need to murder in this level
                        killToWin = true, -- defeating goblins is necessary to win
                        timer = 0.4, -- inital value is value of timerMax, a changing variable
                        timerMax = 0.4, -- initial value until first mob comes, marks the actual countdown time
                        timerReset = 0.4, -- for resetting timer and timerMax if we die
                        spawnFct = function(self, runtime, dt)
                            -- returns the next timerMax value (waiting time until next goblin spawns)
                            -- Sigmoid mirrored on y axis shifted by 2 along x axis
                            -- Reaches timer = 0.51 in ~46 seconds
                            return (1 / (1 + math.exp(0.1 * runtime))) + 0.5
                        end
                    }
                },
                winType = "kill"
            },
            --level 2: surivive 2 min - goblins are spawning increasingly faster
            {
                enemies = {
                    goblin = {
                        timer = 0.4, -- inital value is value of timerMax, a changing variable
                        timerMax = 0.4, -- initial value until first mob comes, marks the actual countdown time
                        timerReset = 0.4,
                        spawnFct = function(self, runtime, dt)
                            -- returns the next timerMax value (waiting time until next goblin spawns)
                            -- Sigmoid mirrored on y axis shifted by 2 along x axis
                            -- Designed to have a spawn timer climax of about ~0.88 seconds at 2 minutes
                            return (1 / (1 + math.exp(0.02 * runtime))) + 0.7
                        end
                    }
                },
                winType = "endure",
                goal = 90, -- runtime to be reached to win
                goalMax = 90
                -- runtime is counted via self.runtime
            },
            --level 3: collect 10 hints
            {
                enemies = {
                    goblin = {
                        timer = 0.2,
                        timerMax = 0.2,
                        timerReset = 0.2,
                        spawnFct = function(self, runtime, dt)
                            -- Sigmoid mirrored on y axis shifted up by 0.5 (minimum is 0.5)
                            -- This task should be completed within 2 minutes or else the player has a problem
                            return (1 / (1 + math.exp(0.1 * runtime))) + 0.75
                        end
                    }
                },
                counter = 0, -- collected hints counter
                goal = 10,
                goalMax = 10,
                winType = "collect" -- collect 10 hints
            },
            --level 4: Kill 10 zombies
            {
                enemies = {
                    goblin = {
                        timer = 5, -- inital value is value of timerMax, a changing variable
                        timerMax = 5, -- initial value until first mob comes, marks the actual countdown time
                        timerReset = 5,
                        --counter = 0, -- counts how many goblins have been murdered in this level
                        --goal = 10, -- counts how many goblins we need to murder in this level
                        killToWin = false, -- defeating goblins is necessary to win
                        spawnFct = function(self, runtime, dt)
                            -- returns the next timerMax value (waiting time until next goblin spawns)
                            -- Sigmoid mirrored on y axis shifted by 2 along x axis
                            -- They don't spawn as fast
                            return (1 / (1 + math.exp(0.02 * runtime))) + 1
                        end
                    },
                    zombie = {
                        timer = 0.4,
                        timerMax = 0.4,
                        timerReset = 0.4,
                        counter = 0,
                        goal = 10,
                        killToWin = true,
                        spawnFct = function(self, runtime, dt)
                            if self.counter == 0 then
                                return 8 -- let the zombie only spawn every 8 seconds as long as the player does not defeat it
                            else
                                return (1 / (1 + math.exp(0.09 * runtime))) + 2.5
                            end
                        end
                    }
                },
                winType = "kill"
            },
            --level 5: Survive 2 min
            {
                enemies = {
                    goblin = {
                        timer = 0.4, -- inital value is value of timerMax, a changing variable
                        timerMax = 0.4, -- initial value until first mob comes, marks the actual countdown time
                        timerReset = 0.4,
                        spawnFct = function(self, runtime, dt)
                            if runtime <= 60 then
                                -- Normal spawning
                                return (1 / (1 + math.exp(0.02 * runtime))) + 0.8
                            elseif 60 < runtime and runtime <= 61 then
                                -- 20 seconds of peace from goblins from seconds 60 to 80
                                return 20
                            else
                                -- Boom! There comes the storm from second 80 to 120
                                return (1 / (1 + math.exp(0.1 * runtime))) + 0.65
                            end
                        end
                    },
                    zombie = {
                        timer = 3,
                        timerMax = 3,
                        timerReset = 3,
                        spawnFct = function(self, runtime, dt)
                            -- Slow spawn rate of 3 at the beginning, strong ascent around 60,
                            -- maximum spawn rate of ~2 at second 70, then descent back to 3 till about 80
                            return -math.exp(-0.01 * (runtime - 70) ^ 2) + 3
                        end
                    }
                },
                winType = "endure",
                goal = 150, -- runtime to be reached to win
                goalMax = 150
                -- runtime is counted via self.runtime
            },
            --level 6: Survive 2 min
            {
                enemies = {
                    goblin = {
                        -- wait 5 seconds
                        timer = 5, -- inital value is value of timerMax, a changing variable
                        timerMax = 5, -- initial value until first mob comes, marks the actual countdown time#
                        timerReset = 5,
                        spawnFct = function(self, runtime, dt)
                            if runtime <= 6 then
                                return 0.2
                            elseif runtime <= 7 then
                                return 9
                            elseif runtime <= 17 then
                                return 0.15
                            elseif runtime <= 18 then
                                return 9
                            elseif runtime <= 28 then
                                return 0.13
                            elseif runtime <= 29 then
                                return 9
                            elseif runtime <= 39 then
                                return 0.12
                            elseif runtime <= 40 then
                                return 9
                            elseif runtime <= 50 then
                                return 0.1
                            elseif runtime <= 51 then
                                return 9
                            elseif runtime <= 61 then
                                return 0.08
                            elseif runtime <= 62 then
                                return 30
                            else
                                -- Boom! There comes the storm from second 90 to 120
                                return (1 / (1 + math.exp(0.1 * runtime))) + 0.5
                            end
                        end
                    },
                    zombie = {
                        timer = 3,
                        timerMax = 3,
                        timerReset = 3,
                        spawnFct = function(self, runtime, dt)
                            -- Slow spawn rate of 3 at the beginning, strong ascent around 60,
                            -- maximum spawn rate of ~2 at second 70, then descent back to 3 till about 80
                            return -math.exp(-0.01 * (runtime - 70) ^ 2) + 3
                        end
                    }
                },
                winType = "endure",
                goal = 150, -- runtime to be reached to win
                goalMax = 150
                -- runtime is counted via self.runtime
            },
            -- level 7: kill 10 lizzies
            {
                enemies = {
                    goblin = {
                        timer = 7,
                        timerMax = 7,
                        timerReset = 7,
                        killToWin = false,
                        spawnFct = function(self, runtime, dt)
                            -- returns the next timerMax value (waiting time until next goblin spawns)
                            -- Sigmoid mirrored on y axis shifted by 2 along x axis
                            -- They don't spawn as fast
                            return (1 / (1 + math.exp(0.02 * runtime))) + 0.5
                        end
                    },
                    lizard = {
                        timer = 0.4,
                        timerMax = 0.4,
                        timerReset = 0.4,
                        counter = 0,
                        goal = 10,
                        killToWin = true,
                        spawnFct = function(self, runtime, dt)
                            if self.counter == 0 then
                                return 8 -- let the zombies only spawn every 8 seconds as long as the player does not defeat the zombie
                            else
                                return (1 / (1 + math.exp(0.09 * runtime))) + 4
                            end
                        end
                    }
                },
                winType = "kill"
            },
            -- level 8: destroy the door
            {
                enemies = {
                    goblin = {
                        timer = 0.3,
                        timerMax = 0.3,
                        timerReset = 0.3,
                        killToWin = false,
                        spawnFct = function(self, runtime, dt)
                            -- returns the next timerMax value (waiting time until next goblin spawns)
                            -- Sigmoid mirrored on y axis shifted by 2 along x axis
                            -- They don't spawn as fast
                            return (1 / (1 + math.exp(0.02 * runtime))) + 0.5
                        end
                    },
                    zombie = {
                        timer = 4,
                        timerMax = 4,
                        timerReset = 4,
                        killToWin = false,
                        spawnFct = function(self, runtime, dt)
                            return (1 / (1 + math.exp(0.08 * runtime))) + 2.8
                        end
                    },
                    lizard = {
                        timer = 12,
                        timerMax = 12,
                        timerReset = 12,
                        killToWin = false,
                        spawnFct = function(self, runtime, dt)
                            return (1 / (1 + math.exp(0.09 * runtime))) + 4.5
                        end
                    },
                    door = {
                        timer = 0,
                        timerMax = 0,
                        timerReset = 0,
                        killToWin = true,
                        counter = 0,
                        goal = 1,
                        spawnFct = function(self, runtime, dt)
                            return 100000
                        end
                    }
                },
                winType = "kill"
            },
            -- level 9:  defeat the troll king
            {
                enemies = {
                    goblin = {
                        timer = 0.3,
                        timerMax = 0.3,
                        timerReset = 0.3,
                        killToWin = false,
                        spawnFct = function(self, runtime, dt)
                            return 0.05
                        end
                    },
                    zombie = {
                        timer = 2,
                        timerMax = 2,
                        timerReset = 2,
                        killToWin = false,
                        spawnFct = function(self, runtime, dt)
                            return 0.8
                        end
                    },
                    lizard = {
                        timer = 4,
                        timerMax = 4,
                        timerReset = 4,
                        killToWin = false,
                        spawnFct = function(self, runtime, dt)
                            return 1.5
                        end
                    },
                    boss = {
                        timer = 0,
                        timerMax = 0,
                        timerReset = 0,
                        killToWin = true,
                        counter = 0,
                        goal = 1,
                        spawnFct = function(self, runtime, dt)
                            return 100000
                        end
                    }
                },
                winType = "kill"
            },
            -- level 10: endless mode!
            {
                enemies = {
                    goblin = {
                        timer = 0.3,
                        timerMax = 1,
                        timerOffset = 1,
                        spawnFct = function(self, runtime, dt)
                            -- each minute we go down 0.1
                            local nextTimerMax = -0.00167 * runtime + self.timerOffset
                            if nextTimerMax > 0 then
                                return nextTimerMax
                            else
                                return 0.08
                            end
                        end
                    },
                    zombie = {
                        timer = 30,
                        timerMax = 3.7,
                        timerOffset = 3.7,
                        spawnFct = function(self, runtime, dt)
                            -- each minute we go down 0.1
                            local nextTimerMax = -0.00167 * runtime + self.timerOffset
                            if nextTimerMax > 0.5 then
                                return nextTimerMax
                            else
                                return 0.5
                            end
                        end
                    },
                    lizard = {
                        timer = 70, -- end of wave 4
                        timerMax = 5.5,
                        timerOffset = 5.5,
                        startedSpawning = false,
                        spawnFct = function(self, runtime, dt)
                            -- each minute we go down 0.2
                            self.startedSpawning = true
                            local nextTimerMax = -0.0033 * runtime + self.timerOffset
                            if nextTimerMax > 1 then
                                return nextTimerMax
                            else
                                return 1
                            end
                        end
                    },
                    boss = {
                        timer = 10000,
                        timerMax = 10000,
                        timerOffset = 10000,
                        spawnFct = function(self, runtime, dt)
                            return self.timerOffset
                        end
                    }
                },
                winType = "endure",
                goal = 30,
                goalMax = 30
            },
            --menu (always last)
            {
                enemies = {},
                counter = 0,
                goal = 100000, -- no goblin will spawn the collectable in this level
                winType = "collect"
            }
        },
        --some default values to reset back to for enemy spawntimers/stats:
        timerG = 0.3,
        timerZ = 30,
        timerL = 70,
        timerB = 10000,
        statsRaw = {
            goblin = require("src.enemies.goblin"),
            zombie = require("src.enemies.zombie"),
            lizard = require("src.enemies.lizard"),
            door = require("src.enemies.door"),
            boss = require("src.enemies.boss"),
            fireball = require("src.enemies.fireball")
        },
        itemsRaw = {
            items = require("src.items")
        }
    }
    setmetatable(this, World)
    return this
end
------------ LOADING --------------

--enemies are expected to implement:
--media.img(filepath, string)
--media width (the width of the enemy image in pixels, int)
--media height (the height of the enemy image in pixels, int)
function World:loadEnemies()
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
end

function World:loadPlayer()
    --safe away default values to reset to:
    PLAYERRAW = require("src.player")
    self.player = Shallowcopy(PLAYERRAW)
    --load media:
    for key, imgPath in pairs(self.player.media) do
        -- this if is only needed when game is played through and restarted
        if type(imgPath) == "string" then 
            self.player.media[key] = love.graphics.newImage(imgPath)
        end
    end
    --load animations:
    self.player.media.boomGrid =
        ANIMATE.newGrid(48, 48, self.player.media.boom:getWidth(), self.player.media.boom:getHeight())
    self.player.media.playerGrid =
        ANIMATE.newGrid(64, 64, self.player.media.img:getWidth(), self.player.media.img:getHeight())
    self.player.upRightAnim = ANIMATE.newAnimation(self.player.media.playerGrid("1-8", 5), 0.1)
    self.player.upLeftAnim = self.player.upRightAnim:clone():flipH()
    self.player.downAnim = ANIMATE.newAnimation(self.player.media.playerGrid("1-9", 11), 0.1)
    self.player.anim = self.player.upLeftAnim
end

function World:loadMedia()
    self.media.explosion.img = love.graphics.newImage(self.media.explosion.img)
    self.media.surprise.img = love.graphics.newImage(self.media.surprise.imgP)
    self.media.surprise.imgP = love.graphics.newImage(self.media.surprise.imgP)
    self.media.surprise.imgD = love.graphics.newImage(self.media.surprise.imgD)
    self.media.defaultfont = love.graphics.getFont()
    self.media.smallreadfont = love.graphics.newFont("assets/font/Bagnard.otf", 12)
    self.media.readfont = love.graphics.newFont("assets/font/Bagnard.otf", 20)
    self.media.bigreadfont = love.graphics.newFont("assets/font/Bagnard.otf", 30)
    self.media.fantasyfont = love.graphics.newFont("assets/font/Komi.ttf", 15)
    self.media.bigfantasyfont = love.graphics.newFont("assets/font/Komi.ttf", 30)
end

function World:loadHud()
    self.HUD:loadHudImages()
end

function World:loadItems()
    for key, item in pairs(self.itemsRaw.items) do
        item.img = love.graphics.newImage(item.img)
    end
end
------------ UPDATING --------------
--enemies are expected to implement:
--update(anim function)
--alive (bool)
--reward (int)
function World:updateEnemies(dt)
    for i, enemy in ipairs(self.enemies) do
        if self.currentLvl >= 9 then
            if enemy.name == "boss" then
                self.posOfBoss = i
            end
            if enemy.name ~= "fireball" then
                enemy:update(dt)
            else
                assert(self.currentLvl >= 9, "updateEnemies, tried calling fireball enemy in lvl " .. self.currentLvl)
                -- first enemy is usually boss, but if he dies right in this moment, then it can also be a fireball
                enemy:update(dt, self.enemies[self.posOfBoss].x, self.enemies[self.posOfBoss].y + 10)
            end
        else 
            enemy:update(dt)
        end
        if not enemy.alive then
            table.remove(self.enemies, i)
            enemy:drop()
        end
    end
end

function World:spawnEnemies(dt)
    self.runtime = self.runtime + dt
    if self.spawn then
        for enemyName, enemySpawnInfo in pairs(self.levels[self.currentLvl].enemies) do
            enemySpawnInfo.timer = enemySpawnInfo.timer - dt
            if enemySpawnInfo.timer <= 0 and not self.wonLevel then
                enemySpawnInfo.timerMax = enemySpawnInfo:spawnFct(self.runtime, dt)
                local newEnemy = self.statsRaw[enemyName]:newSelf(self.currentLvl)
                table.insert(self.enemies, newEnemy)
                enemySpawnInfo.timer = enemySpawnInfo.timerMax
            end
        end
    end
end

function World:upscaleExplosion(dt, maxRuntime)
    if self.media["explosion"].runtime + dt < maxRuntime then
        -- +0.1 needed, without it the scaling wouldn't start
        self.media["explosion"].scale = (self.media["explosion"].scale + 0.1) ^ self.media["explosion"].runtime
        self.media["explosion"].runtime = self.media["explosion"].runtime + dt
        self.media["explosion"].scaledWidth = self.media["explosion"].scale * self.media["explosion"].img:getWidth()
        self.media["explosion"].scaledHeight = self.media["explosion"].scale * self.media["explosion"].img:getHeight()
    else
        if self.player.bursting then
            self.player.bursting = false
        end
        self.exploding = false
        self.media["explosion"].runtime = 0
        self:checkStartGame()
    end
end

function World:checkEnemyExplosionCollision(startX, startY)
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
            if enemy.name == "goblin" then
                enemy.y = enemy.y - self.media["explosion"].scale
            elseif enemy.name == "lizard" then
                enemy.y = (enemy.y - self.media["explosion"].scale) * 0.003
            end
            enemy:getHit(1)
        end
    end
end

function World:updateExplosion(dt, startX, startY, maxRuntime)
    if self.exploding then
        self:upscaleExplosion(dt, maxRuntime)
        self:checkEnemyExplosionCollision(startX, startY)
    end
end

function World:checkStartGame()
    --this function is called after the explosion, which is a skill or the intro sequence
    -- only if its the intro sequence the explo should trigger a game start, which is true when we are in the menu:
    if self.currentLvl == #self.levels then
        InitGame(1, 6)
    end
end

function World:dropHeart(enemy)
    local heart = Shallowcopy(self.itemsRaw.items["heart"])
    heart.x = enemy.x
    heart.y = enemy.y
    table.insert(self.drops, heart)
end

function World:dropHint(enemy)
    local importantCoin = Shallowcopy(self.itemsRaw.items["importantCoin"])
    importantCoin.x = enemy.x
    importantCoin.y = enemy.y
    table.insert(self.drops, importantCoin)
end

function World:checkBoomCollision(enemy, dt)
    -- boom collision
    for j, boom in ipairs(self.player.booms) do
        if CheckCollision(enemy:getLeftX(), enemy:getTopY(), enemy.width, enemy.height, boom.x, boom.y, 48, 48) then
            enemy:getHit(boom.dmg, dt)
            table.remove(self.player.booms, j)
        end
    end
end

function World:checkFireCollision(enemy, dt)
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
end

function World:checkSonicRingCollision(enemy, dt)
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
end

function World:checkPlayerCollision(enemy, dt)
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
        if not self.player.inSonic then
            self.player:getHit()
        else
            enemy:die()
        end
    end
end

function World:checkItemCollision(dt)
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
            item:effect(self.currentLvl)
            table.remove(self.drops, i)
        end
        -- boom collision
        for j, boom in ipairs(self.player.booms) do
            if CheckCollision(item.x, item.y, item.img:getWidth(), item.img:getHeight(), boom.x, boom.y, 48, 48) then
                item:effect(self.currentLvl)
                table.remove(self.drops, i)
            end
        end
    end
end

function World:handleCollisions(dt)
    for i, enemy in ipairs(self.enemies) do
        if not enemy.gotHit and enemy.curAnim ~= "dying" then
            self:checkBoomCollision(enemy, dt)
            self:checkFireCollision(enemy, dt)
            self:checkSonicRingCollision(enemy, dt)
            self:checkPlayerCollision(enemy, dt)
        end
    end
    self:checkItemCollision(dt)
end

function World:updateHealth()
    self.healthPerc = self.cityHealth / self.cityHealthMax
    if self.healthPerc < 0 then
        self.alive = false
        self:selectDeathScreen()
        GAMESTATE = 3
    end
end

function World:selectDeathScreen()
    if math.random(0, 1) >= 1 then
        self.media.surprise.img = self.media.surprise.imgD
    else
        self.media.surprise.img = self.media.surprise.imgP
    end
end

function World:winCondition(counter, goal)
    if counter >= goal then
        return true
    end
    return false
end

function World:checkWinCondition(dt)
    -- Determine for each winning type whether its goal was reached
    local winConditionSatisfied = false
    if self.levels[self.currentLvl].winType == "kill" then
        for name, enemyInfo in pairs(self.levels[self.currentLvl].enemies) do
            if enemyInfo.killToWin then
                winConditionSatisfied = self:winCondition(enemyInfo.counter, enemyInfo.goal) or winConditionSatisfied
            end
        end
    elseif self.levels[self.currentLvl].winType == "collect" then
        winConditionSatisfied =
            self:winCondition(self.levels[self.currentLvl].counter, self.levels[self.currentLvl].goal)
    elseif self.levels[self.currentLvl].winType == "endure" then
        winConditionSatisfied = self:winCondition(self.runtime, self.levels[self.currentLvl].goal)
    else
        print("WinCondition has not been specified for this level and was: " .. self.levels[self.currentLvl].winType)
    end
    if winConditionSatisfied and not self.wonLevel then
        -- set flag that we won
        self.wonLevel = true
        -- kill all remaining enemies
        for i, enemy in pairs(self.enemies) do
            enemy:die()
        end
        -- stop enemies from spawning
        WORLD.spawn = false
    end
    if self.wonLevel then
        if
            SUIT.ImageButton(
                WORLD.HUD.media.hud.borderSmall,
                240 - (self.HUD.media.hud.borderSmall:getWidth() / 2),
                480 - (self.HUD.media.hud.borderSmall:getHeight() / 2)
            ).hit
         then
            if self.endlessmode then
                self:nextEndlessMode()
            else
                InitGame(self.currentLvl, 6)
                self.player:reset()
            end
        end
    end
end

function World:reset()
    --cleans up tables, despawning enemies, goal counter, despawn everything that was on the field
    self.enemies = {}
    self.drops = {}
    self.player:reset(false)
    self.runtime = 0
    self.enemies = {}
    self.drops = {}
    self.wonLevel = false
    self.spawn = true
    self.player.hearts = self.player.maxHearts
    if not self.endlessmode then
        self.cityHealth = self.cityHealthMax
        -- reset goals
        if self.levels[self.currentLvl].winType == "kill" then
            for name, enemyInfo in pairs(self.levels[self.currentLvl].enemies) do
                if enemyInfo.killToWin then
                    enemyInfo.counter = 0
                end
            end
        elseif self.levels[self.currentLvl].winType == "endure" then
            self.levels[self.currentLvl].goal = self.levels[self.currentLvl].goalMax
        elseif self.levels[self.currentLvl].winType == "collect" then
            self.levels[self.currentLvl].goal = self.levels[self.currentLvl].goalMax
            self.levels[self.currentLvl].counter = 0
        end
        --reset timers
        for _, info in pairs(self.levels[self.currentLvl].enemies) do
            info.timer = info.timerReset
            info.timerMax = info.timerReset
        end
    else
        --resets buyable city hp if in endlessmode
        SHOP.clicked = false
    end
end
------------ENDLESS MODE -------------
function World:nextEndlessMode()
    if not self.shoppedThisIteration then
        MUSIC:startMusic("shop")
        InitGame(WORLD.currentLvl, 4)
    else
        self.shoppedThisIteration = false
        self:updateIterationValues()
        self:resetTimer()
        self.player:reset(false)
        self:updateEnvironment() --set map and music
        InitGame(10, 2)
    end
end

function World:updateIterationValues()
    self.levels[10].goal = self.levels[10].goal * 1.5
    self.iteration = self.iteration + 1
end

function World:resetTimer()
    -- update timer for goblin: each iteration timerOffset is set down 0.05.
    -- In each iteration the first goblin comes after timerG time.
    -- The goblins from the second one onwards start at timerOffset timing.
    self.levels[10].enemies.goblin.timer = self.timerG
    self.levels[10].enemies.goblin.timerOffset = self.levels[10].enemies.goblin.timerOffset - 0.08
    self.levels[10].enemies.goblin.timerMax = self.levels[10].enemies.goblin.timerOffset

    -- Update timer for zombies:
    -- Reduce their initial spawn time by 6 seconds every time (reaches 0 after 5 waves)
    if self.timerZ >= 0 then
        self.timerZ = self.timerZ - 6
    end
    self.levels[10].enemies.zombie.timer = self.timerZ
    self.levels[10].enemies.zombie.timerOffset = self.levels[10].enemies.zombie.timerOffset - 0.07
    self.levels[10].enemies.zombie.timerMax = self.levels[10].enemies.zombie.timerOffset

    -- Update timer for Lizzies
    -- Start spawning after waiting 70 seconds (so from wave 4 onwards)
    if self.levels[10].enemies.lizard.startedSpawning then
        self.timerL = self.timerL / 2
    end
    self.levels[10].enemies.lizard.timer = self.timerL
    self.levels[10].enemies.lizard.timerOffset = self.levels[10].enemies.lizard.timerOffset - 0.1
    self.levels[10].enemies.lizard.timerMax = self.levels[10].enemies.lizard.timerOffset

    -- Update timer for boss
    -- Starts spawning at wave 5, then every second level, starting from level 9 with enemies
    if self.iteration >= 5 then
        if self.iteration % 2 == 1 then
            if self.iteration >= 9 then
                -- all odd levels greater equal 9 spawn the boss and enemies
                WORLD.spawn = true
            else
                -- levels 5 and 7 spawn the boss without enemies
                WORLD.spawn = false
            end
            self.levels[10].enemies.boss.timer = 0
        else
            -- all even levels greater 5 are normal
            WORLD.spawn = true
            self.levels[10].enemies.boss.timer = self.timerB
        end
        -- in every level above 5, we half the spawn time of the boss, so in wave 12 the boss will spawn every 78 seconds
        if self.levels[10].enemies.boss.timerOffset >= 80 then
            self.levels[10].enemies.boss.timerOffset = self.levels[10].enemies.boss.timerOffset / 2
            self.levels[10].enemies.boss.timerMax = self.levels[10].enemies.boss.timerOffset
        end
    end
end

function World:updateEnvironment()
    if self.iteration <= 3 then
        MUSIC:startMusic("villageBattle")
    elseif self.iteration <= 6 then
        MUSIC:startMusic("mountainBattle")
        WORLD.map = 2
        LoadMap()
    elseif self.iteration <= 9 then
        MUSIC:startMusic("caveBattle")
        WORLD.map = 3
        LoadMap()
    else
        MUSIC:startMusic("finalBattle")
    end
end
------------ DRAWING --------------
function World:drawPlayerStuff()
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
        if self.player.gotHit then
            love.graphics.setColor(1, 0, 0, 1)
            self:drawScreenShake(-2, 2)
        end
        self.player.anim:draw(self.player.media.img, self.player.x, self.player.y)
        love.graphics.setColor(255, 255, 255, 255)
    end

    --WEAPONS
    for i, boom in ipairs(self.player.booms) do
        boom.anim:draw(self.player.media.boom, boom.x, boom.y)
    end
    for i, fire in ipairs(self.player.fires) do
        if fire.verticalDir == 1 then
            love.graphics.draw(self.player.media.fire, fire.x, fire.y)
        else
            love.graphics.draw(self.player.media.fire, fire.x, fire.y, 0, 1, -1, 0, self.player.media.fire:getHeight())
        end
    end
    --ABILITIES
    if self.player.inBerserk == true then
        love.graphics.draw(self.player.media.berserk, self.player.x, self.player.y - 5, 0, 1.5, 1.5)
        self:drawScreenShake(-2, 2)
    end
end

function World:drawEnemyStuff()
    for i, enemy in ipairs(self.enemies) do
        if enemy.gotHit then
            love.graphics.setColor(1, 0, 0, 1)
            enemy.anim:draw(enemy.media.img, enemy.x, enemy.y)
            love.graphics.setColor(255, 255, 255, 255)
        else
            if enemy.name == "door" then
                -- draw door animations (aka none)
                love.graphics.draw(enemy.media.img, enemy.x, enemy.y)
            elseif enemy.name == "boss" then
                enemy.anim:draw(enemy.media.img, enemy.x, enemy.y)
                enemy:drawDanceEffects()
            elseif enemy.name ~= "fireball" then
                -- draw normal animations
                enemy.anim:draw(enemy.media.img, enemy.x, enemy.y)
            end
        end
    end
end

function World:drawFire()
    if self.currentLvl == 9 or self.currentLvl == 10 then
        for i, enemy in ipairs(self.enemies) do
            if enemy.name == "fireball" then
                if enemy.gotHit then
                    love.graphics.setColor(1, 0, 0, 1)
                    enemy.anim:draw(enemy.media.img, enemy.x, enemy.y)
                    love.graphics.setColor(255, 255, 255, 255)
                else
                    enemy.anim:draw(enemy.media.img, enemy.x, enemy.y)
                end
            end
        end
    end
end

function World:drawItemStuff()
    for i, item in ipairs(self.drops) do
        love.graphics.draw(item.img, item.x, item.y)
    end
end

function World:drawHud()
    self.HUD:drawHud(self.player, self.levels[self.currentLvl], self.runtime, self.healthPerc, self)

    if self.endlessmode == true then
        self.HUD:drawIteration(self.iteration, self.x)
    end
end

function World:drawHealthBar()
    self.HUD:drawHealthBar(self.healthPerc)
end

function World:drawScreenShake(min, max)
    local xShift = love.math.random(min, max)
    local yShift = love.math.random(min, max)
    love.graphics.translate(xShift, yShift)
end

function World:drawLightning()
    -- color the screen suddenly white, then fade back into standard colors
    if self.lightningActive then
        if self.lightningAlpha >= 0 then
            self.lightningAlpha = self.lightningAlpha - 0.1
        end
        love.graphics.setBackgroundColor(0.9, 0.9, 0.9, 0)
        love.graphics.setColor(0.9, 0.9, 0.9, self.lightningAlpha)
        if self.lightningAlpha <= 0 then
            love.graphics.setColor(255, 255, 255, 255)
            love.graphics.setBackgroundColor(0, 0, 0, 1)
            self.lightningAlpha = 1
            self.lightningActive = false
        end
    end
end

function World:drawExplosionStuff(startX, startY)
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
end

function World:drawWinScreen()
    if self.wonLevel then
        self.HUD:drawWinScreen()
    end
end

function World:drawHitBoxes(explosionX, explosionY)
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
