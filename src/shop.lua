return {
    media = {
        back = "assets/forestLayered/back.png",
        light = "assets/forestLayered/light.png",
        middle = "assets/forestLayered/middle.png",
        fore = "assets/forestLayered/fore.png",
        sensei = "assets/mage.png"
    },
    pos = {
        baseX = 70,
        baseY = 460,
        moneyX = 320,
        moneyY = 360,
        distanceX = 80,
        distanceY = 80
    },
    prices = {
        boom2 = 100,
        boom3 = 200,
        fire1 = 10,
        fire2 = 100,
        fire3 = 200,
        berserk1 = 10,
        berserk2 = 100,
        berserk3 = 200,
        fast1 = 10,
        fast2 = 100,
        fast3 = 200,
        explo1 = 10,
        explo2 = 300,
        explo3 = 300
    },
    loadBacking = function(self)
        for key, img in pairs(self.media) do
            self.media[key] = love.graphics.newImage(img)
        end
    end,
    updateShopShit = function(self)
        if WORLD.player.boomLevel == 1 then
            if SUIT.ImageButton(WORLD.media.hud.boom, self.pos.baseX, self.pos.baseY).hit then
                print("clicka da boomerang")
            end
        end

        if SUIT.ImageButton(WORLD.media.hud.boomUsed, self.pos.baseX + (self.pos.distanceX), self.pos.baseY).hit then
        --print("clicka da boomerang 2")
        end

        if SUIT.ImageButton(WORLD.media.hud.boomUsed, self.pos.baseX + (self.pos.distanceX * 2), self.pos.baseY).hit then
            print("clicka da boomerang AFUAHFOIA")
        end

        if SUIT.ImageButton(WORLD.media.hud.fire, self.pos.baseX, self.pos.baseY + (self.pos.distanceY)).hit then
            print("clicka da fire 1")
        end

        if
            SUIT.ImageButton(
                WORLD.media.hud.fireUsed,
                self.pos.baseX + (self.pos.distanceX * 1),
                self.pos.baseY + (self.pos.distanceY)
            ).hit
         then
            print("clicka da fire 2")
        end

        if
            SUIT.ImageButton(
                WORLD.media.hud.fireUsed,
                self.pos.baseX + (self.pos.distanceX * 2),
                self.pos.baseY + (self.pos.distanceY)
            ).hit
         then
            print("clicka da fire 3")
        end

        if
            SUIT.ImageButton(
                WORLD.media.hud.berserk,
                self.pos.baseX + (self.pos.distanceX * 0),
                self.pos.baseY + (self.pos.distanceY * 2)
            ).hit
         then
            print("clicka da berserk")
        end

        if
            SUIT.ImageButton(
                WORLD.media.hud.berserkUsed,
                self.pos.baseX + (self.pos.distanceX * 1),
                self.pos.baseY + (self.pos.distanceY * 2)
            ).hit
         then
            print("clicka da berserk")
        end

        if
            SUIT.ImageButton(
                WORLD.media.hud.berserkUsed,
                self.pos.baseX + (self.pos.distanceX * 2),
                self.pos.baseY + (self.pos.distanceY * 2)
            ).hit
         then
            print("clicka da berserk")
        end

        if SUIT.ImageButton(WORLD.media.hud.fast, self.pos.baseX, self.pos.baseY + (self.pos.distanceY * 3)).hit then
            print("clicka da FAST")
        end

        if
            SUIT.ImageButton(
                WORLD.media.hud.fastUsed,
                self.pos.baseX + (self.pos.distanceX),
                self.pos.baseY + (self.pos.distanceY * 3)
            ).hit
         then
            print("clicka da FAST")
        end

        if
            SUIT.ImageButton(
                WORLD.media.hud.fastUsed,
                self.pos.baseX + (self.pos.distanceX * 2),
                self.pos.baseY + (self.pos.distanceY * 3)
            ).hit
         then
            print("clicka da FAST")
        end

        if SUIT.ImageButton(WORLD.media.hud.explo, self.pos.baseX, self.pos.baseY + (self.pos.distanceY * 4)).hit then
            print("clicka explo")
        end

        if
            SUIT.ImageButton(
                WORLD.media.hud.exploUsed,
                self.pos.baseX + (self.pos.distanceX),
                self.pos.baseY + (self.pos.distanceY * 4)
            ).hit
         then
            print("clicka explo")
        end

        if
            SUIT.ImageButton(
                WORLD.media.hud.exploUsed,
                self.pos.baseX + (self.pos.distanceX * 2),
                self.pos.baseY + (self.pos.distanceY * 4)
            ).hit
         then
            print("clicka explo")
        end
    end,
    drawShopShit = function(self)
        love.graphics.setFont(WORLD.media.fantasyfont)
        SUIT.Label("It's dangerous to fight alone", 26, 340, 320, 0)
        SUIT.Label("What do you want to be tought?", 26, 400, 320, 0)

        love.graphics.setBackgroundColor(0.45, 0.31, 0.2, 0)
        love.graphics.draw(SHOP.media.back, 0, 0, 0, 2, 2)
        love.graphics.draw(SHOP.media.light, 0, 0, 0, 2, 2)
        love.graphics.draw(SHOP.media.middle, 0, 0, 0, 2, 2)
        love.graphics.draw(SHOP.media.fore, 0, 0, 0, 2, 2)
        love.graphics.draw(SHOP.media.sensei, 250, 100, 0, 4, 4)

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
        --love.graphics.print(WORLD.player.money, self.pos.moneyX+90, self.pos.moneyY+90)

        love.graphics.draw(WORLD.media.hud.money, self.pos.moneyX, self.pos.moneyY + (self.pos.distanceY * 2), 0, 0.5)

        love.graphics.draw(WORLD.media.hud.money, self.pos.moneyX, self.pos.moneyY + (self.pos.distanceY * 3), 0, 0.5)

        love.graphics.draw(WORLD.media.hud.money, self.pos.moneyX, self.pos.moneyY + (self.pos.distanceY * 4), 0, 0.5)

        love.graphics.draw(WORLD.media.hud.money, self.pos.moneyX, self.pos.moneyY + (self.pos.distanceY * 5), 0, 0.5)
    end
}
