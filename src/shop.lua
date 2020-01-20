return {
    tooBroke = false,
    tooBrokeMsgTimerMax = 2,
    tooBrokeMsgTimer = 2,
    media = {
        back = "assets/forestLayered/back.png",
        light = "assets/forestLayered/light.png",
        middle = "assets/forestLayered/middle.png",
        fore = "assets/forestLayered/fore.png",
        sensei = "assets/cha_sprites/mage.png",
        senseiAngry = "assets/cha_sprites/mageAngry.png",
        done = "assets/hud/done_288x96.png"
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
        --boom = {50, 200, 12, 123, 234, 345},
        boom2 = 50,
        boom3 = 200,
        fire1 = 10,
        fire2 = 50,
        fire3 = 200,
        berserk1 = 10,
        berserk2 = 50,
        berserk3 = 200,
        fast1 = 10,
        fast2 = 50,
        fast3 = 200,
        burst1 = 30,
        burst2 = 300,
        burst3 = 300
    },
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

        -- Check if boom button of next respective level is hit or hovered
        if WORLD.player.boomLevel == 1 then
            SUIT.ImageButton(WORLD.media.hud.boomUsed, self.pos.baseX, self.pos.baseY)
            local button = SUIT.ImageButton(WORLD.media.hud.boom, self.pos.baseX + (self.pos.distanceX), self.pos.baseY)
            if button.hit then
                if self:buy(self.prices.boom2) then
                    WORLD.player:lvlUpBoom()
                else
                    self.tooBroke = true
                    self.sensei = self.media.senseiAngry
                end
            end
            SUIT.ImageButton(WORLD.media.hud.boomUsed, self.pos.baseX + (self.pos.distanceX * 2), self.pos.baseY)
            self.boomHovered = button.hovered
        elseif WORLD.player.boomLevel == 2 then
            SUIT.ImageButton(WORLD.media.hud.boomUsed, self.pos.baseX, self.pos.baseY)
            SUIT.ImageButton(WORLD.media.hud.boomUsed, self.pos.baseX + (self.pos.distanceX), self.pos.baseY)
            local button =
                SUIT.ImageButton(WORLD.media.hud.boom, self.pos.baseX + (self.pos.distanceX * 2), self.pos.baseY)
            if button.hit then
                if self:buy(self.prices.boom3) then
                    WORLD.player:lvlUpBoom()
                else
                    self.tooBroke = true
                    self.sensei = self.media.senseiAngry
                end
            end
            self.boomHovered = button.hovered
        elseif WORLD.player.boomLevel == 3 then
            SUIT.ImageButton(WORLD.media.hud.boomUsed, self.pos.baseX, self.pos.baseY)
            SUIT.ImageButton(WORLD.media.hud.boomUsed, self.pos.baseX + (self.pos.distanceX), self.pos.baseY)
            SUIT.ImageButton(WORLD.media.hud.boomUsed, self.pos.baseX + (self.pos.distanceX * 2), self.pos.baseY)
        end

        -- Check if fire button of next respective level is hit or hovered
        if WORLD.player.fireLevel == 0 then
            local button = SUIT.ImageButton(WORLD.media.hud.fire, self.pos.baseX, self.pos.baseY + (self.pos.distanceY))
            if button.hit then
                if self:buy(self.prices.fire1) then
                    WORLD.player:lvlUpFire()
                else
                    self.tooBroke = true
                    self.sensei = self.media.senseiAngry
                end
            end
            SUIT.ImageButton(
                WORLD.media.hud.fireUsed,
                self.pos.baseX + (self.pos.distanceX * 1),
                self.pos.baseY + (self.pos.distanceY)
            )
            SUIT.ImageButton(
                WORLD.media.hud.fireUsed,
                self.pos.baseX + (self.pos.distanceX * 2),
                self.pos.baseY + (self.pos.distanceY)
            )
            self.fireHovered = button.hovered
        elseif WORLD.player.fireLevel == 1 then
            SUIT.ImageButton(WORLD.media.hud.fireUsed, self.pos.baseX, self.pos.baseY + (self.pos.distanceY))
            local button =
                SUIT.ImageButton(
                WORLD.media.hud.fire,
                self.pos.baseX + (self.pos.distanceX * 1),
                self.pos.baseY + (self.pos.distanceY)
            )
            if button.hit then
                if self:buy(self.prices.fire2) then
                    WORLD.player:lvlUpFire()
                else
                    self.tooBroke = true
                    self.sensei = self.media.senseiAngry
                end
            end
            SUIT.ImageButton(
                WORLD.media.hud.fireUsed,
                self.pos.baseX + (self.pos.distanceX * 2),
                self.pos.baseY + (self.pos.distanceY)
            )
            self.fireHovered = button.hovered
        elseif WORLD.player.fireLevel == 2 then
            SUIT.ImageButton(WORLD.media.hud.fireUsed, self.pos.baseX, self.pos.baseY + (self.pos.distanceY))
            SUIT.ImageButton(
                WORLD.media.hud.fireUsed,
                self.pos.baseX + (self.pos.distanceX * 1),
                self.pos.baseY + (self.pos.distanceY)
            )
            local button =
                SUIT.ImageButton(
                WORLD.media.hud.fire,
                self.pos.baseX + (self.pos.distanceX * 2),
                self.pos.baseY + (self.pos.distanceY)
            )
            if button.hit then
                if self:buy(self.prices.fire3) then
                    WORLD.player:lvlUpFire()
                else
                    self.tooBroke = true
                    self.sensei = self.media.senseiAngry
                end
            end
            self.fireHovered = button.hovered
        elseif WORLD.player.fireLevel == 3 then
            SUIT.ImageButton(WORLD.media.hud.fireUsed, self.pos.baseX, self.pos.baseY + (self.pos.distanceY))
            SUIT.ImageButton(
                WORLD.media.hud.fireUsed,
                self.pos.baseX + (self.pos.distanceX * 1),
                self.pos.baseY + (self.pos.distanceY)
            )
            SUIT.ImageButton(
                WORLD.media.hud.fireUsed,
                self.pos.baseX + (self.pos.distanceX * 2),
                self.pos.baseY + (self.pos.distanceY)
            )
        end

        -- Check if fire button of next respective level is hit or hovered
        if WORLD.player.berserkLevel == 0 then
            local button =
                SUIT.ImageButton(
                WORLD.media.hud.berserk,
                self.pos.baseX + (self.pos.distanceX * 0),
                self.pos.baseY + (self.pos.distanceY * 2)
            )
            if button.hit then
                if self:buy(self.prices.berserk1) then
                    WORLD.player:lvlUpBerserk()
                else
                    self.tooBroke = true
                    self.sensei = self.media.senseiAngry
                end
            end
            SUIT.ImageButton(
                WORLD.media.hud.berserkUsed,
                self.pos.baseX + (self.pos.distanceX * 1),
                self.pos.baseY + (self.pos.distanceY * 2)
            )
            SUIT.ImageButton(
                WORLD.media.hud.berserkUsed,
                self.pos.baseX + (self.pos.distanceX * 2),
                self.pos.baseY + (self.pos.distanceY * 2)
            )
            self.berserkHovered = button.hovered
        elseif WORLD.player.berserkLevel == 1 then
            SUIT.ImageButton(
                WORLD.media.hud.berserkUsed,
                self.pos.baseX + (self.pos.distanceX * 0),
                self.pos.baseY + (self.pos.distanceY * 2)
            )
            local button =
                SUIT.ImageButton(
                WORLD.media.hud.berserk,
                self.pos.baseX + (self.pos.distanceX * 1),
                self.pos.baseY + (self.pos.distanceY * 2)
            )
            if button.hit then
                if self:buy(self.prices.berserk2) then
                    WORLD.player:lvlUpBerserk()
                else
                    self.tooBroke = true
                    self.sensei = self.media.senseiAngry
                end
            end
            SUIT.ImageButton(
                WORLD.media.hud.berserkUsed,
                self.pos.baseX + (self.pos.distanceX * 2),
                self.pos.baseY + (self.pos.distanceY * 2)
            )
            self.berserkHovered = button.hovered
        elseif WORLD.player.berserkLevel == 2 then
            SUIT.ImageButton(
                WORLD.media.hud.berserkUsed,
                self.pos.baseX + (self.pos.distanceX * 0),
                self.pos.baseY + (self.pos.distanceY * 2)
            )
            SUIT.ImageButton(
                WORLD.media.hud.berserkUsed,
                self.pos.baseX + (self.pos.distanceX * 1),
                self.pos.baseY + (self.pos.distanceY * 2)
            )
            local button =
                SUIT.ImageButton(
                WORLD.media.hud.berserk,
                self.pos.baseX + (self.pos.distanceX * 2),
                self.pos.baseY + (self.pos.distanceY * 2)
            )
            if button.hit then
                if self:buy(self.prices.berserk3) then
                    WORLD.player:lvlUpBerserk()
                else
                    self.tooBroke = true
                    self.sensei = self.media.senseiAngry
                end
            end
            self.berserkHovered = button.hovered
        elseif WORLD.player.berserkLevel == 3 then
            SUIT.ImageButton(
                WORLD.media.hud.berserkUsed,
                self.pos.baseX + (self.pos.distanceX * 0),
                self.pos.baseY + (self.pos.distanceY * 2)
            )
            SUIT.ImageButton(
                WORLD.media.hud.berserkUsed,
                self.pos.baseX + (self.pos.distanceX * 1),
                self.pos.baseY + (self.pos.distanceY * 2)
            )
            SUIT.ImageButton(
                WORLD.media.hud.berserkUsed,
                self.pos.baseX + (self.pos.distanceX * 2),
                self.pos.baseY + (self.pos.distanceY * 2)
            )
        end

        -- Check if fire button of next respective level is hit or hovered
        if WORLD.player.goFastLevel == 0 then
            local button =
                SUIT.ImageButton(WORLD.media.hud.fast, self.pos.baseX, self.pos.baseY + (self.pos.distanceY * 3))
            if button.hit then
                if self:buy(self.prices.fast1) then
                    WORLD.player:lvlUpFast()
                else
                    self.tooBroke = true
                    self.sensei = self.media.senseiAngry
                end
            end
            SUIT.ImageButton(
                WORLD.media.hud.fastUsed,
                self.pos.baseX + (self.pos.distanceX),
                self.pos.baseY + (self.pos.distanceY * 3)
            )
            SUIT.ImageButton(
                WORLD.media.hud.fastUsed,
                self.pos.baseX + (self.pos.distanceX * 2),
                self.pos.baseY + (self.pos.distanceY * 3)
            )
            self.fastHovered = button.hovered
        elseif WORLD.player.goFastLevel == 1 then
            SUIT.ImageButton(WORLD.media.hud.fastUsed, self.pos.baseX, self.pos.baseY + (self.pos.distanceY * 3))
            local button =
                SUIT.ImageButton(
                WORLD.media.hud.fast,
                self.pos.baseX + (self.pos.distanceX),
                self.pos.baseY + (self.pos.distanceY * 3)
            )
            if button.hit then
                if self:buy(self.prices.fast2) then
                    WORLD.player:lvlUpFast()
                else
                    self.tooBroke = true
                    self.sensei = self.media.senseiAngry
                end
            end
            SUIT.ImageButton(
                WORLD.media.hud.fastUsed,
                self.pos.baseX + (self.pos.distanceX * 2),
                self.pos.baseY + (self.pos.distanceY * 3)
            )
            self.fastHovered = button.hovered
        elseif WORLD.player.goFastLevel == 2 then
            SUIT.ImageButton(WORLD.media.hud.fastUsed, self.pos.baseX, self.pos.baseY + (self.pos.distanceY * 3))
            SUIT.ImageButton(
                WORLD.media.hud.fastUsed,
                self.pos.baseX + (self.pos.distanceX),
                self.pos.baseY + (self.pos.distanceY * 3)
            )
            local button =
                SUIT.ImageButton(
                WORLD.media.hud.fast,
                self.pos.baseX + (self.pos.distanceX * 2),
                self.pos.baseY + (self.pos.distanceY * 3)
            )
            if button.hit then
                if self:buy(self.prices.fast3) then
                    WORLD.player:lvlUpFast()
                else
                    self.tooBroke = true
                    self.sensei = self.media.senseiAngry
                end
            end
            self.fastHovered = button.hovered
        elseif WORLD.player.goFastLevel == 3 then
            SUIT.ImageButton(WORLD.media.hud.fastUsed, self.pos.baseX, self.pos.baseY + (self.pos.distanceY * 3))
            SUIT.ImageButton(
                WORLD.media.hud.fastUsed,
                self.pos.baseX + (self.pos.distanceX),
                self.pos.baseY + (self.pos.distanceY * 3)
            )
            SUIT.ImageButton(
                WORLD.media.hud.fastUsed,
                self.pos.baseX + (self.pos.distanceX * 2),
                self.pos.baseY + (self.pos.distanceY * 3)
            )
        end

        if WORLD.player.burstLevel == 0 then
            local button =
                SUIT.ImageButton(WORLD.media.hud.explo, self.pos.baseX, self.pos.baseY + (self.pos.distanceY * 4))
            if button.hit then
                if self:buy(self.prices.burst1) then
                    WORLD.player:lvlUpBurst()
                else
                    self.tooBroke = true
                    self.sensei = self.media.senseiAngry
                end
            end
            SUIT.ImageButton(
                WORLD.media.hud.exploUsed,
                self.pos.baseX + (self.pos.distanceX),
                self.pos.baseY + (self.pos.distanceY * 4)
            )
            SUIT.ImageButton(
                WORLD.media.hud.exploUsed,
                self.pos.baseX + (self.pos.distanceX * 2),
                self.pos.baseY + (self.pos.distanceY * 4)
            )
            self.burstHovered = button.hovered
        elseif WORLD.player.burstLevel == 1 then
            SUIT.ImageButton(WORLD.media.hud.exploUsed, self.pos.baseX, self.pos.baseY + (self.pos.distanceY * 4))
            local button =
                SUIT.ImageButton(
                WORLD.media.hud.explo,
                self.pos.baseX + (self.pos.distanceX),
                self.pos.baseY + (self.pos.distanceY * 4)
            )
            if button.hit then
                if self:buy(self.prices.burst2) then
                    WORLD.player:lvlUpBurst()
                else
                    self.tooBroke = true
                    self.sensei = self.media.senseiAngry
                end
            end
            SUIT.ImageButton(
                WORLD.media.hud.exploUsed,
                self.pos.baseX + (self.pos.distanceX * 2),
                self.pos.baseY + (self.pos.distanceY * 4)
            )
            self.burstHovered = button.hovered
        elseif WORLD.player.burstLevel == 2 then
            SUIT.ImageButton(WORLD.media.hud.exploUsed, self.pos.baseX, self.pos.baseY + (self.pos.distanceY * 4))
            SUIT.ImageButton(
                WORLD.media.hud.exploUsed,
                self.pos.baseX + (self.pos.distanceX),
                self.pos.baseY + (self.pos.distanceY * 4)
            )
            local button =
                SUIT.ImageButton(
                WORLD.media.hud.explo,
                self.pos.baseX + (self.pos.distanceX * 2),
                self.pos.baseY + (self.pos.distanceY * 4)
            )
            if button.hit then
                if self:buy(self.prices.burst3) then
                    WORLD.player:lvlUpBurst()
                else
                    self.tooBroke = true
                    self.sensei = self.media.senseiAngry
                end
            end
            self.burstHovered = button.hovered
        elseif WORLD.player.burstLevel == 3 then
            SUIT.ImageButton(WORLD.media.hud.exploUsed, self.pos.baseX, self.pos.baseY + (self.pos.distanceY * 4))
            SUIT.ImageButton(
                WORLD.media.hud.exploUsed,
                self.pos.baseX + (self.pos.distanceX),
                self.pos.baseY + (self.pos.distanceY * 4)
            )
            SUIT.ImageButton(
                WORLD.media.hud.exploUsed,
                self.pos.baseX + (self.pos.distanceX * 2),
                self.pos.baseY + (self.pos.distanceY * 4)
            )
        end
        if SUIT.ImageButton(self.media.done, self.pos.doneX - (self.media.done:getWidth() / 2), self.pos.doneY).hit then
            if WORLD.endlessmode == true then
                WORLD.shoppedThisIteration = true
                WORLD:nextEndlessMode()
            else
                InitGame(WORLD.currentLvl, 6)
            end
        end
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
        end
    end,
    drawShopShit = function(self)
        love.graphics.setBackgroundColor(0.45, 0.31, 0.2, 0)
        love.graphics.draw(SHOP.media.back, 0, 0, 0, 2, 2)
        love.graphics.draw(SHOP.media.light, 0, 0, 0, 2, 2)
        love.graphics.draw(SHOP.media.middle, 0, 0, 0, 2, 2)
        love.graphics.draw(SHOP.media.fore, 0, 0, 0, 2, 2)
        love.graphics.draw(SHOP.sensei, 250, 100, 0, 4, 4)

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
    drawPrices = function(self)
        love.graphics.setFont(WORLD.media.bigfantasyfont)

        --player cash
        love.graphics.draw(WORLD.media.hud.money, self.pos.moneyX, self.pos.moneyY - 30, 0, 0.5)
        love.graphics.print(WORLD.player.money, self.pos.moneyX + 90, self.pos.moneyY)

        love.graphics.draw(WORLD.media.hud.money, self.pos.moneyX, self.pos.moneyY + self.pos.distanceY, 0, 0.5)
        if WORLD.player.boomLevel == 1 then
            --love.graphics.print(self.prices.boom[1], self.pos.moneyX + 100, self.pos.moneyY + 110)
            love.graphics.print(self.prices.boom2, self.pos.moneyX + 100, self.pos.moneyY + 110)
        elseif WORLD.player.boomLevel == 2 then
            love.graphics.print(self.prices.boom3, self.pos.moneyX + 100, self.pos.moneyY + 110)
        --love.graphics.print(self.prices.boom[2], self.pos.moneyX + 100, self.pos.moneyY + 110)
        end

        love.graphics.draw(WORLD.media.hud.money, self.pos.moneyX, self.pos.moneyY + (self.pos.distanceY * 2), 0, 0.5)
        if WORLD.player.fireLevel == 0 then
            love.graphics.print(self.prices.fire1, self.pos.moneyX + 100, self.pos.moneyY + self.pos.distanceY + 110)
        elseif WORLD.player.fireLevel == 1 then
            love.graphics.print(self.prices.fire2, self.pos.moneyX + 100, self.pos.moneyY + self.pos.distanceY + 110)
        elseif WORLD.player.fireLevel == 2 then
            love.graphics.print(self.prices.fire3, self.pos.moneyX + 100, self.pos.moneyY + self.pos.distanceY + 110)
        end

        love.graphics.draw(WORLD.media.hud.money, self.pos.moneyX, self.pos.moneyY + (self.pos.distanceY * 3), 0, 0.5)
        if WORLD.player.berserkLevel == 0 then
            love.graphics.print(
                self.prices.berserk1,
                self.pos.moneyX + 100,
                self.pos.moneyY + self.pos.distanceY * 2 + 110
            )
        elseif WORLD.player.berserkLevel == 1 then
            love.graphics.print(
                self.prices.berserk2,
                self.pos.moneyX + 100,
                self.pos.moneyY + self.pos.distanceY * 2 + 110
            )
        elseif WORLD.player.berserkLevel == 2 then
            love.graphics.print(
                self.prices.berserk3,
                self.pos.moneyX + 100,
                self.pos.moneyY + self.pos.distanceY * 2 + 110
            )
        end

        love.graphics.draw(WORLD.media.hud.money, self.pos.moneyX, self.pos.moneyY + (self.pos.distanceY * 4), 0, 0.5)
        if WORLD.player.goFastLevel == 0 then
            love.graphics.print(
                self.prices.fast1,
                self.pos.moneyX + 100,
                self.pos.moneyY + self.pos.distanceY * 3 + 110
            )
        elseif WORLD.player.goFastLevel == 1 then
            love.graphics.print(
                self.prices.fast2,
                self.pos.moneyX + 100,
                self.pos.moneyY + self.pos.distanceY * 3 + 110
            )
        elseif WORLD.player.goFastLevel == 2 then
            love.graphics.print(
                self.prices.fast3,
                self.pos.moneyX + 100,
                self.pos.moneyY + self.pos.distanceY * 3 + 110
            )
        end

        love.graphics.draw(WORLD.media.hud.money, self.pos.moneyX, self.pos.moneyY + (self.pos.distanceY * 5), 0, 0.5)

        if WORLD.player.burstLevel == 0 then
            love.graphics.print(
                self.prices.burst1,
                self.pos.moneyX + 100,
                self.pos.moneyY + self.pos.distanceY * 4 + 110
            )
        elseif WORLD.player.burstLevel == 1 then
            love.graphics.print(
                self.prices.burst2,
                self.pos.moneyX + 100,
                self.pos.moneyY + self.pos.distanceY * 4 + 110
            )
        elseif WORLD.player.burstLevel == 2 then
            love.graphics.print(
                self.prices.burst3,
                self.pos.moneyX + 100,
                self.pos.moneyY + self.pos.distanceY * 4 + 110
            )
        end
    end
}
