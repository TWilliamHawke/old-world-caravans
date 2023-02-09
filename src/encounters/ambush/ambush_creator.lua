---@param context Encounter_creator_context
---@return integer encounter_probability
---@return string encounter_string
function Old_world_caravans:ambush_creator(context)
  local probability = math.floor(context.bandit_threat / 20) + 3;

  return probability, "ambush"
end;