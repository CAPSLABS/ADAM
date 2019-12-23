return {
    --heart = {
    x = 0, -- will be changed to the drop location x
    y = 0, -- will be changed to the drop location y
    img = "assets/hud/healthbar/heart_cropped.png", -- is later a love image
    new = function(self)
        local heart = {}
        return heart
    end,
    effect = function(self)
        if WORLD.player.hearts < WORLD.player.maxHearts then
            WORLD.player.hearts = WORLD.player.hearts + 1
        end
    end
    --},
    --importantCoin = {
    --    x = 0, -- will be changed to the drop location x
    --    y = 0, -- will be changed to the drop location y
    --    img = "assets/hud/healthbar/heart_cropped.png", -- is later a love image
    --    new = function(self)
    --        local coin = {}
    --        return coin
    --    end,
    --    effect = function(self)
    --        if WORLD.player.hearts < WORLD.player.maxHearts then
    --            WORLD.player.hearts = WORLD.player.hearts + 1
    --        end
    --    end
}
