local PADDLE_SPEED = 200
local VIRTUAL_HEIGHT = 243

local Paddle = {}
Paddle.__index = Paddle

function Paddle:new(x, y)
    local instance = setmetatable({}, Paddle)
    instance.x = x
    instance.y = y
    instance.width = 5
    instance.height = 20
    instance.dy = 0
    return instance
end

function Paddle:move(dt, direction)
    self.dy = PADDLE_SPEED * direction
    
    -- Keep paddle within screen bounds
    self.y = self.y + self.dy * dt
    if self.y < 0 then
        self.y = 0
    elseif self.y > VIRTUAL_HEIGHT - self.height then
        self.y = VIRTUAL_HEIGHT - self.height
    end
end

function Paddle:update(dt)
    -- Add any additional paddle update logic here
end

function Paddle:draw()
    love.graphics.rectangle('fill', self.x, self.y, self.width, self.height)
end

return Paddle
