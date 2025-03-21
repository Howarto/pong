local Ball = {}
Ball.__index = Ball

function Ball:new(x, y)
    local instance = setmetatable({}, Ball)
    instance.x = x
    instance.y = y
    instance.width = 4
    instance.height = 4
    instance.dx = 0
    instance.dy = 0
    return instance
end

function Ball:reset(x, y)
    self.x = x
    self.y = y
    self.dx = 0
    self.dy = 0
end

function Ball:serve(dx)
    self.dy = math.random(-50, 50)
    self.dx = dx * math.random(140, 200)
end

function Ball:update(dt)
    self.x = self.x + self.dx * dt
    self.y = self.y + self.dy * dt
end

function Ball:collides(paddle)
    if self.x > paddle.x + paddle.width or paddle.x > self.x + self.width then
        return false
    end
    if self.y > paddle.y + paddle.height or paddle.y > self.y + self.height then
        return false
    end
    return true
end

function Ball:draw()
    love.graphics.rectangle('fill', self.x, self.y, self.width, self.height)
end

return Ball
