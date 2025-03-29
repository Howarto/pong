local BaseState = require 'states/BaseState'

local StartState = setmetatable({}, {__index = BaseState})
StartState.__index = StartState

function StartState:new(game)
    local instance = setmetatable(BaseState:new(game), StartState)
    return instance
end

function StartState:draw()
    -- Draw score
    love.graphics.setFont(self.game.scoreFont)
    love.graphics.print(tostring(self.game.scoreOne), self.game.w / 2 - 50, self.game.h / 3)
    love.graphics.print(tostring(self.game.scoreTwo), self.game.w / 2 + 30, self.game.h / 3)

    -- Draw welcome message
    love.graphics.setFont(self.game.smallFont)
    love.graphics.printf('Welcome to Pong!', 0, 10, self.game.w, 'center')
    love.graphics.printf('Press Enter to begin!', 0, 20, self.game.w, 'center')

    -- Draw game objects
    self.game.paddleOne:draw()
    self.game.paddleTwo:draw()
    self.game.ball:draw()
end

function StartState:keypressed(key)
    if key == 'enter' or key == 'return' then
        self.game:changeState('serve')
    end
end

return StartState
