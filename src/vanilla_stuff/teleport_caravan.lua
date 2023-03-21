---@param context CaravanMoved
function Old_world_caravans:teleport_caravan(context)
  local caravan_force_list = context:caravan_master():character():military_force():unit_list();

  for i = 0, caravan_force_list:num_items() - 1 do
    local unit = caravan_force_list:item_at(i);
    local unit_key = unit:unit_key();
    if self.caravan_master_units[unit_key] then
      cm:set_unit_hp_to_unary_of_maximum(unit, 1);
      break
    end
  end
  --Spread out caravans
  local caravan_lookup = cm:char_lookup_str(context:caravan():caravan_force():general_character():command_queue_index())
  local x, y = cm:find_valid_spawn_location_for_character_from_character(
    context:faction():name(),
    caravan_lookup,
    true,
    cm:random_number(15, 5)
  )
---@diagnostic disable-next-line: param-type-mismatch
  cm:teleport_to(caravan_lookup, x, y);


end