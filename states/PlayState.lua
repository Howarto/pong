local BaseState = require 'states/BaseState'

local PlayState = setmetatable({}, {__index = BaseState})
PlayState.__index = PlayState

function PlayState:new(game)
    local instance = setmetatable(BaseState:new(game), PlayState)
    return instance
end

function PlayState:update(dt)
    -- Handle paddle movement
    self.game:updatePaddles(dt)

    -- Update ball and check scoring
    local scorer = self.game.ball:update(dt, self.game.paddleOne, self.game.paddleTwo)

    -- Handle scoring
    if scorer then
        self.game:handleScoring(scorer)
    end
end

function PlayState:draw()
    -- Draw score
    love.graphics.setFont(self.game.scoreFont)
    love.graphics.print(tostring(self.game.scoreOne), self.game.w / 2 - 50, self.game.h / 3)
    love.graphics.print(tostring(self.game.scoreTwo), self.game.w / 2 + 30, self.game.h / 3)

    -- Draw game objects
    self.game.paddleOne:draw()
    self.game.paddleTwo:draw()
    self.game.ball:draw()
end

return PlayState
