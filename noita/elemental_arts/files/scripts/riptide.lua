-- Riptide: runs every frame on the current attached to a caught enemy.
-- Drags the enemy towards the nearest player and lets go once it is close.

local PULL_SPEED   = 170  -- pixels per second towards the player
local HOP          = 45   -- small upward speed, so it is dragged over bumps
local STOP_DISTANCE = 26  -- the pull ends this close to the player

local current_id = GetUpdatedEntityID()
local victim = EntityGetRootEntity( current_id )
if victim == nil or victim == 0 or victim == current_id then
	return
end

local victim_x, victim_y = EntityGetTransform( victim )
if victim_x == nil or victim_y == nil then
	return
end

-- Find the nearest player.
local target_x, target_y = nil, nil
local best = nil
local players = EntityGetWithTag( "player_unit" ) or {}
for _, player in ipairs( players ) do
	if player ~= victim then
		local px, py = EntityGetTransform( player )
		if px ~= nil and py ~= nil then
			local d = ( px - victim_x ) * ( px - victim_x ) + ( py - victim_y ) * ( py - victim_y )
			if best == nil or d < best then
				best = d
				target_x, target_y = px, py
			end
		end
	end
end
if target_x == nil then
	return
end

local dx, dy = target_x - victim_x, target_y - victim_y
local dist = math.sqrt( dx * dx + dy * dy )
if dist < STOP_DISTANCE then
	return
end

local char_comp = EntityGetFirstComponent( victim, "CharacterDataComponent" )
if char_comp == nil then
	return
end

-- Negative y is up.
ComponentSetValue2( char_comp, "mVelocity", dx / dist * PULL_SPEED, dy / dist * PULL_SPEED - HOP )
