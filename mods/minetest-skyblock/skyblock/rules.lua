 
-- License: WTFPL

rules = {}
function rules.show(player)
	local msgs = {
		"Welcome to Skyblocks!",
		"Created by stormchaser3000 using the",
		"skyblocks mod Copyright (c) 2015 cornernote",
		"Server Owners: shivajiva, BlueSky",
		"Administrators: shivajiva, stormchaser3000",
		"Moderators: dman, mcg, X-men",
		"            JaviCasthor, itwasBANG, Bobr, kitty_lover",
		"Helpers: dotti, coffeecrafter, gfjh, M_Angel",
		"Server Legends: stormchaser3000, RealBadAngel",
		"Server Friends: hey",
		"",
		"By playing on this server you agree to these rules:",
		"* No Swearing!",
		"* No Dating!",
		"* No hacked clients. Don't cheat!",
		"* No unagreed PvP. Ask first!",
		"* Don't cause grief by:",
		"   Building on other players spawns",
		"   Building where islands have yet to spawn",
		"   Damaging players creations e.g. buildings & pixel art",
		"* No impersonating other community members.",
		"* No SHOUTING at other players.",
		"* DO NOT /tpr MODERATORS without asking FIRST!",
		"* No trolling or annoying players or staff",
		"* Do NOT ask to join the moderators IRC channel",
		"*** DO NOT ASK TO BE A HELPER, MODERATOR OR ADMIN ***",
		"Failure to follow these rules will result in a kick or ban",
		"     (temp or permanent) depending on severity."}

	local fs = ""
	for _, line in pairs(msgs) do
		if fs ~= "" then
			fs = fs .. ","
		end
		fs = fs .. minetest.formspec_escape(line)
	end


	fs = "size[8,8]textlist[0.1,0.1;7.8,6;msg;" .. fs .. "]"
	if minetest.check_player_privs(player:get_player_name(), { interact = true }) then
		fs = fs .. "button_exit[0.5,6;7,2;yes;Okay]"
	else
		local yes = minetest.formspec_escape("Yes, let me play!")
		local no = minetest.formspec_escape("No, get me out of here!")

		fs = fs .. "button_exit[0.5,6;3.5,2;no;" .. no .. "]"
		fs = fs .. "button_exit[4,6;3.5,2;yes;" .. yes .. "]"
	end

	minetest.show_formspec(player:get_player_name(), "rules:rules", fs)
end

minetest.register_privilege('citizen', 'Has read and agreed to the server rules')

minetest.register_chatcommand("rules", {
	func = function(name, param)
		if param ~= "" and
				minetest.check_player_privs(name, { kick = true }) then
			name = param
		end

		local player = minetest.get_player_by_name(name)
		if player then
			rules.show(player)
			return true, "Rules shown."
		else
			return false, "Player " .. name .. " does not exist or is not online"
		end
	end
})

minetest.register_on_joinplayer(function(player)
	if not minetest.check_player_privs(player:get_player_name(), { citizen = true }) then
		rules.show(player)
	end
end)

minetest.register_on_player_receive_fields(function(player, form, fields)
	if form ~= "rules:rules" then
		return
	end

	local name = player:get_player_name()
	if minetest.check_player_privs(name, { citizen = true }) then
		return true
	end

	if fields.msg then
		return true
	elseif not fields.yes or fields.no then
		minetest.kick_player(name,
			"You need to agree to the rules to play on this server. " ..
			"Please rejoin and confirm another time.")
		return true
	end

	local privs = minetest.get_player_privs(name)
	privs.citizen = true
	if minetest.get_modpath("jails") then
	  local jailed = jails:getJail(name)
	  if not jailed then
	    privs.shout = true
	    privs.interact = true
	    privs.home = true
	  end
	end
	minetest.set_player_privs(name, privs)

	minetest.chat_send_player(name, "Welcome "..name.."! You have now permission to play!")

	return true
end)
