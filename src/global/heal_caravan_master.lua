---@param context CaravanMoved
function Old_world_caravans:heal_caravan_master(context)
  local caravan_force_list = context:caravan_master():character():military_force():unit_list();

  for i = 0, caravan_force_list:num_items() - 1 do
    local unit = caravan_force_list:item_at(i);
    local unit_key = unit:unit_key();
    if self.caravan_master_units[unit_key] then
      cm:set_unit_hp_to_unary_of_maximum(unit, 1);
      break
    end
  end

end