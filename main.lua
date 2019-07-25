require("src.physix")
require("src.tiledmap")
debug = true
local anim8 = require "anim8"

-- Weapon Timer
canBreath = true
canBreathTimerMax = 5
canBreathTimer = canBreathTimerMax

fires = {}

canShoot = true
canShootTimerMax = 0.3
-- upgrade possibility: timer down 
canShootTimer = canShootTimerMax

booms = {}

berserkMode = false
berserkDurationMax = 3
berserkDuration = berserkDurationMax

canBerserk = true
canBerserkTimerMax = 15
canBerserkTimer = canBerserkTimerMax

--goblin Timer:
createGoblinTimerMax = 0.4
createGoblinTimer = createGoblinTimerMax
  
goblins = {} -- array of current enemies on screen
ded_goblins = {}

isAlive = true
money = 0

player_scale = 0.3

function love.load(arg)
    --Animations
    boomerangImg = love.graphics.newImage('assets/boomerang.png')
    boomGrid = anim8.newGrid(48, 48, boomerangImg:getWidth(), boomerangImg:getHeight())

    goblinImg = love.graphics.newImage('assets/goblinswordMap.png')
    goblinGrid = anim8.newGrid(65, 64, goblinImg:getWidth(), goblinImg:getHeight())
    dedAnim = anim8.newAnimation(goblinGrid('1-4',5, '4-1', 5), 0.1)
    --1 down, 2 right, 3 up, 4 left, 5 ded
    --1-7 walk, 8-10 stab



    --hit the bodies
    player = { x = 200, y = 710, speed = 200, img = nil }
    player.img = love.graphics.newImage("assets/HeroUp.png")

    berserkParticle = { x = 200, y = 710, speed = 150, img = nil }
    berserkParticle.img = love.graphics.newImage("assets/berserk.png") 

    --hit the floor:
    _G.map = loadTiledMap("assets/tile/", "ebene1tilemap")

    fireImg = love.graphics.newImage("assets/fire.png")
end

function reset()
    boomerangs = {}
    goblins = {}

    -- reset timers
    canShootTimer = canShootTimerMax
    createEnemyTimer = createEnemyTimerMax
    canBerserkTimer = canBerserkTimerMax
    canBreathTimer = canBreathTimerMax
    berserkMode = false
    berserkDuration = berserkDurationMax
    canBerserkTimer = canBerserkTimerMax

    -- reset position
    player.x = 50
    player.y = 710

    -- reset our game state
    money = 0
    isAlive = true
end


