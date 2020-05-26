Player = Class{}

-- set constants
local WALKING_SPEED = 140
local JUMP_VELOCITY = 400


function Player:init(map)
    self.x = 0
    self.y = 0
    self.width = 16
    self.height = 20
    -- offset from top left to center to support sprite flipping
    self.xOffset = 8
    self.yOffset = 10

    self.dx = 0
    self.dy = 0

    self.map = map
    self.texture = love.graphics.newImage('graphics/blue_alien.png')
    self.frames = {}
    self.currentFrame = nil
    self.victory = false
    self.gameEnded = false

    -- position on top of map tiles
    self.y = map.tileHeight * ((map.mapHeight - 2) / 2) - self.height

    local tileStart = 10
    self.x = map.tileWidth * tileStart

    -- defaults
    self.state = 'start'
    self.direction = 'left'

    -- set table for sound efx
    self.sounds = {
        ['jump'] = love.audio.newSource('sounds/jump.wav', 'static'),
        ['hit'] = love.audio.newSource('sounds/hit.wav', 'static'),
        ['coin'] = love.audio.newSource('sounds/coin.wav', 'static'),
        ['death'] = love.audio.newSource('sounds/death.wav', 'static'),
        ['victory'] = love.audio.newSource('sounds/powerup-reveal.wav', 'static')
    }
    

    self.animations = {
        ['idle'] = Animation ({
            texture = self.texture,
            frames = {
                love.graphics.newQuad(0, 0, 16, 20, self.texture:getDimensions())
            }
        }),
        ['walking'] = Animation({
            texture = self.texture,
            frames = {
                love.graphics.newQuad(128, 0, 16, 20, self.texture:getDimensions()),
                love.graphics.newQuad(144, 0, 16, 20, self.texture:getDimensions()),
                love.graphics.newQuad(160, 0, 16, 20, self.texture:getDimensions()),
                love.graphics.newQuad(144, 0, 16, 20, self.texture:getDimensions())
            },
            interval = 0.15
        }),
        ['jumping'] = Animation ({
            texture = self.texture,
            frames = {
                love.graphics.newQuad(32, 0, 16, 20, self.texture:getDimensions())
            }
        })
    }

    -- initialize animation and current frame we should render
    self.animation = self.animations['idle']
    self.currentFrame = self.animation:getCurrentFrame()

    -- behavior map we can call based on player state
    self.behaviours = {
        ['start'] = function(dt)
            while tileStart >= 0 do
                self.x = map.tileWidth * tileStart
                -- check if there is no tile below
                if self:changeStartPosition() then
                    tileStart = tileStart - 1
                else            
                    break
                end
            end
            self.state = 'idle'
            self.animation = self.animations[self.state]
        end,
        ['idle'] = function(dt)
            if love.keyboard.wasPressed('space') or self.victory then
                self.gameEnded = false
                self.dy = -JUMP_VELOCITY
                self.state = 'jumping'
                self.animation = self.animations[self.state]
                if not self.victory then               
                    self.gameEnded = false
                    self.sounds['jump']:play()
                end
            elseif love.keyboard.isDown('left') then
                -- left
                self.dx = -WALKING_SPEED
                self.direction = 'left'
                self.state = 'walking'
                self.animations[self.state]:restart()
                self.animation = self.animations[self.state]                       
            elseif love.keyboard.isDown('right') then
                -- right
                self.dx = WALKING_SPEED
                self.direction = 'right'
                self.state = 'walking'
                self.animations[self.state]:restart()
                self.animation = self.animations[self.state] 
            else
                self.dx = 0                      
            end
        end,
        ['walking'] = function(dt)
            if love.keyboard.wasPressed('space') then
                self.dy = -JUMP_VELOCITY
                self.state = 'jumping'
                self.animation = self.animations[self.state]
                self.sounds['jump']:play()
            elseif love.keyboard.isDown('left') then
                -- left
                self.dx = -WALKING_SPEED  
                self.direction = 'left' 
            elseif love.keyboard.isDown('right') then
                -- right
                self.dx  = WALKING_SPEED
                self.direction = 'right'                
            else
                self.dx = 0
                self.state = 'idle'
                self.animation = self.animations[self.state]           
            end

            -- check for colisions on left and right
            self:checkRightCollision()
            self:checkLeftCollision()

            -- check if there is tile below
            if not self.map:collides(self.map:tileAt(self.x, self.y + self.height)) and 
                not self.map:collides(self.map:tileAt(self.x + self.width - 1, 
                self.y + self.height)) then

                -- drop when there's not tile, using gravity
                self.state = 'jumping'
                self.animation = self.animations[self.state]

                if self.y > self.map.mapHeightPixels / 2 then
                    self.sounds['death']:play()  
                end
            end
        end,
        ['jumping'] = function(dt)
            if self.y > 300 then
                return
            end

            if love.keyboard.isDown('left') then
                -- left
                self.direction = 'left'
                self.dx = -WALKING_SPEED
            elseif love.keyboard.isDown('right') then
                -- right
                self.direction = 'right'
                self.dx = WALKING_SPEED
            end

            self.dy = self.dy + self.map.gravity

            -- check if there is tile below
            if self.map:collides(self.map:tileAt(self.x, self.y + self.height)) or 
                self.map:collides(self.map:tileAt(self.x + self.width - 1, 
                self.y + self.height)) then

                -- when there is collision
                self.dy = 0
                self.state = 'idle'
                self.animation = self.animations[self.state]
                -- reset y position
                self.y = (self.map:tileAt(self.x, self.y + self.height).y - 1) * 
                            self.map.tileHeight - self.height
            end

            if self.y > self.map.mapHeightPixels / 2 then
                self.sounds['death']:play()
                self.gameEnded = true
            end

            -- check for colisions on left and right
            self:checkRightCollision()
            self:checkLeftCollision()
        end
    }
