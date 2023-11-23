--[[ control.lua © Penguin_Spy 2023
  fixed camera updating & state switching
]]

util = require "util"
local GUI = require "scripts.gui"

if script.active_mods["gvv"] then require("__gvv__.gvv")() end

local function on_tick(event)
  for _, index in pairs(global.fixed_camera_active) do
    local data = global.player_data[index]
    local player = data.player
    local character = data.character
    character.walking_state = player.walking_state

    character.mining_state = player.mining_state
    character.shooting_state = player.shooting_state
    character.selected = player.selected

    local shield
    if character.grid and character.grid.max_shield > 0 then
      shield = character.grid.shield / character.grid.max_shield
    end

    GUI.update_gui(player, {
      health = character.get_health_ratio(),
      mining = character.mining_progress,
      shield = shield
    })
  end
end
--script.on_event(defines.events.on_tick, on_tick)
script.on_nth_tick(2, on_tick)


---@param player LuaPlayer
local function start_fixed_camera(player)
  local camera_entity = player.surface.create_entity{
    name = "fixed-camera-character",
    position = player.position,
    force = player.force
  }
  -- before we change the player's character/controller
  local character = player.character  --[[@as LuaEntity]]
  character.operable = false

  player.set_controller{type = defines.controllers.character, character = camera_entity}

  -- after the character no longer has a controller
  character.associated_player = player

  camera_entity.character_resource_reach_distance_bonus = 9999
  camera_entity.destructible = false
  camera_entity.operable = false

  global.player_data[player.index] = {
    character = character,
    player = player
  }
  table.insert(global.fixed_camera_active, player.index)
end

---@param player LuaPlayer
local function end_fixed_camera(player)
  local camera_entity = player.character
  local character = global.player_data[player.index].character

  player.set_controller{type = defines.controllers.character, character = character}

  camera_entity.destroy()
  GUI.update_gui(player, {})  -- hide fake hud

  global.player_data[player.index] = nil
  util.remove_from_list(global.fixed_camera_active, player.index)
end


commands.add_command("fixed-camera", {"mod-name.fixed-camera"}, function(event)
  local player = game.get_player(event.player_index)  --[[@as LuaPlayer]]

  if not event.parameter then
    player.print("usage: /fixed-camera <enable|disable|toggle>")
    return
  end

  local options = util.split(event.parameter, " ")
  local subcommand = options[1]

  if subcommand == "enable" then
    if not global.player_data[event.player_index] then
      start_fixed_camera(player)
    else
      player.print("already active")
    end
  elseif subcommand == "disable" then
    if global.player_data[event.player_index] then
      end_fixed_camera(player)
    else
      player.print("already not active")
    end
  elseif subcommand == "toggle" then
    if not global.player_data[event.player_index] then
      start_fixed_camera(player)
    else
      end_fixed_camera(player)
    end
  elseif subcommand == "initalize" then
    GUI.init_player_gui(player)
  end
end)


local function display_changed(event)
  local player = game.get_player(event.player_index)  --[[@as LuaPlayer]]
  GUI.update_gui_position(player)
end
script.on_event(defines.events.on_player_display_resolution_changed, display_changed)
script.on_event(defines.events.on_player_display_scale_changed, display_changed)



---@class player_data
---@field character LuaEntity
---@field player LuaPlayer

local function initalize()
  ---@type table<uint, player_data>
  global.player_data = global.player_data or {}
  ---@type uint[]
  global.fixed_camera_active = global.fixed_camera_active or {}
end

script.on_init(initalize)
script.on_configuration_changed(initalize)
