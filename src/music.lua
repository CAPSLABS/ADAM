return {
    airhorn = nil,
    tracks = {
        mainMenu = nil,
        lilith = nil,
        villageBattle = nil,
        shop = nil,
        william = nil,
        mountain = nil,
        mountainBattle = nil,
        cave = nil,
        caveBattle = nil,
        finalBattle = nil,
        credits = nil
    },
    load = function(self)
        self:loadMusic()
        self:loadMenuSounds()
    end,
    loadMusic = function(self)
        self.tracks.mainMenu = love.audio.newSource("assets/sounds/music/01_main_menu.mp3", "static")
        self.tracks.lilith = love.audio.newSource("assets/sounds/music/02_village_dialog_lilith.mp3", "static")
        self.tracks.villageBattle = love.audio.newSource("assets/sounds/music/03_village_battle.mp3", "static")
        self.tracks.shop = love.audio.newSource("assets/sounds/music/04_shop.mp3", "static")
        self.tracks.william = love.audio.newSource("assets/sounds/music/05_village_dialog_william.mp3", "static")
        self.tracks.mountain = love.audio.newSource("assets/sounds/music/06_mountain_dialog.mp3", "static")
        self.tracks.mountainBattle = love.audio.newSource("assets/sounds/music/07_mountain_battle.mp3", "static")
        self.tracks.cave = love.audio.newSource("assets/sounds/music/08_cave_dialog.mp3", "static")
        self.tracks.caveBattle = love.audio.newSource("assets/sounds/music/09_cave_battle.mp3", "static")
        self.tracks.finalBattle = love.audio.newSource("assets/sounds/music/10_final_battle.mp3", "static")
        self.tracks.credits = love.audio.newSource("assets/sounds/music/11_credits.mp3", "static")
    end,
    loadMenuSounds = function(self)
        self.airhorn = love.audio.newSource("assets/sounds/air_horn_sound.mp3", "static")
    end,
    startMusic = function(self, title)
        self.tracks[title]:play()
    end,
    changeVolume = function(self, volume)
        for key, track in pairs(self.tracks) do
            track:setVolume(volume)
        end
    end
}