end


function Player:update(dt)
    self.behaviours[self.state](dt)
    self.animation:update(dt)
    self.currentFrame = self.animation:getCurrentFrame()
    self.x = self.x + self.dx * dt
    self:calculateJumps(dt)
    self.y = self.y + self.dy * dt
    self:checkVictory(dt)
end

-- jumping and block hitting logic
function Player:calculateJumps(dt)
    
    -- if we have negative y velocity (jumping), check if we collide
    -- with any blocks above us
    if self.dy < 0 then
        -- check if there is collidables above
        if self.map:collides(self.map:tileAt(self.x, self.y)) or 
        self.map:collides(self.map:tileAt(self.x + self.width - 1, self.y)) then            
            
            -- set velocity back
            self.dy = 0

            -- change block to different block
            local playCoin = false
            local playHit = false

            if self.map:tileAt(self.x, self.y).id == JUMP_BLOCK then
                self.map:setTile(math.floor(self.x / self.map.tileWidth) + 1,
                    math.floor(self.y / self.map.tileHeight) + 1, JUMP_BLOCK_HIT)
                playCoin = true
            else
                playHit = true
            end

            if self.map:tileAt(self.x + self.width - 1, self.y).id == JUMP_BLOCK then
                
                self.map:setTile(math.floor((self.x + self.width - 1) / 
                self.map.tileWidth) + 1, math.floor(self.y / self.map.tileHeight) + 1, 
                JUMP_BLOCK_HIT)

                playCoin = true
            else
                playHit = true
            end

            if playCoin then
                self.sounds['coin']:play()
            elseif playHit and not self.victory then
                self.sounds['hit']:play()
            end
        end
    end
end


function Player:changeStartPosition()
    -- check for tiles below and objects
    if (self.map:collides(self.map:tileAt(self.x, self.y + self.height)) or 
        self.map:collides(self.map:tileAt(self.x + self.width - 1, self.y + self.height))) and 
        not (self.map:collides(self.map:tileAt(self.x, self.y - 1 + self.height)) or 
        self.map:collides(self.map:tileAt(self.x + self.width - 1, self.y - 1 + self.height)))
        then
        return false
    end
    return true
end


function Player:checkLeftCollision()
    if self.dx < 0 then
        -- check if there's tile to the left or edge of screen
        if self.map:collides(self.map:tileAt(self.x - 1, self.y)) or
                self.map:collides(self.map:tileAt(self.x - 1, self.y + self.height - 1)) or
                self.x < 0 then

            self.dx = 0
            self.x = self.map:tileAt(self.x - 1, self.y).x * self.map.tileWidth
        end
    end
end


function Player:checkRightCollision()
    if self.dx > 0 then
        -- check if there's tile to the right or edge of screen
        if self.map:collides(self.map:tileAt(self.x + self.width, self.y)) or
            self.map:collides(self.map:tileAt(self.x + self.width, self.y + self.height - 1))  or self.x + self.width > self.map.mapWidthPixels then
            if (self.map:tileAt(self.x + self.width, self.y).x - 1) * self.map.tileWidth < 
                self.map.doorway['x'] or (self.map:tileAt(self.x + self.width, self.y).x - 1) 
                * self.map.tileWidth > self.map.doorway['x'] + self.map.tileWidth then

                self.dx = 0
                self.x = (self.map:tileAt(self.x + self.width, self.y).x - 1) * 
                        self.map.tileWidth - self.width
            end
        end
    end 
end


function Player:checkVictory(dt)
    local doorX = self.map.doorway.x + self.map.tileWidth

    if self.x == doorX then
        self.victory = true
        self.gameEnded = true
        self.sounds['victory']:play()
    end
end


function Player:render()
    local scaleX

    -- determines whether sprite image flips or not
    if self.direction == 'right' then
        scaleX = 1
    else
        scaleX = -1
    end

    love.graphics.draw(self.texture, self.currentFrame, math.floor(self.x + self.xOffset),
        math.floor(self.y + self.yOffset), 0, scaleX, 1, self.xOffset, self.yOffset)

    if self.gameEnded then
        love.graphics.setFont(smallFont)
        love.graphics.setColor(0, 0, 0, 1)
        love.graphics.printf("Hit 'Enter' to restart and 'Esc' to exit", self.map.camX,
            self.map.camY + VIRTUAL_HEIGHT / 6 + 32, VIRTUAL_WIDTH, 'center')

        if self.victory then
            love.graphics.setFont(victoryFont)
            love.graphics.setColor(1, 0, 0, 1)
            love.graphics.printf("VICTORY!!!", self.map.camX,
                self.map.camY + VIRTUAL_HEIGHT / 6, VIRTUAL_WIDTH, 'center')
        end
    end
end