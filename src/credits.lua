return {
    fadeDone = false,
    loadCredits = function(self)
        MUSIC:startMusic("credits")
    end,
    update = function(self, dt)
        if WORLD.credits then
            if not self.fadeDone then
                FADER.fadeIn = false
                FADER:update(dt)
                if FADER.alpha >= 255 then
                    self.fadeDone = true
                end
            end
        end
    end
}
