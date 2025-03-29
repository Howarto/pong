local BaseState = require 'states/BaseState'

local ServeState = setmetatable({}, {__index = BaseState})
ServeState.__index = ServeState

function ServeState:new(game)
    local instance = setmetatable(BaseState:new(game), ServeState)
    return instance
end

function ServeState:update(dt)
    -- Handle paddle movement
    self.game:updatePaddles(dt)
    -- Set the ball direction
    self.game.ball:serve(self.game.servingPlayer == 1 and 1 or -1)
end

function ServeState:draw()
    -- Draw score
    love.graphics.setFont(self.game.scoreFont)
    love.graphics.print(tostring(self.game.scoreOne), self.game.w / 2 - 50, self.game.h / 3)
    love.graphics.print(tostring(self.game.scoreTwo), self.game.w / 2 + 30, self.game.h / 3)

    -- Draw serve message
    love.graphics.setFont(self.game.smallFont)
    love.graphics.printf('Player ' .. tostring(self.game.servingPlayer) .. "'s serve!", 0, 10, self.game.w, 'center')
    love.graphics.printf('Press Enter to serve!', 0, 20, self.game.w, 'center')

    -- Draw game objects
    self.game.paddleOne:draw()
    self.game.paddleTwo:draw()
    self.game.ball:draw()
end

function ServeState:keypressed(key)
    if key == 'enter' or key == 'return' then
        self.game:changeState('play')
    end
end

return ServeState
