-- Crescent Gale: runs every frame on the wind blade.
-- After a short outward flight it steers back to whoever cast it,
-- and disappears when it reaches them.

local OUT_FRAMES   = 20    -- frames of straight flight before it turns
local TURN_RATE    = 0.14  -- how sharply it turns: 0 = never, 1 = instantly
local RETURN_SPEED = 320   -- minimum speed on the way back, pixels per second
local CATCH_RADIUS = 14    -- it is "caught" this close to the caster

local entity_id = GetUpdatedEntityID()
local x, y = EntityGetTransform( entity_id )
if x == nil then
	return
end

-- Count the frames flown.
local age_comp = nil
local comps = EntityGetComponent( entity_id, "VariableStorageComponent" )
if comps ~= nil then
	for _, comp in ipairs( comps ) do
		if ComponentGetValue2( comp, "name" ) == "age" then
			age_comp = comp
			break
		end
	end
end
if age_comp == nil then
	return
end
local age = ( ComponentGetValue2( age_comp, "value_int" ) or 0 ) + 1
ComponentSetValue2( age_comp, "value_int", age )
if age < OUT_FRAMES then
	return
end

-- No caster to return to: it just keeps flying until it runs out.
local projectile_comp = EntityGetFirstComponent( entity_id, "ProjectileComponent" )
if projectile_comp == nil then
	return
end
local who_shot = ComponentGetValue2( projectile_comp, "mWhoShot" )
if who_shot == nil or who_shot == 0 or not EntityGetIsAlive( who_shot ) then
	return
end
local target_x, target_y = EntityGetTransform( who_shot )
if target_x == nil or target_y == nil then
	return
end
target_y = target_y - 4 -- roughly the caster's chest

local dx, dy = target_x - x, target_y - y
local dist = math.sqrt( dx * dx + dy * dy )
if dist < CATCH_RADIUS then
	EntityKill( entity_id )
	return
end

local velocity_comp = EntityGetFirstComponent( entity_id, "VelocityComponent" )
if velocity_comp == nil then
	return
end
local vel_x, vel_y = ComponentGetValue2( velocity_comp, "mVelocity" )
if vel_x == nil or vel_y == nil then
	return
end

local speed = math.max( math.sqrt( vel_x * vel_x + vel_y * vel_y ), RETURN_SPEED )
local want_x, want_y = dx / dist * speed, dy / dist * speed
vel_x = vel_x + ( want_x - vel_x ) * TURN_RATE
vel_y = vel_y + ( want_y - vel_y ) * TURN_RATE
ComponentSetValue2( velocity_comp, "mVelocity", vel_x, vel_y )
