local BaseState = {}
BaseState.__index = BaseState

function BaseState:new(game)
    local instance = setmetatable({}, BaseState)
    instance.game = game
    return instance
end

function BaseState:update(dt)
    -- To be implemented by concrete states
end

function BaseState:draw()
    -- To be implemented by concrete states
end

function BaseState:keypressed(key)
    -- To be implemented by concrete states
end

return BaseState
