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
	if ball:collides(player1) then
		-- if ball collides with player1, reverse de direction in x 
		-- and slightly increase the speed
		ball.dx = -ball.dx * 1.2
		ball.x = player1.x + 5 -- we have to shift the position because it will only move so far in the next frame and it will perpetually detect collision
		-- 5 is the width of the paddle, so we ensure that they're no longer colliding

		-- keep velocity in the same direction, but randomise it
		if ball.dy < 0 then
			ball.dy = -math.random(10, 150)
		else
			ball.dy = math.random(10, 150)
		end
	end

	if ball:collides(player2) then
		-- if ball collides with player1, reverse de direction in x 
		-- and slightly increase the speed
		ball.dx = -ball.dx * 1.2
		ball.x = player2.x - 4 -- -4 is the width of the ball

		-- keep velocity in the same direction, but randomise it
		if ball.dy < 0 then
			ball.dy = -math.random(10, 150)
		else
			ball.dy = math.random(10, 150)
		end
	end

	-- Prevent if from going past the bottom or top edges
	if ball.y <= 0 then
		ball.y = 0
		ball.dy = -ball.dy
	end

	-- -4 to account for the ball's size
	if ball.y >= VIRTUAL_HEIGHT -4 then 
		ball.y = VIRTUAL_HEIGHT - 4
		ball.dy = - ball.dy
	end


	if ball.x >= VIRTUAL_WIDTH or ball.x <= 0 then
		ball:reset()
	end




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
