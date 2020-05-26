-- import classes
require 'Util'

Map = Class{}

-- set constants
TILE_BRICK = 1
TILE_EMPTY = -1

CLOUD_LEFT = 6
CLOUD_RIGHT = 7

BUSH_LEFT = 2
BUSH_RIGHT = 3

MUSHROOM_TOP = 10
MUSHROOM_BOTTOM = 11

JUMP_BLOCK = 5
JUMP_BLOCK_HIT = 9

POLE_TOP = 8
POLE_MIDDLE = 12
POLE_BOTTOM = 16

local SCROLL_SPEED = 62
local PYRAMID_HEIGHT = 4
local POLE_HEIGHT = PYRAMID_HEIGHT + 3
local DOOR_HEIGHT = 5


function Map:init()
    -- initialise variables
    self.spriteSheet = love.graphics.newImage('graphics/spritesheet.png')
    self.music = love.audio.newSource('sounds/music.wav', 'static')
        -- pixel sized
    self.tileWidth = 16
    self.tileHeight = 16
    self.sprites = generateQuads(self.spriteSheet, self.tileWidth, self.tileHeight)
        -- tile sized
    self.mapWidth = 70
    self.mapHeight = 28
    self.mapWidthPixels = self.mapWidth * self.tileWidth
    self.mapHeightPixels = self.mapHeight * self.tileHeight
    self.tiles = {}
    self.doorway = {}

    self.gravity = 15
    self.player = Player(self)

    self.camX = 0
    self.camY = -3    

    self.currentFrame = nil

    self.animation = Animation({
        texture = self.spriteSheet,
        frames = {
            love.graphics.newQuad(0 * self.tileWidth, 3 * self.tileHeight - 1, 16, 20, 
                self.spriteSheet:getDimensions()),
            love.graphics.newQuad(1 * self.tileWidth, 3 * self.tileHeight, 16, 20, self.spriteSheet:getDimensions()),
            love.graphics.newQuad(2 * self.tileWidth, 3 * self.tileHeight, 16, 20, self.spriteSheet:getDimensions())
        },
        interval = 0.1
    })
    self.currentFrame = self.animation:getCurrentFrame()

    -- fill map with empty tiles
    for y = 1, self.mapHeight do
        for x = 1, self.mapWidth do
           self:setTile(x, y , TILE_EMPTY)  
        end
    end

    -- start: generate terrain vertically
    local x = 1
    local brickY = 1

    while x <= self.mapWidth do
        -- 2 tiles away from edge
        if x < self.mapWidth - 2 then
            -- generate cloud: 5%
            if math.random(20) == 1 then
                -- random spot above blocks/pipes
                local cloudStart = math.random(self.mapHeight / 2 - 6)
                self:setTile(x, cloudStart, CLOUD_LEFT)
                self:setTile(x + 1, cloudStart, CLOUD_RIGHT)
            end
        end

        -- big boss zone
        if x > self.mapWidth - 30 then            
            if brickY <= PYRAMID_HEIGHT then
                -- set pyramid
                for numBricks = 1, brickY  do
                    if brickY == PYRAMID_HEIGHT then                    
                        self:setTile(x, self.mapHeight / 2 - numBricks, TILE_BRICK)
                        self:setTile(x + 1, self.mapHeight / 2 - numBricks, TILE_BRICK)
                    else
                        self:setTile(x, self.mapHeight / 2 - numBricks, TILE_BRICK)
                    end
                end
                -- increment for next layer of bricks
                brickY = brickY + 1
            end

            -- set flag pole
            if x == self.mapWidth - 17 then
                self:setFlagPole(x)
            end

            -- set doorway
            if x == self.mapWidth - 5 then
                self:setDoorway(x)
            end

            -- column of tiles going to base of map
            for y = self.mapHeight / 2, self.mapHeight do
                self:setTile(x, y, TILE_BRICK)
            end

            -- move to next vertical column
            x = x + 1            

        -- generate mushroom: 5%
        elseif math.random(20) == 1 then
            -- left side of pipe
            self:setTile(x, self.mapHeight / 2 - 2, MUSHROOM_TOP)
            self:setTile(x, self.mapHeight / 2 - 1, MUSHROOM_BOTTOM)
            -- column of tiles going to base of map
            for y = self.mapHeight / 2, self.mapHeight do
                self:setTile(x, y, TILE_BRICK)
            end
            -- move to next vertical column
            x = x + 1
            
        -- generate bush: 2% and away from edge
        elseif math.random(10) == 1 and x < self.mapWidth - 3 then
            local bushLevel = self.mapHeight / 2 - 1
            self:setTile(x, bushLevel, BUSH_LEFT)
            -- column of tiles going to base of map
            for y = self.mapHeight / 2, self.mapHeight do
                self:setTile(x, y, TILE_BRICK)
            end
            x = x + 1
            self:setTile(x, bushLevel, BUSH_RIGHT)
            -- column of tiles going to base of map
            for y = self.mapHeight / 2, self.mapHeight do
                self:setTile(x, y, TILE_BRICK)
            end
            x = x + 1
        -- generate nothing: 10%
        elseif math.random(10) ~= 1 then
            -- column of tiles going to base of map
            for y = self.mapHeight / 2, self.mapHeight do
                self:setTile(x, y, TILE_BRICK)
            end

            -- generate block for mario to jump hit
            if math.random(15) == 1 then
                self:setTile(x, self.mapHeight / 2 - 4, JUMP_BLOCK)
            end

            x = x + 1
        else
            x = x + 2
        end
    end

    -- start bgm
    self.music:setLooping(true)
    self.music:setVolume(0.25)
    self.music:play()
