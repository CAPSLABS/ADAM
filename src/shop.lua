return {
    tooBroke = false,
    tooBrokeMsgTimerMax = 2,
    tooBrokeMsgTimer = 2,
    focussedIconBorderWidth = 3,
    specialCategory = nil,
    specialText = nil,
    specialPrice = nil,
    wallPerc = nil,
    clicked = false, -- if we bought anything in current shop session
    media = {
        back = "assets/forestLayered/back.png",
        light = "assets/forestLayered/light.png",
        middle = "assets/forestLayered/middle.png",
        fore = "assets/forestLayered/fore.png",
        sensei = "assets/cha_sprites/mage.png",
        senseiAngry = "assets/cha_sprites/mageAngry.png",
        done = "assets/hud/done_288x96.png",
        wall = "assets/hud/borderedWall.png"
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
        doneY = 850,
        wallX = 45,
        wallY = 235
    },
    prices = {
        wall = {1000}, -- price changes
        boom = {0, 50, 200},
        fire = {10, 50, 200},
        berserk = {10, 50, 200},
        fast = {10, 50, 200},
        burst = {30, 300, 300}
    },
    currentRow = 1,
    hovered = {false, false, false, false, false, false}, -- one for each button
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
            self.clicked = true
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
            local button =
                SUIT.ImageButton(
                WORLD.media.hud.boom,
                self.pos.baseX + (self.pos.distanceX * (WORLD.player.boomLevel)),
                self.pos.baseY
            )
            if button.hit then
                if self:buy(self.prices.boom[WORLD.player.boomLevel + 1]) then
                    WORLD.player:lvlUpBoom()
                else
                    self.tooBroke = true
                    self.sensei = self.media.senseiAngry
                end
            end
            -- button counts as hovered if it really was hovered or selected via keys
            self.hovered[1] = button.hovered or (self.currentRow == 1)
            if self.hovered[1] then
                self.currentRow = 1
            end
        end
        SUIT.ImageButton(WORLD.media.hud.boomUsed, self.pos.baseX, self.pos.baseY)
        SUIT.ImageButton(WORLD.media.hud.boomUsed, self.pos.baseX + (self.pos.distanceX), self.pos.baseY)
        SUIT.ImageButton(WORLD.media.hud.boomUsed, self.pos.baseX + (self.pos.distanceX * 2), self.pos.baseY)

        -- Check if fire button of next respective level is hit or hovered
        if WORLD.player.fireLevel < 3 then
            local button =
                SUIT.ImageButton(
                WORLD.media.hud.fire,
                self.pos.baseX + (self.pos.distanceX * (WORLD.player.fireLevel)),
                self.pos.baseY + self.pos.distanceY
            )
            if button.hit then
                if self:buy(self.prices.fire[WORLD.player.fireLevel + 1]) then
                    WORLD.player:lvlUpFire()
                else
                    self.tooBroke = true
                    self.sensei = self.media.senseiAngry
                end
            end
            self.hovered[2] = button.hovered or (self.currentRow == 2)
            if self.hovered[2] then
                self.currentRow = 2
            end
        end
        SUIT.ImageButton(WORLD.media.hud.fireUsed, self.pos.baseX, self.pos.baseY + self.pos.distanceY)
        SUIT.ImageButton(
            WORLD.media.hud.fireUsed,
            self.pos.baseX + (self.pos.distanceX),
            self.pos.baseY + self.pos.distanceY
        )
        SUIT.ImageButton(
            WORLD.media.hud.fireUsed,
            self.pos.baseX + (self.pos.distanceX * 2),
            self.pos.baseY + self.pos.distanceY
        )

        -- Check if berserk button of next respective level is hit or hovered
        if WORLD.player.berserkLevel < 3 then
            local button =
                SUIT.ImageButton(
                WORLD.media.hud.berserk,
                self.pos.baseX + (self.pos.distanceX * (WORLD.player.berserkLevel)),
                self.pos.baseY + 2 * self.pos.distanceY
            )
            if button.hit then
                if self:buy(self.prices.berserk[WORLD.player.berserkLevel + 1]) then
                    WORLD.player:lvlUpBerserk()
                else
                    self.tooBroke = true
                    self.sensei = self.media.senseiAngry
                end
            end
            self.hovered[3] = button.hovered or (self.currentRow == 3)
            if self.hovered[3] then
                self.currentRow = 3
            end
        end
        SUIT.ImageButton(WORLD.media.hud.berserkUsed, self.pos.baseX, self.pos.baseY + 2 * self.pos.distanceY)
        SUIT.ImageButton(
            WORLD.media.hud.berserkUsed,
            self.pos.baseX + (self.pos.distanceX),
            self.pos.baseY + 2 * self.pos.distanceY
        )
        SUIT.ImageButton(
            WORLD.media.hud.berserkUsed,
            self.pos.baseX + (self.pos.distanceX * 2),
            self.pos.baseY + 2 * self.pos.distanceY
        )

        -- Check if sonic button of next respective level is hit or hovered
        if WORLD.player.goFastLevel < 3 then
            local button =
                SUIT.ImageButton(
                WORLD.media.hud.fast,
                self.pos.baseX + (self.pos.distanceX * (WORLD.player.goFastLevel)),
                self.pos.baseY + 3 * self.pos.distanceY
            )
            if button.hit then
                if self:buy(self.prices.fast[WORLD.player.goFastLevel + 1]) then
                    WORLD.player:lvlUpFast()
                else
                    self.tooBroke = true
                    self.sensei = self.media.senseiAngry
                end
            end
            self.hovered[4] = button.hovered or (self.currentRow == 4)
            if self.hovered[4] then
                self.currentRow = 4
            end
        end
        SUIT.ImageButton(WORLD.media.hud.fastUsed, self.pos.baseX, self.pos.baseY + 3 * self.pos.distanceY)
        SUIT.ImageButton(
            WORLD.media.hud.fastUsed,
            self.pos.baseX + (self.pos.distanceX),
            self.pos.baseY + 3 * self.pos.distanceY
        )
        SUIT.ImageButton(
            WORLD.media.hud.fastUsed,
            self.pos.baseX + (self.pos.distanceX * 2),
            self.pos.baseY + 3 * self.pos.distanceY
        )

        -- Check if burst button of next respective level is hit or hovered
        if WORLD.player.burstLevel < 3 then
            local button =
                SUIT.ImageButton(
                WORLD.media.hud.explo,
                self.pos.baseX + (self.pos.distanceX * (WORLD.player.burstLevel)),
                self.pos.baseY + 4 * self.pos.distanceY
            )
            if button.hit then
                if self:buy(self.prices.burst[WORLD.player.burstLevel + 1]) then
                    WORLD.player:lvlUpBurst()
                else
                    self.tooBroke = true
                    self.sensei = self.media.senseiAngry
                end
            end
            self.hovered[5] = button.hovered or (self.currentRow == 5)
            if self.hovered[5] then
                self.currentRow = 5
            end
        end
        SUIT.ImageButton(WORLD.media.hud.exploUsed, self.pos.baseX, self.pos.baseY + 4 * self.pos.distanceY)
        SUIT.ImageButton(
            WORLD.media.hud.exploUsed,
            self.pos.baseX + (self.pos.distanceX),
            self.pos.baseY + 4 * self.pos.distanceY
        )
        SUIT.ImageButton(
            WORLD.media.hud.exploUsed,
            self.pos.baseX + (self.pos.distanceX * 2),
            self.pos.baseY + 4 * self.pos.distanceY
        )

        -- done button
        local doneButton = SUIT.ImageButton(self.media.done, self.pos.doneX - (self.media.done:getWidth() / 2), self.pos.doneY)
        if doneButton.hit then
            love.graphics.setBackgroundColor(0, 0, 0, 0)
            if WORLD.endlessmode then
                self.clicked = false
                self.todaysSpecial = nil
                self.specialCategory = nil
                WORLD.shoppedThisIteration = true
                WORLD:nextEndlessMode()
            else
                InitGame(WORLD.currentLvl, 6)
            end
        end
        self.hovered[6] = doneButton.hovered or (self.currentRow == 6)
        if self.hovered[6] then
            self.currentRow = 6
        end
        if WORLD.endlessmode and not self.clicked and WORLD.player.money > 10 then
            self:cityHealth()
        end

        -- set all to false that are not the currentRow
        for i = 1,6 do 
            if self.hovered[i] and i ~= self.currentRow then
                self.hovered[i] = false
            end
        end
    end,
    cityHealth = function(self)
        if self.specialCategory == nil then
            self:setWallCategory()
        end
        love.graphics.setFont(WORLD.media.fantasyfont)
        SUIT.Label("TODAYS SPECIAL:\n" .. self.wallPerc .. " % CITY HEALTH!\n" .. self.specialText, 0, 250, 450, 0)
        if SUIT.ImageButton(self.media.wall, self.pos.wallX, self.pos.wallY).hit then
            self.clicked = true
            SHOP:buy(self.prices.wall[1])
            WORLD.player:buySpecialOffer()
        end
    end,
    setWallCategory = function(self)
        self.specialCategory = math.random(0, 3)
        if self.specialCategory == 0 then
            self.specialText = "FREE OF CHARGE!"
            self.wallPerc = "0"
            self.wallPercMultiplier = 0
            self.specialPrice = 0
        elseif self.specialCategory == 1 then
            self.specialText = "A THIRD OF YOUR MONEY!"
            self.wallPerc = "10"
            self.wallPercMultiplier = 0.1
            self.specialPrice = math.floor(WORLD.player.money * 0.3)
        elseif self.specialCategory == 2 then
            self.specialText = "HALF YOUR MONEY!"
            self.wallPercMultiplier = 0.2
            self.wallPerc = "20"
            self.specialPrice = math.ceil(WORLD.player.money * 0.5)
        elseif self.specialCategory == 3 then
            self.specialText = "ALL THE MONEYS!"
            self.wallPerc = "30"
            self.wallPercMultiplier = 0.3
            self.specialPrice = WORLD.player.money
        else
            print("this is broken")
        end
        self.prices.wall[1] = self.specialPrice
    end,
    broUBroke = function(self)
        love.graphics.setFont(WORLD.media.fantasyfont)
        if self.tooBroke then
            SUIT.Label("AND HOW DO YOU PLAN TO PAY FOR THIS?!", 26, 360, 320, 0)
            WORLD:drawScreenShake(-5, 5)
        else
            if self.hovered[1] then
                SUIT.Label("Press [A] to throw deadly boomerangs in a straight line!", 26, 340, 320, 0)
            elseif self.hovered[2] then
                SUIT.Label("Press [S] to release a scorching fire cone in front of you!", 26, 340, 320, 0)
            elseif self.hovered[3] then
                SUIT.Label("Press [D] to go into a furious berserk mode!", 26, 340, 320, 0)
                SUIT.Label("In this mode you can shoot boomerangs incredibly fast!", 26, 400, 320, 0)
            elseif self.hovered[4] then
                SUIT.Label("Press [F] to generate a protective sphere and get increasingly faster!", 26, 340, 320, 0)
                SUIT.Label("The sphere damages enemies and saves you from harm!", 26, 400, 320, 0)
            elseif self.hovered[5] then
                SUIT.Label("Press [Space] to detonate an all hitting explosion!", 26, 340, 320, 0)
            else
                SUIT.Label("What do you want to be taught?", 26, 340, 320, 0)
                SUIT.Label("Upgrading a skill will halve its cooldown!", 26, 400, 320, 0)
            end
        end
    end,
    drawShopShit = function(self)
        self:drawBackground()
        self:broUBroke()
        self:drawFocussedIconBorder()
        SUIT.draw()
        if WORLD.endlessmode then
            WORLD:drawHealthBar()
        end
        self:drawIconBorders()
        self:drawPrices()
    end,
    drawBackground = function(self)
        love.graphics.setBackgroundColor(0.45, 0.31, 0.2, 0)
        love.graphics.draw(SHOP.media.back, 0, 0, 0, 2, 2)
        love.graphics.draw(SHOP.media.light, 0, 0, 0, 2, 2)
        love.graphics.draw(SHOP.media.middle, 0, 0, 0, 2, 2)
        love.graphics.draw(SHOP.media.fore, 0, 0, 0, 2, 2)
        love.graphics.draw(SHOP.sensei, 250, 100, 0, 4, 4)
    end,
    drawFocussedIconBorder = function(self)
        -- set color to red
        love.graphics.setColor(1, 0, 0)
        love.graphics.setLineWidth(self.focussedIconBorderWidth)
        if self.currentRow == 0 then
            if not self.clicked then
                -- draw red rectangle
                love.graphics.rectangle(
                    "line",
                    self.pos.wallX - self.focussedIconBorderWidth,
                    self.pos.wallY - self.focussedIconBorderWidth,
                    self.media.wall:getWidth() + 2 * self.focussedIconBorderWidth,
                    self.media.wall:getHeight() + 2 * self.focussedIconBorderWidth
                )
            end
        elseif 1 <= self.currentRow and self.currentRow <= 5 then
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
        love.graphics.setLineWidth(1)
        love.graphics.setColor(255, 255, 255)
    end,
    getSkillFromRow = function(self)
        -- Goal: given currentRow, get all relevat info for that skill
        if self.currentRow == 0 then
            return "wall", 0, WORLD.player.buySpecialOffer
        elseif self.currentRow == 1 then
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
    -- TODO: Quality of life: If skill maxed, then cursor should find next clickable icon and go there
    --findNextClickableIcon = function(self)
    --end,
    drawIconBorders = function(self)
        -- draw frame borders
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
    end,
    drawPrices = function(self)
        love.graphics.setFont(WORLD.media.bigfantasyfont)

        -- player cash: first the coin symbol then the amount
        love.graphics.draw(WORLD.media.hud.money, self.pos.moneyX, self.pos.moneyY - 30, 0, 0.5)
        love.graphics.print(WORLD.player.money, self.pos.moneyX + 90, self.pos.moneyY)

        -- boom cost
        love.graphics.draw(WORLD.media.hud.money, self.pos.moneyX, self.pos.moneyY + self.pos.distanceY, 0, 0.5)
        if WORLD.player.boomLevel < 3 then
            love.graphics.print(
                self.prices.boom[WORLD.player.boomLevel + 1],
                self.pos.moneyX + 100,
                self.pos.moneyY + 110
            )
        end

        -- fire cost
        love.graphics.draw(WORLD.media.hud.money, self.pos.moneyX, self.pos.moneyY + (self.pos.distanceY * 2), 0, 0.5)
        if WORLD.player.fireLevel < 3 then
            love.graphics.print(
                self.prices.fire[WORLD.player.fireLevel + 1],
                self.pos.moneyX + 100,
                self.pos.moneyY + self.pos.distanceY + 110
            )
        end

        -- berserk cost
        love.graphics.draw(WORLD.media.hud.money, self.pos.moneyX, self.pos.moneyY + (self.pos.distanceY * 3), 0, 0.5)
        if WORLD.player.berserkLevel < 3 then
            love.graphics.print(
                self.prices.berserk[WORLD.player.berserkLevel + 1],
                self.pos.moneyX + 100,
                self.pos.moneyY + 2 * self.pos.distanceY + 110
            )
        end

        -- go fast cost
        love.graphics.draw(WORLD.media.hud.money, self.pos.moneyX, self.pos.moneyY + (self.pos.distanceY * 4), 0, 0.5)
        if WORLD.player.goFastLevel < 3 then
            love.graphics.print(
                self.prices.fast[WORLD.player.goFastLevel + 1],
                self.pos.moneyX + 100,
                self.pos.moneyY + 3 * self.pos.distanceY + 110
            )
        end

        -- burst cost
        love.graphics.draw(WORLD.media.hud.money, self.pos.moneyX, self.pos.moneyY + (self.pos.distanceY * 5), 0, 0.5)
        if WORLD.player.burstLevel < 3 then
            love.graphics.print(
                self.prices.burst[WORLD.player.burstLevel + 1],
                self.pos.moneyX + 100,
                self.pos.moneyY + 4 * self.pos.distanceY + 110
            )
        end
    end
}
