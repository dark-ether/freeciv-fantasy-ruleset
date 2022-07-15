-- Freeciv - Copyright (C) 2007 - The Freeciv Project
--   This program is free software; you can redistribute it and/or modify
--   it under the terms of the GNU General Public License as published by
--   the Free Software Foundation; either version 2, or (at your option)
--   any later version.
--
--   This program is distributed in the hope that it will be useful,
--   but WITHOUT ANY WARRANTY; without even the implied warranty of
--   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
--   GNU General Public License for more details.

-- This file is for lua-functionality that is specific to a given
-- ruleset. When freeciv loads a ruleset, it also loads script
-- file called 'default.lua'. The one loaded if your ruleset
-- does not provide an override is default/default.lua.


-- constants later will test if i can get them from luadata.txt file
Cold_Terrain_Techs = {}
Desert_Terrain_Techs = {}
Elevated_Terrain_Techs = {}
FluxAffected_Terrain_Techs = {}
Oceanic_Terrain_Techs = { "Divine Oceanic Terrain Access" }
Wet_Terrain_Techs = { "Divine Wet Terrain Access" }

Monarchy_Government_Techs = {}
Republic_Government_Techs = {}


Strategic_Resources_List = {"Anole Weasel", "Cow", "Hunting Newt", "Giant Spider",
                            "Gestril", "Orichalcum","Steel","Votrite",
                            "Diamond","Molserite","Rutssanite","Wyarpuhyite"
}
-- section of things that should belong in a standard library for scripts
Utility = {}
Utility.table_contains = function (table_to_search,element_to_find)
  local found = false
  for value_in_table in pairs(table_to_search)do
    if value_in_table == element_to_find then
    found = true
    break
    end
  end
  return found
end

Utility.random_from_list =  function (list)
  local index = random(1,#list)
  return list[index]
end

-- signals that i am connecting to, 
-- they have a set order first is map generation 
-- then things that fire every turn
-- then things that fire per events 
-- and finally things that fire due to actions 
signal.connect("map_generated","map_generated_callback")


signal.connect("turn_begin","turn_begin_callback")


signal.connect("tech_researched","tech_research_callback")


-- callback functions 
function map_generated_callback()
  for tile in whole_map_iterate() do 
    -- for now the simplest i can think about should be sufficient 
    -- so we will randomly get a tile with 1 in 5 chance 
    if random(1,20) == 1 then
      local extraToGen = Utility.random_from_list(Strategic_Resources_List)
      tile:create_extra(extraToGen)
    end
  end
end


function turn_begin_callback(turn_started,current_year)
end


function tech_research_callback(learned_tech, tech_research_player,source_of_tech)
  terrain_access_tech_routine(learned_tech,tech_research_player)
  --government_tech_routine(learned_tech,tech_research_player)
end

local function terrain_access_tech_routine(learned_tech, tech_research_player)

end



