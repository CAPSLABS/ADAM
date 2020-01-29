return {
    tooBroke = false,
    tooBrokeMsgTimerMax = 2,
    tooBrokeMsgTimer = 2,
    focussedIconBorderWidth = 3,
    media = {
        back = "assets/forestLayered/back.png",
        light = "assets/forestLayered/light.png",
        middle = "assets/forestLayered/middle.png",
        fore = "assets/forestLayered/fore.png",
        sensei = "assets/cha_sprites/mage.png",
        senseiAngry = "assets/cha_sprites/mageAngry.png",
        done = "assets/hud/done_288x96.png",
        wall = "assets/hud/wall.png"
    },
    sensei = nil,
    pos = {
        baseX = 70,
        baseY = 460,
        moneyX = 320,
        moneyY = 360,
        distanceX = 80,
        distanceY = 80,
        doneX = (WORLD.x / 2),
        doneY = 850
    },
    prices = {
        boom = {0,50,200},
        fire = {10,50,200},
        berserk = {10,50,200},
        fast = {10,50,200},
        burst = {30,300,300},
    },
    currentRow = 1,
    boomHovered = false,
    fireHovered = false,
    berserkHovered = false,
    fastHovered = false,
    burstHovered = false,
    loadBacking = function(self)
        for key, img in pairs(self.media) do
            self.media[key] = love.graphics.newImage(img)
        end
        self.sensei = self.media.sensei
    end,
    buy = function(self, price)
        local transaction = false
        local money = WORLD.player.money
        if money - price >= 0 then
            WORLD.player.money = WORLD.player.money - price
            transaction = true
        end
        return transaction
    end,
    timeTooBrokeMessage = function(self, dt)
        self.tooBrokeMsgTimer = self.tooBrokeMsgTimer - dt * 1
        if self.tooBrokeMsgTimer <= 0 then
            self.tooBroke = false
            self.tooBrokeMsgTimer = self.tooBrokeMsgTimerMax
            self.sensei = self.media.sensei
        end
    end,
    updateShopShit = function(self, dt)
        -- Updates timer for the too broke message
        if self.tooBroke then
            self:timeTooBrokeMessage(dt)
        end

        -- NOTE: when positioning SUIT buttons THE ORDER DOES MATTER. The latter three ImageButtons have to stay there, they cannot go before the extra button
        -- or else the extra button will not be drawn!

        -- Check if boom button of next respective level is hit or hovered
        if WORLD.player.boomLevel < 3 then
            local button = SUIT.ImageButton(WORLD.media.hud.boom, {id=14}, self.pos.baseX + (self.pos.distanceX * (WORLD.player.boomLevel)), self.pos.baseY)
            if button.hit then
                if self:buy(self.prices.boom[WORLD.player.boomLevel + 1]) then
                    WORLD.player:lvlUpBoom()
                else
                    self.tooBroke = true
                    self.sensei = self.media.senseiAngry
                end
            end
            self.boomHovered = button.hovered
        else
            self.boomHovered = false
        end
        SUIT.ImageButton(WORLD.media.hud.boomUsed, {id=11}, self.pos.baseX, self.pos.baseY)
        SUIT.ImageButton(WORLD.media.hud.boomUsed, {id=12}, self.pos.baseX + (self.pos.distanceX), self.pos.baseY)
        SUIT.ImageButton(WORLD.media.hud.boomUsed, {id=13}, self.pos.baseX + (self.pos.distanceX * 2), self.pos.baseY)

        -- Check if fire button of next respective level is hit or hovered
        if WORLD.player.fireLevel < 3 then
            local button = SUIT.ImageButton(WORLD.media.hud.fire, {id=24}, self.pos.baseX + (self.pos.distanceX * (WORLD.player.fireLevel)), self.pos.baseY + self.pos.distanceY)
            if button.hit then
                if self:buy(self.prices.fire[WORLD.player.fireLevel + 1]) then
                    WORLD.player:lvlUpFire()
                else
                    self.tooBroke = true
                    self.sensei = self.media.senseiAngry
                end
            end
            self.fireHovered = button.hovered
        else
            self.fireHovered = false
        end
        SUIT.ImageButton(WORLD.media.hud.fireUsed, {id=21}, self.pos.baseX, self.pos.baseY + self.pos.distanceY)
        SUIT.ImageButton(WORLD.media.hud.fireUsed, {id=22}, self.pos.baseX + (self.pos.distanceX), self.pos.baseY + self.pos.distanceY)
        SUIT.ImageButton(WORLD.media.hud.fireUsed, {id=23}, self.pos.baseX + (self.pos.distanceX * 2), self.pos.baseY + self.pos.distanceY)
        
        -- Check if berserk button of next respective level is hit or hovered
        if WORLD.player.berserkLevel < 3 then
            local button = SUIT.ImageButton(WORLD.media.hud.berserk, {id=34}, self.pos.baseX + (self.pos.distanceX * (WORLD.player.berserkLevel)), self.pos.baseY + 2*self.pos.distanceY)
            if button.hit then
                if self:buy(self.prices.berserk[WORLD.player.berserkLevel + 1]) then
                    WORLD.player:lvlUpBerserk()
                else
                    self.tooBroke = true
                    self.sensei = self.media.senseiAngry
                end
            end
            self.berserkHovered = button.hovered
        else
            self.berserkHovered = false
        end
        SUIT.ImageButton(WORLD.media.hud.berserkUsed, {id=31}, self.pos.baseX, self.pos.baseY + 2*self.pos.distanceY)
        SUIT.ImageButton(WORLD.media.hud.berserkUsed, {id=32}, self.pos.baseX + (self.pos.distanceX), self.pos.baseY + 2*self.pos.distanceY)
        SUIT.ImageButton(WORLD.media.hud.berserkUsed, {id=33}, self.pos.baseX + (self.pos.distanceX * 2), self.pos.baseY + 2*self.pos.distanceY)

        -- Check if sonic button of next respective level is hit or hovered
        if WORLD.player.goFastLevel < 3 then
            local button = SUIT.ImageButton(WORLD.media.hud.fast, {id=44}, self.pos.baseX + (self.pos.distanceX * (WORLD.player.goFastLevel)), self.pos.baseY + 3*self.pos.distanceY)
            if button.hit then
                if self:buy(self.prices.fast[WORLD.player.goFastLevel + 1]) then
                    WORLD.player:lvlUpFast()
                else
                    self.tooBroke = true
                    self.sensei = self.media.senseiAngry
                end
            end
            self.fastHovered = button.hovered
        else
            self.fastHovered = false
        end
        SUIT.ImageButton(WORLD.media.hud.fastUsed, {id=41}, self.pos.baseX, self.pos.baseY + 3*self.pos.distanceY)
        SUIT.ImageButton(WORLD.media.hud.fastUsed, {id=42}, self.pos.baseX + (self.pos.distanceX), self.pos.baseY + 3*self.pos.distanceY)
        SUIT.ImageButton(WORLD.media.hud.fastUsed, {id=43}, self.pos.baseX + (self.pos.distanceX * 2), self.pos.baseY + 3*self.pos.distanceY)

        -- Check if burst button of next respective level is hit or hovered
        if WORLD.player.burstLevel < 3 then
            local button = SUIT.ImageButton(WORLD.media.hud.explo, {id=54}, self.pos.baseX + (self.pos.distanceX * (WORLD.player.burstLevel)), self.pos.baseY + 4*self.pos.distanceY)
            if button.hit then
                if self:buy(self.prices.burst[WORLD.player.burstLevel + 1]) then
                    WORLD.player:lvlUpBurst()
                else
                    self.tooBroke = true
                    self.sensei = self.media.senseiAngry
                end
            end
            self.burstHovered = button.hovered
        else
            self.burstHovered = false
        end
        SUIT.ImageButton(WORLD.media.hud.exploUsed, {id=51}, self.pos.baseX, self.pos.baseY + 4*self.pos.distanceY)
        SUIT.ImageButton(WORLD.media.hud.exploUsed, {id=52}, self.pos.baseX + (self.pos.distanceX), self.pos.baseY + 4*self.pos.distanceY)
        SUIT.ImageButton(WORLD.media.hud.exploUsed, {id=53}, self.pos.baseX + (self.pos.distanceX * 2), self.pos.baseY + 4*self.pos.distanceY)

        -- done button
        if SUIT.ImageButton(self.media.done, {id=61}, self.pos.doneX - (self.media.done:getWidth() / 2), self.pos.doneY).hit then
            love.graphics.setBackgroundColor(0, 0, 0, 0)
            if WORLD.endlessmode == true then
                WORLD.shoppedThisIteration = true
                WORLD:nextEndlessMode()
            else
                InitGame(WORLD.currentLvl, 6)
            end
        end

        --if WORLD.endlessmode then
        --print("brr")
        --if SUIT.ImageButton(self.media.wall, 26, 100).hit then
        --print("ha")
        --end
        --end
    end,
    broUBroke = function(self)
        love.graphics.setFont(WORLD.media.fantasyfont)
        if self.tooBroke then
            SUIT.Label("AND HOW DO YOU PLAN TO PAY FOR THIS?!", 26, 360, 320, 0)
            WORLD:drawScreenShake(-5, 5)
        else
            if self.boomHovered then
                SUIT.Label("Press [A] to throw deadly boomerangs in a straight line!", 26, 340, 320, 0)
            elseif self.fireHovered then
                SUIT.Label("Press [S] to release a scorching fire cone in front of you!", 26, 340, 320, 0)
            elseif self.berserkHovered then
                SUIT.Label("Press [D] to go into a furious berserk mode!", 26, 340, 320, 0)
                SUIT.Label("In this mode you can shoot boomerangs incredibly fast!", 26, 400, 320, 0)
            elseif self.fastHovered then
                SUIT.Label("Press [F] to generate a protective sphere and get increasingly faster!", 26, 340, 320, 0)
                SUIT.Label("The sphere damages enemies and saves you from harm!", 26, 400, 320, 0)
            elseif self.burstHovered then
                SUIT.Label("Press [Space] to detonate an all hitting explosion!", 26, 340, 320, 0)
            else
                SUIT.Label("What do you want to be taught?", 26, 340, 320, 0)
                SUIT.Label("Upgrading a skill will halve its cooldown!", 26, 400, 320, 0)
            end
            SUIT.Label("DAILY SPECIAL: repair the city walls!!", 26, 100, 320, 0)
        end
    end,
    drawShopShit = function(self)
        love.graphics.setBackgroundColor(0.45, 0.31, 0.2, 0)
        love.graphics.draw(SHOP.media.back, 0, 0, 0, 2, 2)
        love.graphics.draw(SHOP.media.light, 0, 0, 0, 2, 2)
        love.graphics.draw(SHOP.media.middle, 0, 0, 0, 2, 2)
        love.graphics.draw(SHOP.media.fore, 0, 0, 0, 2, 2)
        love.graphics.draw(SHOP.sensei, 250, 100, 0, 4, 4)

        self:drawFocussedIconBorder()

        love.graphics.draw(WORLD.media.hud.silver, self.pos.baseX + (self.pos.distanceX), self.pos.baseY)
        love.graphics.draw(WORLD.media.hud.gold, self.pos.baseX + (self.pos.distanceX * 2), self.pos.baseY)

        love.graphics.draw(
            WORLD.media.hud.silver,
            self.pos.baseX + (self.pos.distanceX),
            self.pos.baseY + (self.pos.distanceY)
        )
        love.graphics.draw(
            WORLD.media.hud.gold,
            self.pos.baseX + (self.pos.distanceX * 2),
            self.pos.baseY + (self.pos.distanceY)
        )

        love.graphics.draw(
            WORLD.media.hud.silver,
            self.pos.baseX + (self.pos.distanceX),
            self.pos.baseY + (self.pos.distanceY * 2)
        )
        love.graphics.draw(
            WORLD.media.hud.gold,
            self.pos.baseX + (self.pos.distanceX * 2),
            self.pos.baseY + (self.pos.distanceY * 2)
        )

        love.graphics.draw(
            WORLD.media.hud.silver,
            self.pos.baseX + (self.pos.distanceX),
            self.pos.baseY + (self.pos.distanceY * 3)
        )
        love.graphics.draw(
            WORLD.media.hud.gold,
            self.pos.baseX + (self.pos.distanceX * 2),
            self.pos.baseY + (self.pos.distanceY * 3)
        )

        love.graphics.draw(
            WORLD.media.hud.silver,
            self.pos.baseX + (self.pos.distanceX),
            self.pos.baseY + (self.pos.distanceY * 4)
        )
        love.graphics.draw(
            WORLD.media.hud.gold,
            self.pos.baseX + (self.pos.distanceX * 2),
            self.pos.baseY + (self.pos.distanceY * 4)
        )
        
        self:drawPrices()
    end,
    drawFocussedIconBorder = function(self)
        -- set color to red
        love.graphics.setColor(1,0,0)
        love.graphics.setLineWidth(self.focussedIconBorderWidth)
        if 1 <= self.currentRow and self.currentRow <= 5 then
            -- draw red rectangle
            local _, level, _ = self:getSkillFromRow()
            if level < 3 then
                love.graphics.rectangle(
                    "line",
                    self.pos.baseX + self.pos.distanceX * level - self.focussedIconBorderWidth,
                    self.pos.baseY + self.pos.distanceY * (self.currentRow - 1) - self.focussedIconBorderWidth,
                    WORLD.media.hud.gold:getWidth() + 2 * self.focussedIconBorderWidth,
                    WORLD.media.hud.gold:getHeight() + 2 * self.focussedIconBorderWidth
                )
            end
        elseif self.currentRow == 6 then
            -- outline for done button
            love.graphics.rectangle(
                "line",
                self.pos.doneX - (self.media.done:getWidth() / 2) - self.focussedIconBorderWidth,
                self.pos.doneY - self.focussedIconBorderWidth,
                self.media.done:getWidth() + 2 * self.focussedIconBorderWidth,
                self.media.done:getHeight() + 2 * self.focussedIconBorderWidth
            )
        else
            print("Shit failed bitch")
        end
        love.graphics.setColor(255,255,255)
    end,
    getSkillFromRow = function(self)
        -- Goal: given currentRow, get all relevat info for that skill
        if self.currentRow == 1 then
            return "boom", WORLD.player.boomLevel, WORLD.player.lvlUpBoom
        elseif self.currentRow == 2 then
            return "fire", WORLD.player.fireLevel, WORLD.player.lvlUpFire
        elseif self.currentRow == 3 then
            return "berserk", WORLD.player.berserkLevel, WORLD.player.lvlUpBerserk
        elseif self.currentRow == 4 then
            return "fast", WORLD.player.goFastLevel, WORLD.player.lvlUpFast
        elseif self.currentRow == 5 then
            return "burst", WORLD.player.burstLevel, WORLD.player.lvlUpBurst
        else 
            print("skill self.currentRow is not known with value: " .. self.currentRow)
        end
    end,
    drawPrices = function(self)
        love.graphics.setFont(WORLD.media.bigfantasyfont)

        -- player cash: first the coin symbol then the amount
        love.graphics.draw(WORLD.media.hud.money, self.pos.moneyX, self.pos.moneyY - 30, 0, 0.5)
        love.graphics.print(WORLD.player.money, self.pos.moneyX + 90, self.pos.moneyY)

        -- boom cost
        love.graphics.draw(WORLD.media.hud.money, self.pos.moneyX, self.pos.moneyY + self.pos.distanceY, 0, 0.5)
        if WORLD.player.boomLevel < 3 then
            love.graphics.print(self.prices.boom[WORLD.player.boomLevel + 1], self.pos.moneyX + 100, self.pos.moneyY + 110)
        end

        -- fire cost
        love.graphics.draw(WORLD.media.hud.money, self.pos.moneyX, self.pos.moneyY + (self.pos.distanceY * 2), 0, 0.5)
        if WORLD.player.fireLevel < 3 then
            love.graphics.print(self.prices.fire[WORLD.player.fireLevel + 1], self.pos.moneyX + 100, self.pos.moneyY + self.pos.distanceY + 110)
        end

        -- berserk cost
        love.graphics.draw(WORLD.media.hud.money, self.pos.moneyX, self.pos.moneyY + (self.pos.distanceY * 3), 0, 0.5)
        if WORLD.player.berserkLevel < 3 then
            love.graphics.print(self.prices.berserk[WORLD.player.berserkLevel + 1], self.pos.moneyX + 100, self.pos.moneyY + 2*self.pos.distanceY + 110)
        end

        -- go fast cost
        love.graphics.draw(WORLD.media.hud.money, self.pos.moneyX, self.pos.moneyY + (self.pos.distanceY * 4), 0, 0.5)
        if WORLD.player.goFastLevel < 3 then
            love.graphics.print(self.prices.fast[WORLD.player.goFastLevel + 1], self.pos.moneyX + 100, self.pos.moneyY + 3*self.pos.distanceY + 110)
        end

        -- burst cost
        love.graphics.draw(WORLD.media.hud.money, self.pos.moneyX, self.pos.moneyY + (self.pos.distanceY * 5), 0, 0.5)
        if WORLD.player.burstLevel < 3 then
            love.graphics.print(self.prices.burst[WORLD.player.burstLevel + 1], self.pos.moneyX + 100, self.pos.moneyY + 4*self.pos.distanceY + 110)
        end
    end
}
