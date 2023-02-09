---@param context Encounter_creator_context
---@return integer encounter_probability
---@return string encounter_string
function Old_world_caravans:enemy_attack_creator(context)
  local probability = math.ceil(context.bandit_threat / 10) + 3;
  return probability, "enemy_attack";
end