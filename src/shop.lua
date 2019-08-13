return {
    media = {
        back = "assets/forestLayered/back.png",
        light = "assets/forestLayered/light.png",
        middle = "assets/forestLayered/middle.png",
        fore = "assets/forestLayered/fore.png",
        sensei = "assets/mage.png"
    },
    font = nil,

    loadBacking = function(self)
        for key, img in pairs(self.media) do
            self.media[key] = love.graphics.newImage(img)
        end

        self.font = love.graphics.newFont("assets/font/Komi.ttf", 15)
        --love.graphics.setFont(self.font)
    end,


    drawText = function(self)
    end,

    drawShopShit = function(self)
        love.graphics.setFont(self.font)
        love.graphics.draw(shop.media.back, 0, 0, 0, 2, 2)
        love.graphics.draw(shop.media.light, 0, 0, 0, 2, 2)
        love.graphics.draw(shop.media.middle, 0,0, 0, 2, 2)
        love.graphics.draw(shop.media.fore, 0,0,  0, 2, 2)
        love.graphics.draw(shop.media.sensei,240,100, 0, 4, 4)

        suit.layout:reset(100,50)
        suit.Label("Willkommen!", 50,330, 300,30)
        suit.Label("Was moechtest du trainieren?", 50,350, 300,30)

        if suit.ImageButton(world.player.media.fire, 50, 370).hit then
            print("hit")
        end
        --rectangle around it
    end,

}