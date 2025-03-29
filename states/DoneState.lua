local BaseState = require 'states/BaseState'

local DoneState = setmetatable({}, {__index = BaseState})
DoneState.__index = DoneState

function DoneState:new(game)
    local instance = setmetatable(BaseState:new(game), DoneState)
    return instance
end

function DoneState:draw()
    -- Draw score
    love.graphics.setFont(self.game.scoreFont)
    love.graphics.print(tostring(self.game.scoreOne), self.game.w / 2 - 50, self.game.h / 3)
    love.graphics.print(tostring(self.game.scoreTwo), self.game.w / 2 + 30, self.game.h / 3)

    -- Draw game over message
    love.graphics.setFont(self.game.smallFont)
    love.graphics.printf('Player ' .. tostring(self.game.winningPlayer) .. ' wins!', 0, 10, self.game.w, 'center')
    love.graphics.printf('Press Enter to restart!', 0, 20, self.game.w, 'center')

    -- Draw game objects
    self.game.paddleOne:draw()
    self.game.paddleTwo:draw()
    self.game.ball:draw()
end

function DoneState:keypressed(key)
    if key == 'enter' or key == 'return' then
        -- Reset the game
        self.game.scoreOne = 0
        self.game.scoreTwo = 0
        self.game.servingPlayer = 1
        self.game.winningPlayer = 0
        self.game.ball:reset(self.game.w / 2 - 2, self.game.h / 2 - 2)
        self.game:changeState('start')
    end
end

return DoneState
