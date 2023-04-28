---comment
---@param caravan CARAVAN_SCRIPT_INTERFACE
---@return string | nil
function Old_world_caravans:get_random_unit(caravan)
  local caravan_force = caravan:caravan_force();

  local agents_count = caravan_force:character_list():num_items();
  local units_count = caravan_force:unit_list():num_items();

  if units_count - agents_count < 1 then
    return
  end

  local random_idx = cm:random_number(units_count - 1, agents_count);
  local random_unit = caravan_force:unit_list():item_at(random_idx):unit_key();

  return random_unit
end