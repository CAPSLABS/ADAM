return {
    direction = nil,
    path = nil,
    side = nil,
    currentQuad = nil,
    drawable = nil,
    leftQuad = nil,
    rightQuad = nil,
    name = nil,
    y = 600,
    yMax = 550,
    inAnimation = false,
    verticalDirection = nil,
    speed = 10,
    init = function(self, name, quadPositions)
        self.name = name
        self.path = quadPositions["path"]
        self.drawable = love.graphics.newImage(quadPositions["path"])
        self.leftQuad =
            love.graphics.newQuad(
            quadPositions.columnLeft * 64,
            quadPositions.rowLeft * 64,
            64,
            64,
            self.drawable:getWidth(),
            self.drawable:getHeight()
        )
        self.rightQuad =
            love.graphics.newQuad(
            quadPositions.columnRight * 64,
            quadPositions.rowRight * 64,
            64,
            64,
            self.drawable:getWidth(),
            self.drawable:getHeight()
        )
    end,
    setSide = function(self, side)
        if side == "right" then
            self.side = "right"
            self.direction = "right"
            self.currentQuad = self.rightQuad
        else
            self.side = "left"
            self.direction = "left"
            self.currentQuad = self.leftQuad
        end
    end,
    changeDirection = function(self)
        if self.direction == "left" then
            self.direction = "right"
            self.currentQuad = self.rightQuad
        else
            self.direction = "left"
            self.currentQuad = self.leftQuad
        end
    end,
    setWiggleAnim = function(self)
        self.inAnimation = true
        self.verticalDirection = "up"
    end,
    update = function(self)
        if self.y < self.yMax then
            self.verticalDirection = "down"
        end
        if self.y > 600 then
            self.y = 600
            self.inAnimation = false
            print(self.y)
            self.verticalDirection = nil
        end

        if self.verticalDirection == "up" then
            self.y = self.y - self.speed
        elseif self.verticalDirection == "down" then
            self.y = self.y + self.speed
        end
    end
}
