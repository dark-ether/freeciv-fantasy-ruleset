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
Terrain_Access_Techs = {
  Cold = {
    "Flux Cold Terrain Access",
    "Magical Cold Terrain Access",
    "Scientific Cold Terrain Access"
  },
  Desert = {
    "Flux Desert Terrain Access",
    "Magical Desert Terrain Access",
    "Scientific Desert Terrain Access"
  },
  Elevated = {
    "Divine Elevated Terrain Access",
    "Flux Elevated Terrain Access",
    "Scientific Elevated Terrain Access"
  },
  FluxAffected = {
    "Divine FluxAffected Terrain Access",
    "Flux FluxAffected Terrain Access",
    "Magical FluxAffected Terrain Access"
  },
  Oceanic = {
    "Divine Oceanic Terrain Access",
    "Magical Oceanic Terrain Access",
    "Scientific Oceanic Terrain Access"
  },
  Wet = {
    "Divine Wet Terrain Access",
    "Flux Wet Terrain Access",
    "Scientific Wet Terrain Access"
  }
}
Terrain_Improvement_Techs = {
  Open = {
    "Flux Open Terrain Improvement",
    "Scientific Open Terrain Improvement"
  },
  Forested = {
    "Flux Forested Terrain Improvement",
    "Scientific Forested Terrain Improvement"
  }
}
Terrain_Access_Name = " Terrain Access"

Monarchy_Government_Techs = {}
Republic_Government_Techs = {}


Strategic_Resources_List = {"Anole Weasel", "Cow", "Hunting Newt", "Giant Spider",
                            "Gestril", "Orichalcum","Steel","Votrite",
                            "Diamond","Molserite","Rutssanite","Wyarpuhyite"
}
OneInChanceForSRs = 15
-- section of things that should belong in a standard library for scripts
Utility = {}
Utility.table_contains = function (table_to_search,element_to_find)
  local found = false
  for name,value_in_table in pairs(table_to_search)do
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


Utility.deep_copy = function (mytable)
  local new_table = {}
  for key,value in pairs(mytable)do
    if type(value) == "table" then
      new_table[key] = Utility.deep_copy(value)
    else
      new_table[key] = value
    end
  end
  return new_table
end

Utility.map = function (table_to_operate,lifted_func)
  local new_table = {}
  for key ,value in pairs(table_to_operate) do
    new_table[key] = lifted_func(value)
  end
  return new_table
end

Utility.map_key = function(table_to_operate,lifted_func)
  local new_table = {}
  for key,value in pairs(table_to_operate) do
    new_table[key] = lifted_func(key,value)
  end
  return new_table
end

Utility.filter = function(table_to_operate,predicate)
  local new_table = {}
  for key,value in pairs(table_to_operate)do
    if predicate(value)then
    new_table[key] = Utility.deep_copy(value)
    end
  end
  return new_table
end

Utility.filter_key = function (table_to_filter,predicate)
   local new_table = {}
  for key,value in pairs(table_to_filter)do
    if predicate(key,value) then
    new_table[key] = Utility.deep_copy(value)
    end
  end
  return new_table
end


-- things i expect to use more than once but which aren't utilities


-- signals that i am connecting to, 
-- they have a set order first is mapgen
-- then things that fire every turn
-- then things that fire per events 
-- and finally things that fire due to actions 
signal.connect("map_generated","Map_generated_callback")


signal.connect("turn_begin","Turn_begin_callback")


signal.connect("tech_researched","Tech_research_callback")


-- callback functions and supporting functions 
-- any local function is a auxiliary function
function Map_generated_callback()
  for tile in whole_map_iterate() do
    -- for now the simplest i can think about should be sufficient 
    -- so we will randomly get a tile with 1 in 15 chance 
    if random(1,OneInChanceForSRs) == 1 then
      local extraToGen = Utility.random_from_list(Strategic_Resources_List)
      tile:create_extra(extraToGen)
    end
  end
end


local function setup_player_turn(player,turn)
end

function Turn_begin_callback(turn_started,current_year)
  for player in players_iterate()do
    setup_player_turn(player,turn_started)
  end
end

-- tech_research_callback
local function terrain_access_tech_routine (learned_tech, tr_player)
  for name, techList in pairs(Terrain_Access_Techs) do
    if Utility.table_contains(techList,learned_tech:rule_name()) then
      local special_tech_name = name .. Terrain_Access_Name
      if not tr_player:knows_tech(find.tech_type(special_tech_name)) then
        tr_player:give_tech(find.tech_type(special_tech_name),0,true,"researched")
      end
    end
  end
end

function Tech_research_callback(learned_tech, tech_research_player,source_of_tech)
  terrain_access_tech_routine(learned_tech,tech_research_player)
  --government_tech_routine(learned_tech,tech_research_player)
end


