---@param context Encounter_creator_context
---@return integer encounter_probability
---@return string encounter_string
function Old_world_caravans:cargo_replenish_creator(context)
  local caravan_force = context.caravan:caravan_force();
  local cargo = context.caravan:cargo();

  local probability = 4;

  if cm:military_force_average_strength(caravan_force) == 100 and cargo >= 1000 then
    probability = 0
  end
  return probability, "cargo_replenish"
end