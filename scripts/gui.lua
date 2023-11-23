local GUI = {}

local hud_flow_name = "fixed_camera_hud_flow"

local PROGRESS_BAR_WIDTH = 468
local PROGRESS_BAR_HEIGHT = 13
local QUICKBAR_ROW_HEIGHT = 40
local QUICKBAR_PADDING = 16
local HORIZONTAL_OFFSET = 24

---@param player LuaPlayer
function GUI.init_player_gui(player)
  local flow = player.gui.screen[hud_flow_name]
  if flow then
    flow.destroy()
  end
  flow = player.gui.screen.add{
    type = "flow",
    name = hud_flow_name,
    direction = "vertical",
    style = "fixed_camera_quickbar_holder_flow"  -- correct width
  }
  flow.add{
    type = "progressbar",
    name = "health_progressbar",
    style = "health_progressbar",
    value = 0.5
  }
  flow.add{
    type = "progressbar",
    name = "mining_progressbar",
    style = "mining_progressbar",
    value = 0.5
  }
  flow.add{
    type = "progressbar",
    name = "shield_progressbar",
    style = "shield_progressbar",
    value = 0.5
  }
  GUI.update_gui_position(player)
end

---@param player LuaPlayer
function GUI.update_gui_position(player)
  local flow = player.gui.screen[hud_flow_name]
  local bar_count = 0
  for _, bar in pairs(flow.children) do
    if bar.visible then
      bar_count = bar_count + 1
    end
  end

  local res = player.display_resolution
  local scale = player.display_scale

  flow.location = {
    -- center of screen - half width of bar - horizontal offset (from quickbar row page button)
    x = res.width / 2 - (PROGRESS_BAR_WIDTH * scale / 2) - HORIZONTAL_OFFSET * scale,
    -- pixels per quickbar row * # of quickbar rows + quickbar padding + height of health bar
    y = res.height - ((QUICKBAR_ROW_HEIGHT * scale * 2) + QUICKBAR_PADDING * scale + PROGRESS_BAR_HEIGHT * scale * bar_count)
  }
end

---@param player LuaPlayer
---@param data {health: double?, mining: double?, shield: double?}
function GUI.update_gui(player, data)
  local flow = player.gui.screen[hud_flow_name]

  if data.health and data.health ~= 1 then
    flow["health_progressbar"].visible = true
    flow["health_progressbar"].value = data.health
  else
    flow["health_progressbar"].visible = false
  end

  if data.mining then
    flow["mining_progressbar"].visible = true
    flow["mining_progressbar"].value = data.mining
  else
    flow["mining_progressbar"].visible = false
  end

  if data.shield and data.shield ~= 1 then
    flow["shield_progressbar"].visible = true
    flow["shield_progressbar"].value = data.shield
  else
    flow["shield_progressbar"].visible = false
  end

  GUI.update_gui_position(player)
end

return GUI
