---@param context Encounter_creator_context
---@return integer encounter_probability
function Old_world_caravans:enemy_attack_creator(context)

  local cargo_factor = math.floor(context.caravan:cargo() * self.cargo_threat_mult);
  local probability = math.ceil((context.bandit_threat + cargo_factor) / 6) + 5;
  local max_probability = math.floor(20 * context.ownership_mult)
  return math.min(probability, max_probability);

end
