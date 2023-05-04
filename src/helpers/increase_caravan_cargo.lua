---@diagnostic disable: param-type-mismatch, undefined-field
---@param caravan CARAVAN_SCRIPT_INTERFACE
---@param amount integer
function Old_world_caravans:increase_caravan_cargo(caravan, amount)
  local force_cqi = caravan:caravan_force():command_queue_index();
  cm:apply_effect_bundle_to_force("owc_caravan_cargo_cap", force_cqi, 0);

  local cargo = caravan:cargo();
  cm:set_caravan_cargo(caravan, cargo + amount);

end