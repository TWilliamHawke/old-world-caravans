---@param context Encounter_creator_context
---@return integer encounter_probability
function Old_world_caravans:enemy_attack_creator(context)

  local cargo_factor = math.floor(context.caravan:cargo() * self.cargo_threat_mult);
  local probability = math.ceil((context.bandit_threat + cargo_factor) / 3) + 8;
  local max_probability = math.floor(30 * context.ownership_mult)
  return math.min(probability, max_probability);

end
