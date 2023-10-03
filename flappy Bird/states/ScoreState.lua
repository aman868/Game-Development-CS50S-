--[[
    ScoreState Class
    Author: Colton Ogden
    cogden@cs50.harvard.edu

    A simple state used to display the player's score before they
    transition back into the play state. Transitioned to from the
    PlayState when they collide with a Pipe.
]]

ScoreState = Class{__includes = BaseState}

--[[
    When we enter the score state, we expect to receive the score
    from the play state so we know what to render to the State.
]]
function ScoreState:enter(params)
    self.score = params.score
end

function ScoreState:update(dt)
    -- go back to play if enter is pressed
    if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
        gStateMachine:change('countdown')
    end
end

function ScoreState:render()
    -- simply render the score to the middle of the screen
    love.graphics.setFont(flappyFont)
    love.graphics.printf('Oof! You lost!', 0, 20, VIRTUAL_WIDTH, 'center')

    love.graphics.setFont(mediumFont)
    love.graphics.printf('Score: ' .. tostring(self.score), 0, 130, VIRTUAL_WIDTH, 'center')
	
	--Setting up medals
	
	bronze=love.graphics.newImage('bronze.jpg')
	silver=love.graphics.newImage('silver.jpg')
	gold=love.graphics.newImage('gold.jpg')
	if self.score >=7 and self.score<15 then
		love.graphics.draw(bronze, VIRTUAL_WIDTH/2-25,60,0,0.25,0.25)
	elseif self.score >=15 and self.score<30 then
		love.graphics.draw(silver, VIRTUAL_WIDTH/2-40,60,0,0.25,0.25)
	elseif self.score>=30 then
		love.graphics.draw(gold, VIRTUAL_WIDTH/2-25,60,0,0.25,0.25)
	end
		

    love.graphics.printf('Press Enter to Play Again!', 0, 160, VIRTUAL_WIDTH, 'center')
end