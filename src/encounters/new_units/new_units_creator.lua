---@param context Encounter_creator_context
---@return integer encounter_probability
---@return string encounter_string
function Old_world_caravans:new_units_creator(context)
  local army_size = context.caravan:caravan_force():unit_list():num_items();
  local probability = 20 - army_size;

  return probability, "new_units?"
end
