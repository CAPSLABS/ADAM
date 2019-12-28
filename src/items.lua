return {
    -- datastructure for a heart that heals 1hp
    heart = {
        x = 0, -- will be changed to the drop location x
        y = 0, -- will be changed to the drop location y
        img = "assets/hud/healthbar/heart_cropped.png", -- is later a love image
        setDropLocation = function(self, posX, posY)
            self.x = posX
            self.y = posY
        end,
        effect = function(self, currentLvl)
            if WORLD.player.hearts < WORLD.player.maxHearts then
                WORLD.player.hearts = WORLD.player.hearts + 1
            end
        end
    },
    -- datastructure for a collectable coin, a story item
    importantCoin = {
        x = 0, -- will be changed to the drop location x
        y = 0, -- will be changed to the drop location y
        img = "assets/hud/money/coin_cropped_inverse.png", -- is later a love image
        setDropLocation = function(self, posX, posY)
            self.x = posX
            self.y = posY
        end,
        effect = function(self, currentLvl)
            if WORLD.levels[currentLvl].counter < WORLD.levels[currentLvl].goal then
                WORLD.levels[currentLvl].counter = WORLD.levels[currentLvl].counter + 1
            end
        end
    }
}
