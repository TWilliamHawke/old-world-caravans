---@param caravan CARAVAN_SCRIPT_INTERFACE
---@param x number
---@param y number
function Old_world_caravans:teleport_caravan_to_position(caravan, x, y)
  local caravan_faction = caravan:caravan_force():faction();

  local caravan_x, caravan_y = cm:find_valid_spawn_location_for_character_from_position(
    caravan_faction:name(), x, y, false
  );

  local caravan_teleport_cqi = caravan:caravan_force():general_character():command_queue_index();
  local caravan_lookup = cm:char_lookup_str(caravan_teleport_cqi)

  ---@diagnostic disable-next-line: param-type-mismatch
  cm:teleport_to(caravan_lookup, caravan_x, caravan_y);
end
