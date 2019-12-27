return {
    direction = nil,
    path = nil,
    side = nil,
    currentQuad = nil,
    drawable = nil,
    leftQuad = nil,
    rightQuad = nil,
    name = nil,
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
    wiggleAnim = function(self)
        print("i would be wiggling now")
    end
}
