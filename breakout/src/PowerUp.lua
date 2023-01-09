PowerUp = Class{}

function PowerUp:init(brick)
    self.x = brick.x + brick.width/2
    self.y = brick.y + brick.height/2
    self.width = 16
    self.height = 16
    self.dy = 50
    --Used to determine if its a key powerUp or a normal one
    self.key = false
end 


function PowerUp:collides(target)

    if self.x > target.x + target.width or target.x > self.x + self.width then
        return false
    end

    -- then check to see if the bottom edge of either is higher than the top
    -- edge of the other
    if self.y > target.y + target.height or target.y > self.y + self.height then
        return false
    end 

    -- if the above aren't true, they're overlapping
    return true
end

function PowerUp:update(dt)
    self.y = self.y + self.dy * dt
end

function PowerUp:render()
    love.graphics.draw(gTextures['main'], 
            -- multiply color by 4 (-1) to get our color offset, then add tier to that
            -- to draw the correct tier and color brick onto the screen
            gFrames['powerUps'][self.key==true and 10 or 7],
            self.x, self.y)
end