local Ball = {}
Ball.__index = Ball

function Ball:new(x, y, gameWidth, gameHeight)
    local instance = setmetatable({}, Ball)
    instance.x = x
    instance.y = y
    instance.width = 4
    instance.height = 4
    instance.dx = 0
    instance.dy = 0

    -- Store game dimensions for boundary checking
    instance.gameWidth = gameWidth
    instance.gameHeight = gameHeight

    -- Store sounds for collision feedback
    instance.sounds = {
        ['paddle_hit'] = love.audio.newSource('sounds/paddle_hit.wav', 'static'),
        ['wall_hit'] = love.audio.newSource('sounds/wall_hit.wav', 'static')
    }

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

function Ball:update(dt, paddleOne, paddleTwo)
    -- Update position
    self.x = self.x + self.dx * dt
    self.y = self.y + self.dy * dt

    -- Handle paddle collisions
    self:checkPaddleCollisions(paddleOne, paddleTwo)

    -- Handle wall collisions
    self:checkWallCollisions()

    -- Return whether a scoring event occurred
    return self:checkScoring()
end

function Ball:checkPaddleCollisions(paddleOne, paddleTwo)
    -- Left paddle collision
    if self:collides(paddleOne) then
        self.dx = -self.dx * 1.03  -- Increase speed by 3%
        self.x = paddleOne.x + paddleOne.width  -- Prevent sticking inside paddle

        -- Randomize vertical velocity while keeping direction
        if self.dy < 0 then
            self.dy = -math.random(10, 150)
        else
            self.dy = math.random(10, 150)
        end

        self.sounds['paddle_hit']:play()
    end

    -- Right paddle collision
    if self:collides(paddleTwo) then
        self.dx = -self.dx * 1.03  -- Increase speed by 3%
        self.x = paddleTwo.x - self.width  -- Prevent sticking inside paddle

        -- Randomize vertical velocity while keeping direction
        if self.dy < 0 then
            self.dy = -math.random(10, 150)
        else
            self.dy = math.random(10, 150)
        end

        self.sounds['paddle_hit']:play()
    end
end

function Ball:checkWallCollisions()
    -- Top wall collision
    if self.y <= 0 then
        self.y = 0
        self.dy = -self.dy
        self.sounds['wall_hit']:play()
    -- Bottom wall collision
    elseif self.y >= self.gameHeight - self.height then
        self.y = self.gameHeight - self.height
        self.dy = -self.dy
        self.sounds['wall_hit']:play()
    end
end

function Ball:checkScoring()
    -- Check if ball went past left or right boundary
    if self.x < 0 then
        return 'right'  -- Right player scores
    elseif self.x > self.gameWidth then
        return 'left'   -- Left player scores
    end

    return nil  -- No scoring event
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
