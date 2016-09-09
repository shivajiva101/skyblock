--[[

Skyblock for Minetest

Copyright (c) 2015 cornernote, Brett O'Donnell <cornernote@gmail.com>
Source Code: https://github.com/cornernote/minetest-skyblock
License: GPLv3

]]--

--[[

level 4 feats and rewards:

* place mailbox			default:cactus 5
* grow_cactus x 20		default:stone
* dig_stone_with_coal x 99	wool:red 99
* dig_stone_with_iron x 99	wool:magenta 99
* craft elevator x2		wool:violet 99
* dig_stone_with_copper x 99	wool:brown 99
* dig_stone_with_gold x 99	wool:dark_green 99
* dig_stone_with_diamond x 99	wool:yellow 99
* dig_stone_with_mese x 200	default:diamondblock 99
* craft travelnet x 20		default:mese_block 20

]]--

local level = 4

--
-- PUBLIC FUNCTIONS
--

skyblock.levels[level] = {}

-- feats
skyblock.levels[level].feats = {
	{
		name = 'craft and place a mailbox',
		hint = 'inbox:empty',
		feat = 'place_inbox', 
		count = 1,
		reward = 'default:cactus 5',
		placenode = {'inbox:empty'},
	},
      {
		name = 'grow and plant 50 Cactus',
		hint = 'default:cactus',
		feat = 'place_cactus', 
		count = 50,
		reward = 'default:stone 99',
		placenode = {'default:cactus'},
	},
      {
		name = 'dig 99 coal lumps',
		hint = 'default:stone_with_coal',
		feat = 'dig_stone_with_coal2', 
		count = 99,
		reward = 'wool:red 99',
		dignode = {'default:stone_with_coal'},
	},
      {
		name = 'dig 99 iron lumps',
		hint = 'default:stone_with_iron',
		feat = 'dig_stone_with_iron2', 
		count = 99,
		reward = 'wool:magenta 99',
		dignode = {'default:stone_with_iron'},
	},
	{
		name = 'craft 2 elevators',
		hint = 'travelnet:elevator',
		feat = 'craft_elevators', 
		count = 2,
		reward = 'wool:violet 99',
		craft = {'travelnet:elevator'},
	},
      {
		name = 'dig 99 copper lumps',
		hint = 'default:stone_with_copper',
		feat = 'dig_stone_with_copper2', 
		count = 99,
		reward = 'wool:brown 99',
		dignode = {'default:stone_with_copper'},
	},
      {
		name = 'dig 99 gold lumps',
		hint = 'default:stone_with_gold',
		feat = 'dig_stone_with_gold', 
		count = 99,
		reward = 'wool:dark_green 99',
		dignode = {'default:stone_with_gold'},
	},
      {
		name = 'dig 200 diamonds',
		hint = 'default:stone_with_diamond',
		feat = 'dig_stone_with_diamond', 
		count = 200,
		reward = 'wool:yellow 99',
		dignode = {'default:stone_with_diamond'},
	},
      {
		name = 'dig 200 mese crystals',
		hint = 'default:stone_with_mese',
		feat = 'dig_stone_with_mese', 
		count = 200, 
		reward = 'default:diamondblock 99',
		dignode = {'default:stone_with_mese'},
	},
      {
		name = 'craft 20 travelnets',
		hint = 'travelnet:travelnet',
		feat = 'craft_travelnet', 
		count = 20,
		reward = 'default:mese_block 20',
		craft = {'travelnet:travelnet'},
	},
    }

-- init level
skyblock.levels[level].init = function(player_name)
	local privs = core.get_player_privs(player_name)
	-- added check for jail mod
	if minetest.get_modpath("jails") then
	  local jailName, jail = jails:getJail(player_name)
	  if jail then return end
	end
	privs['fly'] = true
	privs['fast'] = true
	core.set_player_privs(player_name, privs)
	minetest.chat_send_player(player_name, 'You can now use FLY and FAST !')
end

-- get level information
skyblock.levels[level].get_info = function(player_name)
	local info = { 
		level=level, 
		total=10, 
		count=0, 
		player_name=player_name, 
		infotext='', 
		formspec = '', 
		formspec_quest = '',
	}
	
	local text = 'label[0,2.7; --== Quests ==--]'
		..'label[0,0.5; Hey '..player_name..', does this keep going?]'
		..'label[0,1.0; If you are enjoying this world, then stray not]'
		..'label[0,1.5; from your mission traveller...]'
		..'label[0,2.0; ... for the end is in sight!]'
		
	info.formspec = skyblock.levels.get_inventory_formspec(level,info.player_name,true)..text
	info.formspec_quest = skyblock.levels.get_inventory_formspec(level,info.player_name)..text

	for k,v in ipairs(skyblock.levels[level].feats) do
		info.formspec = info.formspec..skyblock.levels.get_feat_formspec(info,k,v.feat,v.count,v.name,v.hint,true)
		info.formspec_quest = info.formspec_quest..skyblock.levels.get_feat_formspec(info,k,v.feat,v.count,v.name,v.hint)
	end
	if info.count>0 then
		info.count = info.count/2 -- only count once
	end

	info.infotext = 'LEVEL '..info.level..' for '..info.player_name..': '..info.count..' of '..info.total
	
	return info
end

-- reward_feat
skyblock.levels[level].reward_feat = function(player_name,feat)
	return skyblock.levels.reward_feat(level, player_name, feat)
end

-- track digging feats
skyblock.levels[level].on_dignode = function(pos, oldnode, digger)
	skyblock.levels.on_dignode(level, pos, oldnode, digger)
end

-- track placing feats
skyblock.levels[level].on_placenode = function(pos, newnode, placer, oldnode)
	skyblock.levels.on_placenode(level, pos, newnode, placer, oldnode)
end

-- track eating feats
skyblock.levels[level].on_item_eat = function(player_name, itemstack)
	skyblock.levels.on_item_eat(level, player_name, itemstack)
end

-- track crafting feats
skyblock.levels[level].on_craft = function(player_name, itemstack)
	skyblock.levels.on_craft(level, player_name, itemstack)
end

-- track bucket feats
skyblock.levels[level].bucket_on_use = function(player_name, pointed_thing)
	skyblock.levels.bucket_on_use(level, player_name, pointed_thing)
end

-- track bucket water feats
skyblock.levels[level].bucket_water_on_use = function(player_name, pointed_thing) 
	skyblock.levels.bucket_water_on_use(level, player_name, pointed_thing)
end

-- track bucket lava feats
skyblock.levels[level].bucket_lava_on_use = function(player_name, pointed_thing)
	skyblock.levels.bucket_lava_on_use(level, player_name, pointed_thing)
end
