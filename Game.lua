local Paddle = require 'Paddle'
local Ball = require 'Ball'
local StartState = require 'states/StartState'
local ServeState = require 'states/ServeState'
local PlayState = require 'states/PlayState'
local DoneState = require 'states/DoneState'

local WINNING_SCORE = 3

local Game = {}
Game.__index = Game

function Game:new(w, h)
    local instance = setmetatable({}, Game)

    -- Window dimensions
    instance.w = w
    instance.h = h

    -- Initialize game state
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

    -- Initialize sounds
    instance.sounds = {
        ['score'] = love.audio.newSource('sounds/score.wav', 'static')
    }

    -- Initialize states
    instance.states = {
        ['start'] = StartState:new(instance),
        ['serve'] = ServeState:new(instance),
        ['play'] = PlayState:new(instance),
        ['done'] = DoneState:new(instance)
    }

    -- Set initial state
    instance.currentState = instance.states['start']

    return instance
end

function Game:update(dt)
    self.currentState:update(dt)
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
        print('left')
        self.servingPlayer = 2
    else -- scorer == 'right'
        self.scoreTwo = self.scoreTwo + 1
        print('right')
        self.servingPlayer = 1
    end

    self.sounds['score']:play()

    -- Check for winner
    if self.scoreOne >= WINNING_SCORE then
        self.winningPlayer = 1
        self:changeState('done')
    elseif self.scoreTwo >= WINNING_SCORE then
        self.winningPlayer = 2
        self:changeState('done')
    else
        self:changeState('serve')
        self.ball:reset(self.w / 2 - 2, self.h / 2 - 2)
    end
end

function Game:changeState(stateName)
    self.currentState = self.states[stateName]
end

function Game:keypressed(key)
    self.currentState:keypressed(key)
end

function Game:draw()
    self.currentState:draw()
end

return Game