end


function Map:collides(tile)
    local collidables = {
        TILE_BRICK, 
        JUMP_BLOCK, JUMP_BLOCK_HIT, 
        MUSHROOM_TOP, MUSHROOM_BOTTOM,
        POLE_TOP, POLE_MIDDLE, POLE_BOTTOM
    }

    -- iterate through key, value pairs
    for _, v in ipairs(collidables) do
        if tile.id == v then
            return true
        end
    end

    return false
end


function Map:update(dt)
    self.player:update(dt)
    self.animation:update(dt)
    self.currentFrame = self.animation:getCurrentFrame()
    -- camera tracking clamps down to the edges of the map
    self.camX = math.max(0, math.min(self.player.x - VIRTUAL_WIDTH / 2, 
                math.min(self.mapWidthPixels - VIRTUAL_WIDTH, self.player.x)))

    self.camY = math.max(0, math.min(self.player.y - VIRTUAL_HEIGHT / 2, 
                math.min(self.mapHeightPixels / 2 - VIRTUAL_HEIGHT, self.player.y)))
end


function Map:tileAt(x, y)
    return {
        x = math.floor(x / self.tileWidth) + 1,
        y = math.floor(y / self.tileHeight) + 1,
        id = self:getTile(math.floor(x / self.tileWidth) + 1, 
                                        math.floor(y / self.tileHeight) + 1)
    }
end


function Map:setTile(x, y, tile)
    self.tiles[(y - 1) * self.mapWidth + x] = tile
end


function Map:getTile(x, y)
    return self.tiles[(y - 1) * self.mapWidth + x]
end

function Map:setFlagPole(x)
    local flagTile = nil

    -- set flag pole
    for flagY = 1, POLE_HEIGHT do
        if flagY == 1 then
            flagTile = POLE_BOTTOM
        elseif flagY == POLE_HEIGHT then
            flagTile = POLE_TOP
            
        else
            flagTile = POLE_MIDDLE
        end

        self:setTile(x, self.mapHeight / 2 - flagY, flagTile)
    end
end


function Map:setDoorway(x)
    -- set doorway
    local doorY = self.mapHeight / 2 - 1

    for i = 1, DOOR_HEIGHT do
        if i == DOOR_HEIGHT then
            for j = 1, 3 do
                self:setTile(x, doorY, TILE_BRICK)
                x = x + 1
            end
        elseif i == DOOR_HEIGHT - 1 then
            self:setTile(x, doorY, MUSHROOM_TOP)
            self:setTile(x + 2, doorY, MUSHROOM_TOP)
        elseif i == 1 then
            self:setTile(x, doorY, MUSHROOM_BOTTOM)
            self.doorway = {
                x = (x - 1) * self.tileWidth,
                y = (doorY - 1) * self.tileWidth
            }
            self:setTile(x + 2, doorY, MUSHROOM_BOTTOM)    
        else
            self:setTile(x, doorY, MUSHROOM_BOTTOM)
            self:setTile(x + 2, doorY, MUSHROOM_BOTTOM)
        end

        doorY = doorY - 1
    end    
end


function Map:render()
    for y = 1, self.mapHeight do
        for x = 1, self.mapWidth do
            local tile = self:getTile(x, y)
            if tile ~= TILE_EMPTY then
                love.graphics.draw(self.spriteSheet, self.sprites[tile], 
                    (x - 1) * self.tileWidth, (y - 1) * self.tileHeight)
                if tile == POLE_TOP then
                    love.graphics.draw(self.spriteSheet, self.currentFrame, 
                        (x - 1) * self.tileWidth, (y - 1) * self.tileHeight, 
                        0, -1, 1, 8, -4)
                end
            end
        end
    end

    self.player:render() 
end