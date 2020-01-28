return {
    player = nil,
    -- all enemies currently on the field
    -- change to 2 or 3
    map = 1,
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
    -- true if spawning should be active
    spawn = true,
    -- effect stuff
    lightningAlpha = 1,
    lightningActive = false,
    -- Counts keypress after level has been won. Advance to next level if this is >= 0.
    continueButton = nil,
    cityHealthMax = 100,
    cityHealth = 100,
    healthPerc = 1,
    --endless mode flags:
    endlessmode = false,
    shoppedThisIteration = false,
    iteration = 1,
    media = {
        readfont = nil,
        bigreadfont = nil,
        defaultfont = nil,
        fantasyfont = nil,
        bigfantasyfont = nil,
        surprise = {
            img = nil,
            imgP = "assets/deathscreen/whatP.jpg",
            imgD = "assets/deathscreen/whatD.jpg"
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
            xOffset = 75,
            yOffset = 850,
            skillDistance = 80,
            healthX = 100,
            healthY = 920,
            moneyX = 310,
            moneyY = 5,
            heartX = -50,
            heartY = 755,
            heartDistance = 40,
            letterX = 80, --xoffset + 5
            letterY = 855, --yoffset + 5
            letterDistance = 80, --same as skillDistance
            -- KILL COUNTERS
            counterX = 420,
            counterY = 110
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
        --level1: Kill 10 goblins - tutorial
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
                    goal = 7,
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
                            local tmp = (1 / (1 + math.exp(0.02 * runtime))) + 0.8
                            return tmp
                        elseif 60 < runtime and runtime <= 61 then
                            -- 20 seconds of peace from goblins from seconds 60 to 80
                            return 20
                        else
                            -- Boom! There comes the storm from second 80 to 120
                            local tmp = (1 / (1 + math.exp(0.1 * runtime))) + 0.65
                            return tmp
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
                        local tmp = -math.exp(-0.01 * (runtime - 70) ^ 2) + 3
                        return tmp
                    end
                }
            },
            winType = "endure",
            goal = 145, -- runtime to be reached to win
            goalMax = 145
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
                    spawnWaveIndex = 1,
                    spawnWavePattern = {0.2, 0.13, 0.12, 0.1, 0.1, 0.1},
                    currentDuration = 0, -- counts the duration of the current spawn wave
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
                        elseif runtime <= 120 then
                            -- Boom! There comes the storm from second 90 to 120
                            return (1 / (1 + math.exp(0.1 * runtime))) + 0.5
                        else
                            return "goblin spawn failed"
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
                        local tmp = -math.exp(-0.01 * (runtime - 70) ^ 2) + 3
                        return tmp
                    end
                }
            },
            winType = "endure",
            goal = 145, -- runtime to be reached to win
            goalMax = 145
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
                    goal = 7,
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
    timerG = 0.3,
    timerZ = 30,
    timerL = 70,
    timerB = 10000,
    statsRaw = {
        goblin = require("src.goblin"),
        zombie = require("src.zombie"),
        lizard = require("src.lizard"),
        door = require("src.door"),
        boss = require("src.boss"),
        fireball = require("src.fireball")
    },
    itemsRaw = {
        items = require("src.items")
    },
    ------------ LOADING --------------

    --enemies are expected to implement:
    --media.img(filepath, string)
    --media width (the width of the enemy image in pixels, int)
    --media height (the height of the enemy image in pixels, int)
    loadMenu = function(self)
        local enemyNum = math.random(0, 100)
        if enemyNum < 70 then
            local goblin = {
                timer = 0.0,
                timerMax = 0.0,
                spawnFct = function(self, runtime)
                    return 0.0
                end
            }
            self.levels[#self.levels].enemies["goblin"] = goblin
        elseif enemyNum < 90 then
            local zombie = {
                timer = 0.0,
                timerMax = 0.0,
                spawnFct = function(self, runtime)
                    return 0.0
                end
            }
            self.levels[#self.levels].enemies["zombie"] = zombie
        else
            local lizard = {
                timer = 0.0,
                timerMax = 0.0,
                spawnFct = function(self, runtime)
                    return 0.0
                end
            }
            self.levels[#self.levels].enemies["lizard"] = lizard
        end
    end,
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
        self.player.upRightAnim = ANIMATE.newAnimation(self.player.media.playerGrid("1-8", 5), 0.1)
        self.player.upLeftAnim = self.player.upRightAnim:clone():flipH()

        self.player.downAnim = ANIMATE.newAnimation(self.player.media.playerGrid("1-9", 11), 0.1)
        self.player.anim = self.player.upLeftAnim
    end,
    loadMedia = function(self)
        self.media.explosion.img = love.graphics.newImage(self.media.explosion.img)
        self.media.surprise.imgP = love.graphics.newImage(self.media.surprise.imgP)
        self.media.surprise.imgD = love.graphics.newImage(self.media.surprise.imgD)
        self.media.defaultfont = love.graphics.getFont()
        self.media.readfont = love.graphics.newFont("assets/font/Bagnard.otf", 20)
        self.media.bigreadfont = love.graphics.newFont("assets/font/Bagnard.otf", 30)
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
            if enemy.name ~= "fireball" then
                enemy:update(dt)
            else
                assert(self.currentLvl >= 9, "updateEnemies, tried calling fireball enemy in lvl " .. self.currentLvl)
                -- first enemy is usually boss, but if he dies right in this moment, then it can also be a fireball
                enemy:update(dt, self.enemies[1].x, self.enemies[1].y + 10)
            end
            if not enemy.alive then
                table.remove(self.enemies, i)
                enemy:drop()
            end
        end
    end,
    spawnEnemies = function(self, dt)
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
                if enemy.name == "goblin" then
                    enemy.y = enemy.y - self.media["explosion"].scale
                elseif enemy.name == "lizard" then
                    enemy.y = (enemy.y - self.media["explosion"].scale) * 0.003
                end
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
        if self.currentLvl == #self.levels then
            InitGame(1, 6)
        end
    end,
    dropHeart = function(self, enemy)
        local heart = Shallowcopy(self.itemsRaw.items["heart"])
        heart.x = enemy.x
        heart.y = enemy.y
        table.insert(self.drops, heart)
    end,
    dropHint = function(self, enemy)
        local importantCoin = Shallowcopy(self.itemsRaw.items["importantCoin"])
        importantCoin.x = enemy.x
        importantCoin.y = enemy.y
        table.insert(self.drops, importantCoin)
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
            if not self.player.inSonic then
                self.player:getHit()
            else
                enemy:die()
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
            self.player:changeVerticalDirDown()
        elseif love.keyboard.isDown("up") then
            self.player:changeVerticalDirUp()
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
    winCondition = function(self, counter, goal)
        if counter >= goal then
            return true
        end
        return false
    end,
    checkWinCondition = function(self, dt)
        -- Determine for each winning type whether its goal was reached
        local winConditionSatisfied = false
        if self.levels[self.currentLvl].winType == "kill" then
            for name, enemyInfo in pairs(self.levels[self.currentLvl].enemies) do
                if enemyInfo.killToWin then
                    winConditionSatisfied =
                        self:winCondition(enemyInfo.counter, enemyInfo.goal) or winConditionSatisfied
                end
            end
        elseif self.levels[self.currentLvl].winType == "collect" then
            winConditionSatisfied =
                self:winCondition(self.levels[self.currentLvl].counter, self.levels[self.currentLvl].goal)
        elseif self.levels[self.currentLvl].winType == "endure" then
            winConditionSatisfied = self:winCondition(self.runtime, self.levels[self.currentLvl].goal)
        else
            print(
                "WinCondition has not been specified for this level and was: " .. self.levels[self.currentLvl].winType
            )
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
                    WORLD.media.hud.borderSmall,
                    240 - (self.media.hud.borderSmall:getWidth() / 2),
                    480 - (self.media.hud.borderSmall:getHeight() / 2)
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
    end,
    reset = function(self) --cleans up tables, despawning enemies, goal counter
        -- despawn everything that was on the field
        self.enemies = {}
        self.drops = {}
        self.player.booms = {}
        self.player.fires = {}
        self.player.sonicRings = {}

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
        end

        --reset timers
        for _, info in pairs(self.levels[self.currentLvl].enemies) do
            info.timer = info.timerReset
            info.timerMax = info.timerReset
        end
    end,
    ------------ENDLESS MODE -------------
    nextEndlessMode = function(self)
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
    end,
    updateIterationValues = function(self)
        self.levels[10].goal = self.levels[10].goal * 1.5
        self.iteration = self.iteration + 1
    end,
    resetTimer = function(self)
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
    end,
    updateEnvironment = function(self)
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
    end,
    drawFire = function(self)
        if self.currentLvl == 9 then
            for i, enemy in ipairs(self.enemies) do
                if enemy.name=="fireball" then
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
        --if self.currentLvl == 8 or self.currentLvl == 9 then
        --    self:drawKillCounters(true)
        --else
        --    self:drawKillCounters(false)
        --end
        self:drawLevelTimer()
        self:drawCollectCounter()
        if self.endlessmode == true then
            self:drawIteration()
        end
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
        love.graphics.setFont(WORLD.media.bigreadfont)
        love.graphics.print(self.player.money, self.media.hudPos.moneyX + 90, self.media.hudPos.moneyY + 35)
    end,
    drawHearts = function(self) --a heart for kids
        for heart in Range(self.player.hearts) do
            love.graphics.draw(
                self.media.hud.heart,
                self.media.hudPos.heartX + self.media.hudPos.heartDistance,
                --self.media.hudPos.heartX + (self.media.hudPos.heartDistance * heart - 1),
                self.media.hudPos.heartY + self.media.hudPos.heartDistance * heart - 1,
                --self.media.hudPos.heartY,
                0,
                0.5,
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
            -- scale down the kill counter a little, or a little bit more if it is the door
            local scaling = love.math.newTransform(0, 0, 0, 0.8, 0.8, 0, 0)
            local doorScaling =
                love.math.newTransform(
                self.media.hudPos.counterX - (self.media.hud.brown:getWidth() / 2) - 3,
                self.media.hudPos.counterY - 3,
                0,
                0.1,
                0.2,
                0,
                0
            )
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
                    if enemyName == "door" then
                        love.graphics.push()
                        love.graphics.applyTransform(doorScaling)
                    end
                    love.graphics.draw(
                        self.statsRaw[enemyName].media.img,
                        self.statsRaw[enemyName].portrait,
                        self.media.hudPos.counterX,
                        self.media.hudPos.counterY * enemyCount
                    )
                    if enemyName == "door" then
                        love.graphics.pop()
                    end
                    -- write killCounter
                    love.graphics.setFont(WORLD.media.bigreadfont)
                    --local text =
                    --    (bossMode and enemySpawnInfo.hp) or (enemySpawnInfo.counter .. "/" .. enemySpawnInfo.goal)
                    love.graphics.printf(
                        enemySpawnInfo.counter .. "/" .. enemySpawnInfo.goal, --text,
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
    drawIteration = function(self)
        love.graphics.print(self.iteration, self.x / 2, 20)
    end,
    drawLevelTimer = function(self)
        if self.levels[self.currentLvl].winType == "endure" then
            -- scale down the kill counter a little, make it gradually more red until we reach zero
            local scaling = love.math.newTransform(0, 0, 0, 0.8, 0.8, 0, 0)
            love.graphics.push()
            love.graphics.applyTransform(scaling)
            love.graphics.setFont(WORLD.media.bigfantasyfont)
            if self.runtime >= self.levels[self.currentLvl].goal then
                -- runtime goal reached
                local time = DisplayTime(0)
                love.graphics.printf(time, self.media.hudPos.counterX + 5, self.media.hudPos.counterY, 150, "left")
            else
                -- runtime goal not reached
                love.graphics.setColor(
                    1,
                    1 - self.runtime / self.levels[self.currentLvl].goal,
                    1 - self.runtime / self.levels[self.currentLvl].goal,
                    1
                )
                local time = DisplayTime(self.levels[self.currentLvl].goal - self.runtime)
                love.graphics.printf(time, self.media.hudPos.counterX + 5, self.media.hudPos.counterY, 150, "left")
                love.graphics.setColor(255, 255, 255, 255)
            end
            love.graphics.pop()
        end
    end,
    drawCollectCounter = function(self)
        if self.levels[self.currentLvl].winType == "collect" then
            -- scale down the kill counter a little, make it gradually more red until we reach zero
            local scaling = love.math.newTransform(0, 0, 0, 0.8, 0.8, 0, 0)
            love.graphics.push()
            love.graphics.applyTransform(scaling)
            love.graphics.setFont(WORLD.media.bigfantasyfont)
            -- let background be transparent black
            love.graphics.setColor(0, 0, 0, 0.5)
            love.graphics.rectangle(
                "fill",
                self.media.hudPos.counterX,
                self.media.hudPos.counterY,
                self.media.hud.brown:getWidth(),
                self.media.hud.brown:getHeight()
            )
            -- reset black color
            love.graphics.setColor(255, 255, 255, 255)
            -- draw brown frame
            love.graphics.draw(self.media.hud.brown, self.media.hudPos.counterX, self.media.hudPos.counterY)
            -- draw enemy pic into frame
            love.graphics.draw(
                self.itemsRaw.items["importantCoin"].img,
                self.media.hudPos.counterX +
                    (self.media.hud.brown:getWidth() - self.itemsRaw.items["importantCoin"].img:getWidth()) / 2,
                self.media.hudPos.counterY +
                    (self.media.hud.brown:getHeight() - self.itemsRaw.items["importantCoin"].img:getHeight()) / 2
            )
            -- write collectCounter
            love.graphics.setFont(WORLD.media.bigfantasyfont)
            love.graphics.printf(
                self.levels[self.currentLvl].counter .. "/" .. self.levels[self.currentLvl].goal,
                self.media.hudPos.counterX + self.media.hud.brown:getWidth() + 5,
                self.media.hudPos.counterY,
                (500 - (0.8 * self.media.hudPos.counterX + 0.8 * self.media.hud.brown:getWidth())),
                "center"
            )
            love.graphics.pop()
        end
    end,
    drawScreenShake = function(self, min, max)
        local xShift = love.math.random(min, max)
        local yShift = love.math.random(min, max)
        love.graphics.translate(xShift, yShift)
    end,
    --TODO: fix me
    drawLightning = function(self)
        --TODO: color the screen suddenly white, then fade back into standard colors
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
