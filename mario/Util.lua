function generateQuads(atlas, tileWidth, tileHeight)
    -- get how many tiles in the sheet
    local sheetWidth = atlas:getWidth() / tileWidth
    local sheetHeight = atlas:getHeight() / tileHeight

    -- initialise variables
    local sheetCounter = 1
    local quads = {}

    -- get quads table
    for y = 0, sheetHeight - 1 do
        for x = 0, sheetWidth - 1 do
            quads[sheetCounter] = love.graphics.newQuad(x * tileWidth, y * tileHeight, tileWidth, tileHeight, atlas:getDimensions())
            sheetCounter = sheetCounter + 1
        end
    end

    return quads
end