function love.update(dt)
    dedAnim:update(dt)
    -- BOUNDARY
    if love.keyboard.isDown("escape") then
        love.event.push("quit")
    end

    if not isAlive and love.keyboard.isDown('r') then
        reset()
    end

    -- MOVEMENT
    if love.keyboard.isDown("left") then
        if player.x > 0 then 
            player.x = player.x - (player.speed*dt)
        end
    elseif love.keyboard.isDown("right") then
        if player.x < (love.graphics.getWidth() - 30) then
            player.x = player.x + (player.speed*dt)
        end
    end

    -- ATTACKS
    canShootTimer = canShootTimer - (1 * dt)
    if canShootTimer < 0 then
      canShoot = true
    end

    canBreathTimer = canBreathTimer - (1 * dt)
    if canBreathTimer < 0 then
      canBreath = true
    end

    canBerserkTimer = canBerserkTimer - (1 * dt)
        if canBerserkTimer < 0 then
          canBerserk = true
    end


    if berserkMode == true then
        berserkDuration = berserkDuration - (1*dt)
        if berserkDuration < 0 then
            berserkMode=false
            berserkDuration = berserkDurationMax
        end
    end

    if love.keyboard.isDown("a") then
        if berserkMode==false then
            if canShoot then 
                newBoom = { anim = anim8.newAnimation(boomGrid('1-8',1), 0.03), x = player.x, y = player.y}
                table.insert(booms, newBoom)
                canShoot=false
                canShootTimer = canShootTimerMax
            end
        else
            newBoom = { anim = anim8.newAnimation(boomGrid('1-8',1), 0.01), x = player.x, y = player.y}
            table.insert(booms, newBoom)
            canShoot=false
            canShootTimer = canShootTimerMax
        end
    end

    if love.keyboard.isDown("s") and canBreath then 
        newFire = { x = player.x + (player.img:getWidth()/2)-140, y = player.y-300, img =fireImg}
        table.insert(fires, newFire)
        canBreath=false
        canBreathTimer = canBreathTimerMax
    end
    --be able to go into mode, reset timer
    if love.keyboard.isDown("space") and canBerserk then 
        berserkMode=true
        canBerserk=false
        canBerserkTimer = canBerserkTimerMax
    end

    -- ENEMIES
    createGoblinTimer = createGoblinTimer - (1*dt)
    if createGoblinTimer < 0 then
        createGoblinTimer = createGoblinTimerMax
        --create a goblin
        randomNumber = math.random(10, love.graphics.getWidth() - 10)
        newGoblin = {anim = anim8.newAnimation(goblinGrid('1-7', 1), 0.07), x = randomNumber-20, y = -10}
        table.insert(goblins, newGoblin)
    end

    -- POSITIONS
    --move boomerangs
    for i, boomerang in ipairs(booms) do
    	boomerang.anim:update(dt)
        boomerang.y = boomerang.y - (350 * dt)
    -- delete boomerangs
        if boomerang.y < 0 then 
            table.remove(booms, i)
        end
    end

    --move fire
    for i , fire in ipairs(fires) do
        fire.y = fire.y - (30 * dt)
    -- delete fire
        if fire.y < 350 then 
            table.remove(fires, i)
        end
    end
    --move goblin
    for i, goblin in ipairs(goblins) do
        goblin.y = goblin.y + (200*dt)
        goblin.anim:update(dt)

        if goblin.y > 850 then
            table.remove(goblins, i)
        end
    end

    -- COLLISION
    -- loop through shorter stuff first!
    for i, goblin in ipairs(goblins) do
        for j, boom in ipairs(booms) do
            if CheckCollision(goblin.x, goblin.y, 64, 64, 
                            boom.x, boom.y, 48, boomerangImg:getHeight()) then

                table.insert(ded_goblins, {x=goblin.x, y=goblin.y})
                table.remove(booms, j)
                table.remove(goblins, i)
                money = money+1
            end
        end
        
        for j, fire in ipairs(fires) do
            if CheckCollision(goblin.x, goblin.y, 64, 64,
                            fire.x, fire.y, fire.img:getWidth(), fire.img:getHeight()) then
                table.remove(goblins, i)
                money = money+1
            end
            money = money+1
        end

        if CheckCollision(goblin.x, goblin.y, 64, 64, 
                            player.x, player.y, player.img:getWidth()*player_scale, player.img:getHeight()*player_scale) 
        and isAlive then
            table.remove(goblins, i)
            -- add this line for actual game
            isAlive = false

        end
    end
    dedAnim:update(dt)
end

function love.draw(dt)
    _G.map:draw()
    --PLAYER
    if isAlive then
    love.graphics.draw(player.img, player.x, player.y, 0, player_scale, player_scale)
    else
        love.graphics.print("Press 'F' to pay respect.\n\nPress 'R' to restart", love.graphics:getWidth()/2-50, love.graphics:getHeight()/2-10)
    end
    --WEAPONS
    for i, boom in ipairs(booms) do
        boom.anim:draw(boomerangImg, boom.x, boom.y)
    end
    for i, fire in ipairs(fires) do
        love.graphics.draw(fire.img, fire.x, fire.y, 0,0.5, 0.5)
    end
    
    for i, goblin in ipairs(goblins) do
        goblin.anim:draw(goblinImg, goblin.x, goblin.y)
    end
    
    for i, ded_goblin in ipairs(ded_goblins) do
        dedAnim:draw(goblinImg,  ded_goblin.x, ded_goblin.y)
    end
    
    if berserkMode == true then
        love.graphics.draw(berserkParticle.img, player.x, player.y-5, 0,1.5,1.5)
    end
end