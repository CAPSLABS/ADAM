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
berserkDurationMax = 3
berserkDuration = berserkDurationMax

canBerserk = true
canBerserkTimerMax = 15
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

player_scale = 0.3

function love.load(arg)
    --Animations
    animation = newAnimation(love.graphics.newImage("assets/boomerang.png"), 48, 48, 0.3)

    --hit the bodies
    player = { x = 200, y = 710, speed = 200, img = nil }
    player.img = love.graphics.newImage("assets/HeroUp.png")

    berserkParticle = { x = 200, y = 710, speed = 150, img = nil }
    berserkParticle.img = love.graphics.newImage("assets/berserk.png") 

    --hit the floor:
    _G.map = loadTiledMap("assets/tile/ebene1/", "ebene1tilemap")


    --particles (currently enemies are particles)
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
    berserkDuration = berserkDurationMax
    canBerserkTimer = canBerserkTimerMax

    -- reset position
    player.x = 50
    player.y = 710

    -- reset our game state
    money = 0
    isAlive = true
end


function newAnimation(image, width, height, duration)
    local animation = {}
    animation.spriteSheet = image;
    animation.quads = {};

    for y = 0, image:getHeight() - height, height do
        for x =0, image:getWidth() - width, width do
            table.insert(animation.quads, love.graphics.newQuad(x,y, width, height, image:getDimensions()))
        end
    end

    animation.duration = duration or 1
    animation.currentTime = 0

    return animation
end


function love.update(dt)
    --TODO: change to handle multiple animations
    animation.currentTime = animation.currentTime+dt
    if animation.currentTime >= animation.duration then
        animation.currentTime = animation.currentTime - animation.duration
    end

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
                newBoomerang = { x = player.x, y = player.y, img =boomImg}
                
                table.insert(boomerangs, newBoomerang)
                canShoot=false
                canShootTimer = canShootTimerMax
            end
        else
            newBoomerang = { x = player.x, y = player.y, img =boomImg}
            table.insert(boomerangs, newBoomerang)
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
        
        for j, fire in ipairs(fires) do
            if CheckCollision(goblin.x, goblin.y, goblin.img:getWidth(), goblin.img:getHeight(),
                            fire.x, fire.y, fire.img:getWidth(), fire.img:getHeight()) then
                table.remove(goblins, i)
                money = money+1
            end
            money = money+1
        end

        if CheckCollision(goblin.x, goblin.y, goblin.img:getWidth(), goblin.img:getHeight(), 
                            player.x, player.y, player.img:getWidth()*player_scale, player.img:getHeight()*player_scale) 
        and isAlive then
            table.remove(goblins, i)
            -- add this line for actual game
            isAlive = false

        end
    end
end

function love.draw(dt)
    _G.map:draw()

    local spriteNum = math.floor(animation.currentTime / animation.duration * #animation.quads) + 1
    love.graphics.draw(animation.spriteSheet, animation.quads[spriteNum])

    --PLAYER
    if isAlive then
    love.graphics.draw(player.img, player.x, player.y, 0, player_scale, player_scale)
    else
        love.graphics.print("Press 'F' to pay respect.\n\nPress 'R' to restart", love.graphics:getWidth()/2-50, love.graphics:getHeight()/2-10)
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