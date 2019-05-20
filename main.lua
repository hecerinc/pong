
push = require 'push'

WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

VIRTUAL_WIDTH = 432
VIRTUAL_HEIGHT = 243

PADDLE_SPEED = 200


-- Set up function
function love.load()
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

	player1Y = 30
	player2Y = VIRTUAL_HEIGHT - 50

	-- Velocity & position variables for the ball
	ballX = VIRTUAL_WIDTH / 2 - 2
	ballY = VIRTUAL_HEIGHT / 2 - 2

	ballDX = math.random(2) == 1 and 100 or -100
	ballDY = math.random(-50, 50)

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
		player1Y = math.max(0, player1Y + -PADDLE_SPEED * dt)
	elseif love.keyboard.isDown('s') then
		player1Y = math.min(VIRTUAL_HEIGHT - 20, player1Y + PADDLE_SPEED * dt)
	end
	if love.keyboard.isDown('k') then
		player2Y = math.max(0, player2Y + -PADDLE_SPEED * dt)
	elseif love.keyboard.isDown('j') then
		player2Y = math.min(VIRTUAL_HEIGHT - 20, player2Y + PADDLE_SPEED * dt)
	end
	ballX = ballX + ballDX * dt
	ballY = ballY + ballDY * dt
end

function love.draw()
	push:apply('start')

	love.graphics.clear(40/255, 45/255, 52/255, 1)
	love.graphics.printf('Hello Pong!', 0, 20, VIRTUAL_WIDTH, 'center')

	-- Left paddle
	love.graphics.rectangle('fill', 5, player1Y, 5, 20)
	-- Right paddle
	love.graphics.rectangle('fill', VIRTUAL_WIDTH - 10, player2Y, 5, 20)
	-- Ball
	love.graphics.rectangle('fill', ballX, ballY, 4, 4)

	push:apply('end')
end

