-- set constants
WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

VIRTUAL_WIDTH = 432
VIRTUAL_HEIGHT = 243

-- import libraries
Class = require 'class'
push = require 'push'

-- import Classes
require 'Animation'
require 'Map'
require 'Player'

math.randomseed(os.time())
victoryFont = love.graphics.newFont('fonts/font.ttf', 28)
smallFont = love.graphics.newFont('fonts/font.ttf', 8)

-- screen setup
love.graphics.setDefaultFilter('nearest', 'nearest')

function love.load()  
    love.graphics.setFont(smallFont)

    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        fullscreen = false,
        resizable = true,
        vsync = true
    })

    love.window.setTitle('Super Mario 50')
    
    -- instantiate
    map = Map()

    -- table for all keys pressed during jump frame
    love.keyboard.keysPressed = {}
    love.keyboard.keysReleased = {}
end


-- called whenever window is resized
function love.resize(w, h)
    push:resize(w, h)
end


function love.keyboard.wasPressed(key)
    if (love.keyboard.keysPressed[key]) then
        return true
    else
        return false
    end
end


function love.keyboard.wasReleased(key)
    if (love.keyboard.keysReleased[key]) then
        return true
    else
        return false
    end
end


function love.keypressed(key)
    if key == 'escape' then
        love.event.quit()
    elseif key == 'return' and map.player.gameEnded then
        map.music:stop()
        love.load()
    end

    love.keyboard.keysPressed[key] = true
end


function love.update(dt)
    map:update(dt)

    love.keyboard.keysPressed = {}
    love.keyboard.keysReleased = {}
end


function love.draw()
    push:apply('start')
    love.graphics.translate(math.floor(-map.camX + 0.5), math.floor(-map.camY + 0.5))
    love.graphics.clear(108/255, 140/255, 255/255, 255/255)
    map:render()      
    push:apply('end')
end



