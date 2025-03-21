local Paddle = require 'Paddle'
local Ball = require 'Ball'

local WINNING_SCORE = 3

local Game = {}
Game.__index = Game

function Game:new(w, h)
    local instance = setmetatable({}, Game)

    -- Window dimensions
    instance.w = w
    instance.h = h

    -- Initialize game state
    instance.state = 'start'
    instance.servingPlayer = 1
    instance.winningPlayer = 0

    -- Initialize paddles
    instance.paddleOne = Paddle:new(10, h / 2 - 10)
    instance.paddleTwo = Paddle:new(w - 15, h / 2 - 10)

    -- Initialize ball with game dimensions
    instance.ball = Ball:new(w / 2 - 2, h / 2 - 2, w, h)

    -- Initialize scores
    instance.scoreOne = 0
    instance.scoreTwo = 0

    -- Initialize fonts
    instance.smallFont = love.graphics.newFont('font.ttf', 8)
    instance.largeFont = love.graphics.newFont('font.ttf', 16)
    instance.scoreFont = love.graphics.newFont('font.ttf', 32)

    -- Initialize sounds (only scoring sound needed here)
    instance.sounds = {
        ['score'] = love.audio.newSource('sounds/score.wav', 'static')
    }

    return instance
end

function Game:update(dt)
    -- Handle paddle movement (always active regardless of state)
    self:updatePaddles(dt)

    if self.state == 'serve' then
        -- Ball will move based on the serving player
        self.ball:serve(self.servingPlayer == 1 and 1 or -1)
    elseif self.state == 'play' then
        -- Update ball and check scoring
        local scorer = self.ball:update(dt, self.paddleOne, self.paddleTwo)

        -- Handle scoring
        if scorer then
            self:handleScoring(scorer)
        end
    end
end

function Game:updatePaddles(dt)
    -- Player 1 (left)
    if love.keyboard.isDown('w') then
        self.paddleOne:move(dt, -1)
    elseif love.keyboard.isDown('s') then
        self.paddleOne:move(dt, 1)
    end

    -- Player 2 (right)
    if love.keyboard.isDown('up') then
        self.paddleTwo:move(dt, -1)
    elseif love.keyboard.isDown('down') then
        self.paddleTwo:move(dt, 1)
    end
end

function Game:handleScoring(scorer)
    if scorer == 'left' then
        self.scoreOne = self.scoreOne + 1
        self.servingPlayer = 2
    else -- scorer == 'right'
        self.scoreTwo = self.scoreTwo + 1
        self.servingPlayer = 1
    end

    self.sounds['score']:play()

    -- Check for winner
    if self.scoreOne >= WINNING_SCORE then
        self.winningPlayer = 1
        self.state = 'done'
    elseif self.scoreTwo >= WINNING_SCORE then
        self.winningPlayer = 2
        self.state = 'done'
    else
        self.state = 'serve'
        self.ball:reset(self.w / 2 - 2, self.h / 2 - 2)
    end
end

function Game:keypressed(key)
    if key == 'enter' or key == 'return' then
        if self.state == 'start' then
            self.state = 'play'
            self.ball:serve(self.servingPlayer == 1 and 1 or -1)
        elseif self.state == 'serve' then
            self.state = 'play'
        elseif self.state == 'done' then
            -- Reset the game
            self.state = 'start'
            self.scoreOne = 0
            self.scoreTwo = 0
            self.servingPlayer = 1
            self.winningPlayer = 0
            self.ball:reset(self.w / 2 - 2, self.h / 2 - 2)
        end
    end
end

function Game:draw()
    -- Draw score
    love.graphics.setFont(self.scoreFont)
    love.graphics.print(tostring(self.scoreOne), self.w / 2 - 50, self.h / 3)
    love.graphics.print(tostring(self.scoreTwo), self.w / 2 + 30, self.h / 3)

    -- Draw game state messages
    love.graphics.setFont(self.smallFont)
    if self.state == 'start' then
        love.graphics.printf('Welcome to Pong!', 0, 10, self.w, 'center')
        love.graphics.printf('Press Enter to begin!', 0, 20, self.w, 'center')
    elseif self.state == 'serve' then
        love.graphics.printf('Player ' .. tostring(self.servingPlayer) .. "'s serve!", 0, 10, self.w, 'center')
        love.graphics.printf('Press Enter to serve!', 0, 20, self.w, 'center')
    elseif self.state == 'done' then
        love.graphics.printf('Player ' .. tostring(self.winningPlayer) .. ' wins!', 0, 10, self.w, 'center')
        love.graphics.printf('Press Enter to restart!', 0, 20, self.w, 'center')
    end

    -- Draw game objects
    self.paddleOne:draw()
    self.paddleTwo:draw()
    self.ball:draw()
end

return Game
