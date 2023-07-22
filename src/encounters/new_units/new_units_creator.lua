---@param context Encounter_creator_context
---@return integer encounter_probability
function Old_world_caravans:new_units_creator(context)
  local army_size = context.caravan:caravan_force():unit_list():num_items();
  local probability = math.ceil((20 - army_size) * 1.5);

  return probability;
end
