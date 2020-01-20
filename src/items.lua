return {
    -- datastructure for a heart that heals 1hp
    heart = {
        x = 0, -- will be changed to the drop location x
        y = 0, -- will be changed to the drop location y
        img = "assets/hud/healthbar/heart_cropped.png", -- is later a love image
        gettingPickedUp = false,
        setDropLocation = function(self, posX, posY)
            self.x = posX
            self.y = posY
        end,
        effect = function(self, _)
            if not self.gettingPickedUp and WORLD.player.hearts < WORLD.player.maxHearts then
                self.gettingPickedUp = true
                WORLD.player.hearts = WORLD.player.hearts + 1
            end
        end
    },
    -- datastructure for a collectable coin, a story item
    importantCoin = {
        x = 0, -- will be changed to the drop location x
        y = 0, -- will be changed to the drop location y
        img = "assets/hud/money/coin_cropped_inverse.png", -- is later a love image
        gettingPickedUp = false,
        setDropLocation = function(self, posX, posY)
            self.x = posX
            self.y = posY
        end,
        effect = function(self, currentLvl)
            if not self.gettingPickedUp and WORLD.levels[currentLvl].counter < WORLD.levels[currentLvl].goal then
                self.gettingPickedUp = true
                WORLD.levels[currentLvl].counter = WORLD.levels[currentLvl].counter + 1
            end
        end
    }
}
