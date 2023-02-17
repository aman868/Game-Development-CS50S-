--[[
    GD50
    Super Mario Bros. Remake

    -- Player Class --

    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]

Player = Class{__includes = Entity}

function Player:init(def)
    --Checks the map to see if there is a solid block undernead the player when they spawn
    for x = 1, def.map.width do
        if def.map.tiles[7][x].id == TILE_ID_GROUND then
            break
        else
            def.x = def.x + 16
        end
    end
    Entity.init(self, def)    
    self.score = def.score
    self.stage = def.stage
    self.key = false
end

function Player:update(dt)
    Entity.update(self, dt)
end

function Player:render()
    Entity.render(self)
end


function Player:checkLeftCollisions(dt)
    -- check for left two tiles collision
    local tileTopLeft = self.map:pointToTile(self.x + 1, self.y + 1)
    local tileBottomLeft = self.map:pointToTile(self.x + 1, self.y + self.height - 1)

    -- place player outside the X bounds on one of the tiles to reset any overlap
    if (tileTopLeft and tileBottomLeft) and (tileTopLeft:collidable() or tileBottomLeft:collidable()) then
        self.x = (tileTopLeft.x - 1) * TILE_SIZE + tileTopLeft.width - 1
    else
        
        self.y = self.y - 1
        local collidedObjects = self:checkObjectCollisions()
        self.y = self.y + 1

        -- reset X if new collided object
        if #collidedObjects > 0 then
            self.x = self.x + PLAYER_WALK_SPEED * dt
        end
    end
end

function Player:checkRightCollisions(dt)
    -- check for right two tiles collision
    local tileTopRight = self.map:pointToTile(self.x + self.width - 1, self.y + 1)
    local tileBottomRight = self.map:pointToTile(self.x + self.width - 1, self.y + self.height - 1)

    -- place player outside the X bounds on one of the tiles to reset any overlap
    if (tileTopRight and tileBottomRight) and (tileTopRight:collidable() or tileBottomRight:collidable()) then
        self.x = (tileTopRight.x - 1) * TILE_SIZE - self.width
    else
        
        self.y = self.y - 1
        local collidedObjects = self:checkObjectCollisions()
        self.y = self.y + 1

        -- reset X if new collided object
        if #collidedObjects > 0 then
            self.x = self.x - PLAYER_WALK_SPEED * dt
        end
    end
end

function Player:checkObjectCollisions()
    local collidedObjects = {}

    for k, object in pairs(self.level.objects) do
        if object:collides(self) then            
            if object.lock and self.key then
                --remove the lock block
                table.remove(self.level.objects, k) 
                --Insert the flipping flag                
                self:insertFlag()
                gSounds['pickup']:play()
            elseif object.solid then
                table.insert(collidedObjects, object)
            elseif object.consumable then
                object.onConsume(self)
                table.remove(self.level.objects, k)
            end                    
        end
    end

    return collidedObjects
end

function Player:insertFlag()
    for x = self.map.width - 1, 1, -1  do
        for y = 5, 7, 2 do 
            if self.map.tiles[y][x].id == TILE_ID_GROUND then
                local post = GameObject{
                    x =(x * TILE_SIZE) - TILE_SIZE,
                    y = (y * TILE_SIZE) - FLAG_HEIGTH, 
                    texture = 'flags',
                    frame = math.random(6),
                    width = 16,
                    height = 48,
                    consumable = true,
                    onConsume = function ()
                        gStateMachine:change('play', {
                            stage = self.stage + 1,
                            score = self.score
                        })
                    end
                }
                table.insert(self.level.objects, post)
                return true
            end
        end
    end
end