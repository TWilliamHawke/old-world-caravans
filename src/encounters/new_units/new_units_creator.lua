---@param context Encounter_creator_context
---@return integer encounter_probability
function Old_world_caravans:new_units_creator(context)
  local army_size = context.caravan:caravan_force():unit_list():num_items();
  local probability = 20 - army_size;

  if army_size < 11 then
    probability = math.ceil(probability * 1.5)
  end

  return probability;
end
