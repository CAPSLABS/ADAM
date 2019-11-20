return {
    tooBroke = false,
    tooBrokeMsgTimerMax = 2,
    tooBrokeMsgTimer = 2,
    media = {
        back = "assets/forestLayered/back.png",
        light = "assets/forestLayered/light.png",
        middle = "assets/forestLayered/middle.png",
        fore = "assets/forestLayered/fore.png",
        sensei = "assets/mage.png",
        senseiAngry = "assets/mageAngry.png",
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
        if self.tooBroke then
            self:timeTooBrokeMessage(dt)
        end
        if WORLD.player.boomLevel == 1 then
            -- todo draw price
            SUIT.ImageButton(WORLD.media.hud.boomUsed, self.pos.baseX, self.pos.baseY)
            if SUIT.ImageButton(WORLD.media.hud.boom, self.pos.baseX + (self.pos.distanceX), self.pos.baseY).hit then
                if self:buy(self.prices.boom2) then
                    WORLD.player:lvlUpBoom()
                else
                    self.tooBroke = true
                    self.sensei = self.media.senseiAngry
                end
            end
            SUIT.ImageButton(WORLD.media.hud.boomUsed, self.pos.baseX + (self.pos.distanceX * 2), self.pos.baseY)
        elseif WORLD.player.boomLevel == 2 then
            SUIT.ImageButton(WORLD.media.hud.boomUsed, self.pos.baseX, self.pos.baseY)
            SUIT.ImageButton(WORLD.media.hud.boomUsed, self.pos.baseX + (self.pos.distanceX), self.pos.baseY)
            if SUIT.ImageButton(WORLD.media.hud.boom, self.pos.baseX + (self.pos.distanceX * 2), self.pos.baseY).hit then
                if self:buy(self.prices.boom3) then
                    WORLD.player:lvlUpBoom()
                else
                    self.tooBroke = true
                    self.sensei = self.media.senseiAngry
                end
            end
        elseif WORLD.player.boomLevel == 3 then
            SUIT.ImageButton(WORLD.media.hud.boomUsed, self.pos.baseX, self.pos.baseY)
            SUIT.ImageButton(WORLD.media.hud.boomUsed, self.pos.baseX + (self.pos.distanceX), self.pos.baseY)
            SUIT.ImageButton(WORLD.media.hud.boomUsed, self.pos.baseX + (self.pos.distanceX * 2), self.pos.baseY)
        end

        if WORLD.player.fireLevel == 0 then
            if SUIT.ImageButton(WORLD.media.hud.fire, self.pos.baseX, self.pos.baseY + (self.pos.distanceY)).hit then
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
        elseif WORLD.player.fireLevel == 1 then
            SUIT.ImageButton(WORLD.media.hud.fireUsed, self.pos.baseX, self.pos.baseY + (self.pos.distanceY))
            if
                SUIT.ImageButton(
                    WORLD.media.hud.fire,
                    self.pos.baseX + (self.pos.distanceX * 1),
                    self.pos.baseY + (self.pos.distanceY)
                ).hit
             then
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
        elseif WORLD.player.fireLevel == 2 then
            SUIT.ImageButton(WORLD.media.hud.fireUsed, self.pos.baseX, self.pos.baseY + (self.pos.distanceY))
            SUIT.ImageButton(
                WORLD.media.hud.fireUsed,
                self.pos.baseX + (self.pos.distanceX * 1),
                self.pos.baseY + (self.pos.distanceY)
            )
            if
                SUIT.ImageButton(
                    WORLD.media.hud.fire,
                    self.pos.baseX + (self.pos.distanceX * 2),
                    self.pos.baseY + (self.pos.distanceY)
                ).hit
             then
                if self:buy(self.prices.fire3) then
                    WORLD.player:lvlUpFire()
                else
                    self.tooBroke = true
                    self.sensei = self.media.senseiAngry
                end
            end
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
        if WORLD.player.berserkLevel == 0 then
            if
                SUIT.ImageButton(
                    WORLD.media.hud.berserk,
                    self.pos.baseX + (self.pos.distanceX * 0),
                    self.pos.baseY + (self.pos.distanceY * 2)
                ).hit
             then
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
        elseif WORLD.player.berserkLevel == 1 then
            SUIT.ImageButton(
                WORLD.media.hud.berserkUsed,
                self.pos.baseX + (self.pos.distanceX * 0),
                self.pos.baseY + (self.pos.distanceY * 2)
            )
            if
                SUIT.ImageButton(
                    WORLD.media.hud.berserk,
                    self.pos.baseX + (self.pos.distanceX * 1),
                    self.pos.baseY + (self.pos.distanceY * 2)
                ).hit
             then
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
            if
                SUIT.ImageButton(
                    WORLD.media.hud.berserk,
                    self.pos.baseX + (self.pos.distanceX * 2),
                    self.pos.baseY + (self.pos.distanceY * 2)
                ).hit
             then
                if self:buy(self.prices.berserk3) then
                    WORLD.player:lvlUpBerserk()
                else
                    self.tooBroke = true
                    self.sensei = self.media.senseiAngry
                end
            end
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

        if WORLD.player.fastLevel == 0 then
            if SUIT.ImageButton(WORLD.media.hud.fast, self.pos.baseX, self.pos.baseY + (self.pos.distanceY * 3)).hit then
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
        elseif WORLD.player.fastLevel == 1 then
            SUIT.ImageButton(WORLD.media.hud.fastUsed, self.pos.baseX, self.pos.baseY + (self.pos.distanceY * 3))

            if
                SUIT.ImageButton(
                    WORLD.media.hud.fast,
                    self.pos.baseX + (self.pos.distanceX),
                    self.pos.baseY + (self.pos.distanceY * 3)
                ).hit
             then
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
        elseif WORLD.player.fastLevel == 2 then
            SUIT.ImageButton(WORLD.media.hud.fastUsed, self.pos.baseX, self.pos.baseY + (self.pos.distanceY * 3))
            SUIT.ImageButton(
                WORLD.media.hud.fastUsed,
                self.pos.baseX + (self.pos.distanceX),
                self.pos.baseY + (self.pos.distanceY * 3)
            )
            if
                SUIT.ImageButton(
                    WORLD.media.hud.fast,
                    self.pos.baseX + (self.pos.distanceX * 2),
                    self.pos.baseY + (self.pos.distanceY * 3)
                ).hit
             then
                if self:buy(self.prices.fast3) then
                    WORLD.player:lvlUpFast()
                else
                    self.tooBroke = true
                    self.sensei = self.media.senseiAngry
                end
            end
        elseif WORLD.player.fastLevel == 3 then
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
            if SUIT.ImageButton(WORLD.media.hud.explo, self.pos.baseX, self.pos.baseY + (self.pos.distanceY * 4)).hit then
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
        elseif WORLD.player.burstLevel == 1 then
            SUIT.ImageButton(WORLD.media.hud.exploUsed, self.pos.baseX, self.pos.baseY + (self.pos.distanceY * 4))

            if
                SUIT.ImageButton(
                    WORLD.media.hud.explo,
                    self.pos.baseX + (self.pos.distanceX),
                    self.pos.baseY + (self.pos.distanceY * 4)
                ).hit
             then
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
        elseif WORLD.player.burstLevel == 2 then
            SUIT.ImageButton(WORLD.media.hud.exploUsed, self.pos.baseX, self.pos.baseY + (self.pos.distanceY * 4))

            SUIT.ImageButton(
                WORLD.media.hud.exploUsed,
                self.pos.baseX + (self.pos.distanceX),
                self.pos.baseY + (self.pos.distanceY * 4)
            )
            if
                SUIT.ImageButton(
                    WORLD.media.hud.explo,
                    self.pos.baseX + (self.pos.distanceX * 2),
                    self.pos.baseY + (self.pos.distanceY * 4)
                ).hit
             then
                if self:buy(self.prices.burst3) then
                    WORLD.player:lvlUpBurst()
                else
                    self.tooBroke = true
                    self.sensei = self.media.senseiAngry
                end
            end
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
            InitGame(1)
        --todo transition to next level here
        end
    end,
    drawShopShit = function(self)
        love.graphics.setFont(WORLD.media.fantasyfont)
        if self.tooBroke then
            SUIT.Label("AND HOW DO YOU PLAN TO PAY FOR THIS?!", 26, 360, 320, 0)
            WORLD:drawExplosionScreenShake()
        else
            SUIT.Label("It's dangerous to fight alone", 26, 340, 320, 0)
            SUIT.Label("What do you want to be tought?", 26, 400, 320, 0)
        end

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
            love.graphics.print(self.prices.boom2, self.pos.moneyX + 100, self.pos.moneyY + 110)
        elseif WORLD.player.boomLevel == 2 then
            love.graphics.print(self.prices.boom3, self.pos.moneyX + 100, self.pos.moneyY + 110)
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
        if WORLD.player.fastLevel == 0 then
            love.graphics.print(
                self.prices.fast1,
                self.pos.moneyX + 100,
                self.pos.moneyY + self.pos.distanceY * 3 + 110
            )
        elseif WORLD.player.fastLevel == 1 then
            love.graphics.print(
                self.prices.fast2,
                self.pos.moneyX + 100,
                self.pos.moneyY + self.pos.distanceY * 3 + 110
            )
        elseif WORLD.player.fastLevel == 2 then
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
