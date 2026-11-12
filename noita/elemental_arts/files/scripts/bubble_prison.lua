-- Bubble Prison: runs every frame on the bubble attached to a trapped enemy.
-- The bubble floats upwards and takes its victim along, feet off the ground.

local RISE_SPEED = 55   -- upward speed in pixels per second
local DRIFT_KEPT = 0.6  -- share of sideways speed kept each frame, so it cannot walk away

local bubble_id = GetUpdatedEntityID()
local victim = EntityGetRootEntity( bubble_id )
if victim == nil or victim == 0 or victim == bubble_id then
	return
end

local char_comp = EntityGetFirstComponent( victim, "CharacterDataComponent" )
if char_comp == nil then
	return
end

local vel_x, vel_y = ComponentGetValue2( char_comp, "mVelocity" )
if vel_x == nil or vel_y == nil then
	return
end

-- Negative y is up.
ComponentSetValue2( char_comp, "mVelocity", vel_x * DRIFT_KEPT, -RISE_SPEED )
