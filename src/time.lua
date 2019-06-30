function time()
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
end