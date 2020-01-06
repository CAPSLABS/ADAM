return {
    alpha = 0,
    fadeIn = true,
    update = function(self, dt)
        if self.fadeIn then
            if self.alpha < 255 then
                self.alpha = self.alpha + dt
            end
        else
            self.alpha = self.alpha - dt
        end
    end
}
