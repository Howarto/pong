local push = require 'libs/push'
local Game = require 'Game'

-- Window dimensions
local WINDOW_WIDTH = 1280
local WINDOW_HEIGHT = 720

-- Virtual resolution dimensions
local VIRTUAL_WIDTH = 432
local VIRTUAL_HEIGHT = 243

-- Game instance
local game

function love.load()
    -- Set up window properties
    love.graphics.setDefaultFilter('nearest', 'nearest')
    love.window.setTitle('Pong')

    -- Set up random seed
    math.randomseed(os.time())

    -- Initialize window with virtual resolution
    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        fullscreen = false,
        resizable = true,
        vsync = true
    })

    -- Create game instance
    game = Game:new(VIRTUAL_WIDTH, VIRTUAL_HEIGHT)
end

function love.update(dt)
    game:update(dt)
end

function love.keypressed(key)
    -- Quit the game
    if key == 'escape' then
        love.event.quit()
    end

    game:keypressed(key)
end

function love.resize(w, h)
    push:resize(w, h)
end

function love.draw()
    push:start()

    -- Clear screen with a dark color
    love.graphics.clear(40/255, 45/255, 52/255, 255/255)

    game:draw()

    push:finish()
end
