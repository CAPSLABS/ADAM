-- [[
--      Given a path to a lua map (generated by i.e. tiled),
--      this function saves the data in a map object.
-- ]]

function LoadTiledMap(path, luamap)
    -- load map according to ebeneXtilemap.lua
    local map = require(path .. luamap)

    -- A quad is each grid cell in the tileset
    map.quads = {}

    -- Load every tileset image
    -- Use local references over tables of tables
    local tilesets = map.tilesets

    -- make the local reference a member so that we can use them in the draw function
    map.tilesets = tilesets

    -- Cache tileset images to use them in drawing
    map.images = {}
    for i, tileset in pairs(tilesets) do
        table.insert(map.images, love.graphics.newImage(path .. tileset.image))
    end

    --map.animatedTiles = {}
    --for i, tile in ipairs(tileset.tiles) do
    --    map.animatedTiles[tile.id] = tile
    --end

    map.frame = 0
    map.timer = 0.0
    map.maxTimer = 0.1

    -- Retrieve the quads
    for i, tileset in ipairs(map.tilesets) do
        for y = 0, (tileset.imageheight / tileset.tileheight) - 1 do
            for x = 0, (tileset.imagewidth / tileset.tilewidth) - 1 do
                local quad =
                    love.graphics.newQuad(
                    x * tileset.tilewidth,
                    y * tileset.tileheight,
                    tileset.tilewidth,
                    tileset.tileheight,
                    tileset.imagewidth,
                    tileset.imageheight
                )
                table.insert(map.quads, quad)
            end
        end
    end

    function map:draw()
        for i, layer in ipairs(self.layers) do
            for y = 0, layer.height - 1 do
                for x = 0, layer.width - 1 do
                    -- Index over each tile
                    local index = (x + y * layer.width) + 1
                    -- tile type
                    local tid = layer.data[index]
                    -- Get the tileset the current tile type is defined on
                    local currentTileset = 0
                    for k, tileset in ipairs(self.tilesets) do
                        if tid <= (tileset.firstgid + tileset.tilecount) then
                            currentTileset = k
                            break
                        end
                    end
                    -- Draw it all:
                    if tid ~= 0 then
                        local quad = self.quads[tid]
                        local xx = x * self.tilesets[currentTileset].tilewidth
                        local yy = y * self.tilesets[currentTileset].tileheight
                        love.graphics.draw(self.images[currentTileset], quad, xx, yy)
                    end
                end
            end
        end
    end
    return map
end
