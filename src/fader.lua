return {
    alpha = 0,
    fadeIn = function(self, dt)
        self.alpha = self.alpha + dt * 1.5
        if self.alpha >= 1 then
            self.alpha = 0
            return true
        else
            return false
        end
    end,
    fadeToBlack = function(self, dt)
        self.alpha = self.alpha - dt * 1.5
        if self.alpha <= 0 then
            self.alpha = 1
            return true
        else
            return false
        end
    end
}
