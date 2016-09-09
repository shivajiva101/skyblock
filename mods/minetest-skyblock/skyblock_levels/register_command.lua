--[[

Skyblock for Minetest

Copyright (c) 2015 cornernote, Brett O'Donnell <cornernote@gmail.com>
Source Code: https://github.com/cornernote/minetest-skyblock
License: GPLv3

]]--


-- register register_privilege
minetest.register_privilege('level', 'Can use /level')
local ghub = minetest.get_mod_path("gamehub")

-- level
minetest.register_chatcommand('level', {
	description = 'Get or change a players current level.',
	privs = {level = true},
	params = "<player_name> <level>",
	func = function(name, param)
		local found, _, player_name, level = param:find("^([^%s]+)%s+(.+)$")
		if not player_name then
			player_name = name
		end
		-- prevent offline player to stop server crash
		if not minetest.get_player_by_name(player_name) then
			return
		end
		level = tonumber(level)
		if not level then
			minetest.chat_send_player(name, player_name..' is on level '..skyblock.feats.get_level(player_name))
			return
		end
		if skyblock.feats.set_level(player_name, level) then
			minetest.chat_send_player(name, player_name..' has been set to level '..level)
		else
			minetest.chat_send_player(name, 'cannot change '..player_name..' to level '..level)
		end
	end,
})

--spawn
minetest.register_chatcommand('spawn', {
	description = 'Get a players spawn coordinates',
	privs = {jailer = true},
	params = "<player_name>",
	func = function(name, param)
		local player_name, playerspawn
		if #param==0 then
		  -- do self
		  player_name = name
		else
		  --do player
		  player_name = param
		end
		-- get spawnpoint
		playerspawn = skyblock.get_spawn(player_name)
		if playerspawn then -- check player exists
		  minetest.chat_send_player(name, player_name..' spawns at '..playerspawn.x..','..playerspawn.y..','..playerspawn.z)
		  minetest.log("info", name.." used spawn command to find "..player_name)
		else
		  minetest.chat_send_player(name, player_name..' does not exist, did you type the name correctly?')
		  minetest.log("info", name.." used spawn command to find the unknown player: "..player_name)
		end
	end,
})

minetest.register_chatcommand('tpspawn', {
	description = 'Teleport to a players spawn coordinates',
	privs = {jailer = true},
	params = "<player_name>",
	func = function(name, param)
	 local player_name, spawn
		if #param==0 then
		  -- do self
		  minetest.chat_send_player(name, ' Error: missing <player> USAGE:  /tpspawn <player>')
		  return
		end
		-- get spawnpoint
		spawn = skyblock.get_spawn(param)
		if spawn then -- check player exists
		  minetest.get_player_by_name(name):setpos(spawn)
		  minetest.log("info", name.." used tpspawn to teleport to "..param)
		else
		  minetest.chat_send_player(name, param..' does not exist, did you type the name correctly?')
		  minetest.log("info", name.." used tpspawn command using unknown player: "..param)
		end
	end,	
})

minetest.register_chatcommand("home", {
  params = "",
  description = "Teleports you to your spawn position",
  func = function(playerName, param)
	if ghub then
	  if gamehub.game.players[playerName] then
	    return false, "Use /quit to leave the game hub..."
	  end
	end
    -- teleport player to registered spawn point
    local spawn = skyblock.get_spawn(playerName)
    local pos = {x = spawn.x, y = spawn.y + 2, z= spawn.z}
    minetest.get_player_by_name(playerName):setpos(pos)
  end,
})

-- who
minetest.register_chatcommand('who', {
	description = 'Display list of online players and their current level.',
	func = function(name)
		minetest.chat_send_player(name, 'Current Players:')
		for _,player in ipairs(minetest.get_connected_players()) do
			local player_name = player:get_player_name()
			minetest.chat_send_player(name, ' - '..player_name..' - level '..skyblock.feats.get_level(player_name))
		end
	end,
})
