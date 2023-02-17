---@param context Encounter_creator_context
---@return integer encounter_probability
function Old_world_caravans:ambush_creator(context)
  local cargo_factor = math.floor(context.caravan:cargo() * self.cargo_threat_mult);
  local probability = math.ceil((context.bandit_threat + cargo_factor) / 20) + 3;

  return probability;
end;