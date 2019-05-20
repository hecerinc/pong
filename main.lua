-- main.lua
--                    
-- The main file for my Pong game!

Class = require 'class'
push = require 'push'

WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

VIRTUAL_WIDTH = 432
VIRTUAL_HEIGHT = 243

PADDLE_SPEED = 200

require 'Paddle'
require 'Ball'

-- Set up function
function love.load()
	love.window.setTitle('Pong pong')
	love.graphics.setDefaultFilter('nearest', 'nearest')

	-- Set up random seed
	math.randomseed(os.time())

	smallFont = love.graphics.newFont('font.ttf', 8)
	love.graphics.setFont(smallFont)

	push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
		fullscreen = false,
		resizable = false,
		vsync = true
	})

	player1 = Paddle(5, 30, 5, 20)
	player2 = Paddle(VIRTUAL_WIDTH - 10, VIRTUAL_HEIGHT - 30, 5, 20)

	-- Velocity & position variables for the ball
	ball = Ball(VIRTUAL_WIDTH / 2 - 2, VIRTUAL_HEIGHT / 2 - 2, 4, 4)


end

function love.keypressed(key)
	if key == 'escape' then
		love.event.quit()
	end
end

-- Update function
-- Takes dt: delta time
function love.update(dt)
	if love.keyboard.isDown('w') then
		player1.dy = -PADDLE_SPEED
	elseif love.keyboard.isDown('s') then
		player1.dy = PADDLE_SPEED
	else
		player1.dy = 0
	end

	if love.keyboard.isDown('k') then
		player2.dy = -PADDLE_SPEED
	elseif love.keyboard.isDown('j') then
		player2.dy = PADDLE_SPEED
	else
		player2.dy = 0
	end

	ball:update(dt)
	player1:update(dt)
	player2:update(dt)
end

function love.draw()
	push:apply('start')

	love.graphics.clear(40/255, 45/255, 52/255, 1)
	love.graphics.printf('Hello Pong!', 0, 20, VIRTUAL_WIDTH, 'center')

	player1:render()
	player2:render()
	ball:render()

	displayFPS()

	push:apply('end')
end

function displayFPS()
	love.graphics.setFont(smallFont)
	love.graphics.setColor(0, 1, 0, 1)
	love.graphics.print('FPS: ' .. tostring(love.timer.getFPS()), 10, 10)
end
