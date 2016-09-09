--[[

Skyblock for Minetest

Copyright (c) 2015 cornernote, Brett O'Donnell <cornernote@gmail.com>
Source Code: https://github.com/cornernote/minetest-skyblock
License: GPLv3

]]--

--[[Level 5 features and rewards
Requires:
moreores
unified_inventory
smartshop
carts

<X-men>	1.craft and place 200 obsidian brick; reward (2 mithril lumps)
<X-men>	2.craft 20 mithril blocks ; reward (1 aspen sapling)
<X-men>	3.craft mithril pickaxe ; reward (2 silver lumps)
<X-men>	4.craft and place 50 silver blocks ; reward (2 tin lumps)
<X-men>	5.craft and place 300 aspen planks ; reward (1 fancy bed)
<X-men>	6.craft and place 50 tin blocks ; reward (straight line 50)
<X-men>	7.craft and place 100 mithril blocks ; reward (30 L line)
<X-men>	8.craft and place 200 dirt with grass ; reward (20 rope)
<X-men>	9.craft 500 meselamp ; reward (4 large bags)
<X-men>	10.place 400 powered rails ; reward (2 smartshop)

]]

-- Register the new ores from moreores
-- mithril ore
minetest.register_craft({
	output = 'moreores:mineral_mithril 2',
	recipe = {
		{'moreores:mithril_lump'},
		{'default:stone'},
	}
})

-- tin ore
minetest.register_craft({
	output = 'moreores:mineral_tin 2',
	recipe = {
		{'moreores:tin_lump'},
		{'default:stone'},
	}
})
-- silver ore
minetest.register_craft({
	output = 'moreores:mineral_silver 2',
	recipe = {
		{'moreores:silver_lump'},
		{'default:stone'},
	}
})

local level = 5

--
-- PUBLIC FUNCTIONS
--

skyblock.levels[level] = {}

-- feats
skyblock.levels[level].feats = {
	{
		name = 'craft & place obsidian brick',
		hint = 'default:obsidianbrick',
		feat = 'place_obsidian', 
		count = 200,
		reward = 'moreores:mithril_lump 2',
		placenode = {'default:obsidianbrick'},
	},
      {
		name = 'craft 20 mithril blocks',
		hint = 'moreores:mithril_block',
		feat = 'craft_mithril', 
		count = 20,
		reward = 'default:aspen_sapling 1',
		craft = {'moreores:mithril_block'},
	},
      {
		name = 'craft mithril pickaxe',
		hint = 'moreores:pick_mithril',
		feat = 'craft_mithril_pick', 
		count = 1,
		reward = 'moreores:silver_lump',
		craft = {'moreores:pick_mithril'},
	},
      {
		name = 'craft & place 50 silver blocks',
		hint = 'moreores:silver_block',
		feat = 'place_silver', 
		count = 50,
		reward = 'moreores:tin_lump 2',
		placenode = {'moreores:silver_block'},
	},
	{
		name = 'craft & place 300 aspen planks',
		hint = 'default:aspen_wood',
		feat = 'place_aspen', 
		count = 300,
		reward = 'beds:fancy_bed_bottom',
		placenode = {'default:aspen_wood'},
	},
      {
		name = 'craft & place 50 tin blocks',
		hint = 'moreores:tin_block',
		feat = 'place_tin_block', 
		count = 50,
		reward = 'soccer:line_i 50',
		placenode = {'moreores:tin_block'},
	},
      {
		name = 'craft & place 100 mithril blocks',
		hint = 'moreores:mithril_block',
		feat = 'place_mithril_again', 
		count = 100,
		reward = 'soccer:line_l 50',
		placenode = {'moreores:mithril_block'},
	},
      {
		name = 'craft & place 200 dirt with grass',
		hint = 'default:dirt_with_grass',
		feat = 'place_grass', 
		count = 200,
		reward = 'moreblocks:rope 20',
		placenode = {'default:dirt_with_grass'},
	},
      {
		name = 'craft & place 500 meselamp',
		hint = 'default:meselamp',
		feat = 'place_meselamp', 
		count = 500, 
		reward = 'unified_inventory:bag_large 4',
		placenode = {'default:meselamp'},
	},
      {
		name = 'craft & place 400 powered rails',
		hint = 'carts:powerrail',
		feat = 'place_powerrail', 
		count = 400,
		reward = 'smartshop:shop 2',
		placenode = {'carts:powerrail'},
	},
}

-- init level
skyblock.levels[level].init = function(player_name)
	local privs = core.get_player_privs(player_name)
	privs['player_skins'] = true
	core.set_player_privs(player_name, privs)
	minetest.chat_send_player(player_name, 'You can now use player skins!')
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
		..'label[0,1.0; '..player_name..' you are almost there.]'
		..'label[0,1.5; just a few more quests for your reward ]'
		..'label[0,2.0; Hurry now do not delay...]'
		
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
