return {
    player = nil,
    goblins = {},
    zombies = {},
    x = 32*15,
    y = 32*30,
    l1 = {
        mapPath = "assets/tile/ebene1tilemap",
        goblinTimer=0.4,
        goblinTimerMax = 0.4
        --TODO start slower and rather add goblin spawn acceleration
        --time based or ded enemy/money based?
    }, 
    l2 = {
        mapPath = "assets/tile/ebene2tilemap",
        goblinTimer=0.3,
        goblinTimerMax = 0.3
    }, 

    updateEnemies = function(self, dt) --TODO put enemies in collection class
        for i, goblin in ipairs(self.goblins) do
            goblin:update(dt)
            if not goblin.alive then
                table.remove(self.goblins, i)
                self.player.money = self.player.money+1
            end
        end
    end,

    spawnEnemies = function(self,dt) --todo, make non goblin specific
        self.l1.goblinTimer = self.l1.goblinTimer - (1*dt)
        if self.l1.goblinTimer < 0 then
            --create a goblin and reset timer
            self.l1.goblinTimer = self.l1.goblinTimerMax
            local randomStartX = math.random(0, self.x - goblinRaw:getWidth()) -- substr. width avoids clipping out to the right
            local walkAnim = anim8.newAnimation(goblinRaw.media.imgGrid('1-7', 1), 0.07)
            local newGoblin = goblinRaw:newGoblin(randomStartX, walkAnim)
            table.insert(self.goblins, newGoblin)
        end
    end,

    handleCollisions = function(self)
        --per goblin
        for i, goblin in ipairs(self.goblins) do
            --check boom collision:
            for j, boom in ipairs(self.player.booms) do
                if CheckCollision(goblin.x, goblin.y, 64, 64, 
                                boom.x, boom.y, 48, 48) then
                    goblin:getHit(1)
                    table.remove(self.player.booms, j)
                end
            end
            -- check fire collision:
            for j, fire in ipairs(self.player.fires) do
                if CheckCollision(goblin.x, goblin.y, 64, 64,
                                fire.x, fire.y, fire.img:getWidth(), fire.img:getHeight()) then
                    goblin:getHit(2)
                end
            end
            -- check player collision:
            if CheckCollision(goblin.x, goblin.y, 64, 64, 
                                self.player.x, self.player.y, 
                                self.player.media.imgUp:getWidth()*self.player.scale, 
                                self.player.media.imgUp:getHeight()*self.player.scale) then
                self.player.alive=false
            end
        end
    end,

    drawPlayerStuff = function(self)
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
        for i, goblin in ipairs(self    .goblins) do
            goblin.anim:draw(goblinRaw.media.img, goblin.x, goblin.y)
        end
    end,
}