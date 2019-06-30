require("src.physix")
require("src.tiledmap")
debug = true


-- Weapon Timer
canBreath = true
canBreathTimerMax = 5
canBreathTimer = canBreathTimerMax

fireImg = nil
fires = {

}

canShoot = true
canShootTimerMax = 0.3
-- upgrade possibility: timer down 
canShootTimer = canShootTimerMax

boomImg = nil   
boomerangs = {

}

berserkMode = false
berserkDuration = 3

canBerserk = true
canBerserkTimerMax = 20
canBerserkTimer = canBerserkTimerMax

--goblin Timer:
createGoblinTimerMax = 0.4
createGoblinTimer = createGoblinTimerMax
  
-- More images
goblinImg = nil -- Like other images we'll pull this in during out love.load function
  
-- More storage
goblins = {} -- array of current enemies on screen



isAlive = true
money = 0


function love.load(arg)

    _G.map = loadTiledMap("assets/tile/ebene1", "ebene1tilemap")
    player = { x = 200, y = 710, speed = 200, img = nil }
    player.img = love.graphics.newImage("assets/up.png")

    berserkParticle = { x = 200, y = 710, speed = 150, img = nil }
    berserkParticle.img = love.graphics.newImage("assets/berserk.png")

    grass = { x = 200, y = 710, speed = 150, img = nil }
    grass.img = love.graphics.newImage("assets/berserk.png")



    goblinImg = love.graphics.newImage("assets/goblinsword.png")

    boomImg = love.graphics.newImage("assets/bullet006.0000.png")
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
    berserkDuration = 5

    -- reset position
    player.x = 50
    player.y = 710

    -- reset our game state
    money = 0
    isAlive = true
end

function love.update(dt)

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
        if player.x < (love.graphics.getWidth() - player.img:getWidth()) then
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

    if berserkMode==true then
        berserkDuration = berserkDuration - (1*dt)
        if berserkDuration < 0 then
            canBerserkTimer = canBerserkTimerMax
            berserkDuration = 5
            berserkMode=false
        end
    end

    
    if love.keyboard.isDown("a") then
        if berserkMode==false then
            if canShoot then 
                newBoomerang = { x = player.x + (player.img:getWidth()/2), y = player.y, img =boomImg}
                table.insert(boomerangs, newBoomerang)
                canShoot=false
                canShootTimer = canShootTimerMax
            end
        else
            newBoomerang = { x = player.x + (player.img:getWidth()/2), y = player.y, img =boomImg}
            table.insert(boomerangs, newBoomerang)
            canShoot=false
            canShootTimer = canShootTimerMax
        end
    end

    if love.keyboard.isDown("s") and canBreath then 
        newFire = { x = player.x + (player.img:getWidth()/2)-100, y = player.y-300, img =fireImg}
        table.insert(fires, newFire)
        canBreath=false
        canBreathTimer = canBreathTimerMax
    end
    if love.keyboard.isDown("space") and canBerserk then 
        berserkMode=true
    end

    -- ENEMIES
    createGoblinTimer = createGoblinTimer - (1*dt)
    if createGoblinTimer < 0 then
        createGoblinTimer = createGoblinTimerMax
        --create a goblin
        randomNumber = math.random(10, love.graphics.getWidth() - 10)
        newGoblin = { x = randomNumber-20, y = -10, img = goblinImg }
        table.insert(goblins, newGoblin)
    end

    -- POSITIONS
    --move boomerangs
    for i , boomerang in ipairs(boomerangs) do
        boomerang.y = boomerang.y - (350 * dt)
    -- delete boomerangs
        if boomerang.y < 0 then 
            table.remove(boomerangs, i)
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

        if goblin.y > 850 then
            table.remove(goblins, i)
        end
    end

    -- COLLISION
    -- loop through shorter stuff first!
    for i, goblin in ipairs(goblins) do
        for j, boomerang in ipairs(boomerangs) do
            if CheckCollision(goblin.x, goblin.y, goblin.img:getWidth(), goblin.img:getHeight(), 
                            boomerang.x, boomerang.y, boomerang.img:getWidth(), boomerang.img:getHeight()) then

                table.remove(boomerangs, j)
                table.remove(goblins, i)
                money = money+1
            end
        end
    
        if CheckCollision(goblin.x, goblin.y, goblin.img:getWidth(), goblin.img:getHeight(), 
                            player.x, player.y, player.img:getWidth(), player.img:getHeight()) 
        and isAlive then
            table.remove(goblins, i)
            isAlive = false
        end
    end
end

function love.draw(dt)

    _G.map:draw()

    --PLAYER
    if isAlive then
    love.graphics.draw(player.img, player.x, player.y)
    else
        love.graphics.print("Press F to pay respect.\n\nPress 'R' to restart", love.graphics:getWidth()/2-50, love.graphics:getHeight()/2-10)
    end
    --WEAPONS
    for i, boomerang in ipairs(boomerangs) do
        love.graphics.draw(boomerang.img, boomerang.x, boomerang.y)
    end
    for i, fire in ipairs(fires) do
        love.graphics.draw(fire.img, fire.x, fire.y, 0,0.5, 0.5)
    end
    for i, goblin in ipairs(goblins) do
        love.graphics.draw(goblin.img, goblin.x, goblin.y)
    end
    if berserkMode == true then
        love.graphics.draw(berserkParticle.img, player.x, player.y-5, 0,1.5,1.5)
    end
end