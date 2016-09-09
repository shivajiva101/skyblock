
minetest.register_chatcommand("shivaloka", {
	params = "",
	description = "Teleport to shivajiva's shop",
	func = function(playerName, param)
		local pos = {x = 13919, y = 6, z = 18618}
		minetest.get_player_by_name(playerName):setpos(pos)
		minetest.log("action", playerName.." used /shivaloka ")
		minetest.chat_send_player(playerName, 'Welcome to Shivaloka! Click the shop and hit the stack under the item you wish to buy. Have a nice day!')
		return
	end
})

minetest.register_chatcommand("dmart", {
	params = "",
	description = "Teleport to dman's shop",
	func = function(playerName, param)
		local pos = {x = 15027, y = 7, z = 15100}
		minetest.get_player_by_name(playerName):setpos(pos)
		minetest.log("action", playerName.." used /dmart ")
		minetest.chat_send_player(playerName, 'Welcome to dmart! Click the shop and hit the stack under the item you wish to buy. Have a nice day!')
		return
	end
})

minetest.register_chatcommand("xmart", {
	params = "",
	description = "Teleport to X-men's shop",
	func = function(playerName, param)
		local pos = {x = 19073, y = 4010, z = 15274}
		minetest.get_player_by_name(playerName):setpos(pos)
		minetest.log("action", playerName.." used /dmart ")
		minetest.chat_send_player(playerName, 'Welcome to xmart! Click the shop and hit the stack under the item you wish to buy. Have a nice day!')
		return
	end
})
