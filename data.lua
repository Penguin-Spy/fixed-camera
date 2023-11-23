--[[ data.lua © Penguin_Spy 2023
  creates an invisible, uninteractable character with 0 movement speed to keep the player's camera in one spot
]]

local blank_animation = {
  filename = "__fixed-camera__/graphics/empty.png",
  direction_count = 18,
  size = 1,
}

data:extend{
  {
    type = "character",
    name = "fixed-camera-character",

    -- changed
    mining_speed = 0.0,
    running_speed = 0.0,
    distance_per_frame = 0.0,
    animations = {
      {
        idle = blank_animation,
        idle_with_gun = blank_animation,
        running = blank_animation,
        running_with_gun = blank_animation,
        mining_with_tool = blank_animation,
      }
    },
    running_sound_animation_positions = {},
    mining_with_tool_particles_animation_positions = {},
    collision_mask = {},
    --collision_box = {{-0.2, -0.2}, {0.2, 0.2}},
    --selection_box = {{-0.4, -1.4}, {0.4, 0.2}},
    --hit_visualization_box = {{-0.2, -1.1}, {0.2, 0.2}},
    --sticker_box = {{-0.2, -1}, {0.2, 0}},

    has_belt_immunity = true,
    is_military_target = false,

    enter_vehicle_distance = 0,

    -- may need to change
    inventory_size = 80,
    build_distance = 10,
    drop_item_distance = 10,
    reach_distance = 10,
    reach_resource_distance = 2.7,
    item_pickup_distance = 1,
    loot_pickup_distance = 2,

    ticks_to_keep_gun = 600,
    ticks_to_keep_aiming_direction = 100,
    --ticks you need to wait after firing a weapon or taking damage to get out of combat and get healed
    ticks_to_stay_in_combat = 600,
    damage_hit_tint = {r = 0.12, g = 0, b = 0, a = 0},


    -- copied from default character
    icon = "__core__/graphics/icons/entity/character.png",
    icon_size = 64, icon_mipmaps = 4,
    flags = {"placeable-off-grid", "breaths-air", "not-repairable", "not-on-map", "not-flammable"},
    max_health = 250,
    alert_when_damaged = false,
    healing_per_tick = 0.15,
    crafting_categories = {"crafting"},
    mining_categories = {"basic-solid"},
    character_corpse = "character-corpse",
    maximum_corner_sliding_distance = 0.7,
    subgroup = "creatures",
    order = "a",
    eat = {
      {
        filename = "__base__/sound/eat.ogg",
        volume = 1
      }
    },
    heartbeat = {
      {
        filename = "__base__/sound/heartbeat.ogg"
      }
    }
  }
}

data.raw["gui-style"].default["fixed_camera_quickbar_holder_flow"] = {
  type = "vertical_flow_style",
  vertical_spacing = 0,
  vertical_align = "bottom",
  --minimal_height = 96,
  minimal_width = 468
}
