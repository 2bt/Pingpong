G = love.graphics
small_font = G.newFont(20)
big_font = G.newFont(40)

isDown = love.keyboard.isDown

joy = love.joystick.getJoysticks()[1]


pad1_height = 70
pad2_height = 70


sounds = {}
for _, name in ipairs({"go", "pad", "bad", "wall"}) do
	sounds[name] = love.audio.newSource(name .. ".wav", "static")
end
function play_sound(name)
	sounds[name]:play()
end


function init_game()
	ball_x = 40
	ball_y = 300
	ball_vx = 4
	ball_vy = 5

	pad1_y = 300
	pad2_y = 300

	score1 = 0
	score2 = 0
	game_over = false
	winner = 0
end

init_game()
game_over = true


function love.update()

	if game_over then
		if isDown("space")
		or joy and joy:isGamepadDown("a") then
			play_sound("go")
			init_game()
		end
		return
	end

	-- update pads
	if joy then
		if joy:isGamepadDown("dpup") then pad1_y = pad1_y - 5 end
		if joy:isGamepadDown("dpdown") then pad1_y = pad1_y + 5 end
	else
		if isDown("w") then pad1_y = pad1_y - 5 end
		if isDown("s") then pad1_y = pad1_y + 5 end
	end

	if pad1_y < pad1_height / 2 then pad1_y = pad1_height / 2 end
	if pad1_y > 600 - pad1_height / 2 then pad1_y = 600 - pad1_height / 2 end

	if isDown("up") then pad2_y = pad2_y - 5 end
	if isDown("down") then pad2_y = pad2_y + 5 end
	if pad2_y < pad2_height / 2 then pad2_y = pad2_height / 2 end
	if pad2_y > 600 - pad2_height / 2 then pad2_y = 600 - pad2_height / 2 end


	-- update ball

	ball_x = ball_x + ball_vx
	ball_y = ball_y + ball_vy

	if ball_y < 10 then
		ball_y = 10
		ball_vy = -ball_vy
		play_sound("wall")
	elseif ball_y > 590 then
		ball_y = 590
		ball_vy = -ball_vy
		play_sound("wall")
	end


	if ball_x < 40 and ball_x > 20
	and ball_y > pad1_y - pad1_height / 2 - 5
	and ball_y < pad1_y + pad1_height / 2 + 5 then
		ball_vx = -ball_vx + 0.1
		ball_x = 40
		play_sound("pad")
		play_sound("wall")
	end

	if ball_x > 760 and ball_x < 780
	and ball_y > pad2_y - pad2_height / 2 - 5
	and ball_y < pad2_y + pad2_height / 2 + 5 then
		ball_vx = -ball_vx - 0.1
		ball_x = 760
		play_sound("pad")
		play_sound("wall")
	end

	if ball_x < -100 then
		play_sound("bad")
		score2 = score2 + 1
		if score2 == 5 then
			game_over = true
			winner = 2
			return
		end
		ball_vx = -ball_vx * 0.9
		ball_x = 40
		ball_y = pad1_y
	end

	if ball_x > 900 then
		play_sound("bad")
		score1 = score1 + 1
		if score1 == 5 then
			game_over = true
			winner = 1
			return
		end
		ball_vx = -ball_vx * 0.9
		ball_x = 760
		ball_y = pad2_y
	end


end


function love.draw()
	G.scale(G.getWidth() / 800,G.getHeight() / 600)


	-- draw lines
	G.setColor(0.2, 0.2, 0.2)
	G.line(400, 0, 400, 600)
	G.circle("line", 400, 300, 100)

	-- draw ball
	G.setColor(0.39, 0.39, 0.59)
	G.circle("fill", ball_x, ball_y, 10, 20)
	G.circle("line", ball_x, ball_y, 10, 20)

	-- draw pads
	G.setColor(0.78, 0.78, 0.78)
	G.rectangle("fill", 20, pad1_y - pad1_height / 2, 10, pad1_height)
	G.rectangle("fill", 770, pad2_y - pad2_height / 2, 10, pad2_height)

	-- draw score
	G.setFont(small_font)
	G.setColor(0.78, 0.78, 0.78)
	G.print(score1, 220, 20)
	G.print(score2, 568, 20)

	if game_over then
		G.setColor(1, 1, 1)
		G.setFont(big_font)

		if score1 == 0 and score2 == 0 then -- start screen
			G.printf("Pingpong", 0, 100, 800, "center")
			G.printf("Press [Space]", 0, 450, 800, "center")
		else
			G.printf("Game Over!", 0, 100, 800, "center")
			G.printf("Player " .. winner .. " wins!", 0, 450, 800, "center")
		end
	end


end
