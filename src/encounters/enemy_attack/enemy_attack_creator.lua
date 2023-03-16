---@param context Encounter_creator_context
---@return integer encounter_probability
function Old_world_caravans:enemy_attack_creator(context)
  if cm:is_multiplayer() and cm:get_saved_value(self.encounter_faction_save_key) then
    return 0;
  end

  local cargo_factor = math.floor(context.caravan:cargo() * self.cargo_threat_mult);
  local probability = math.ceil((context.bandit_threat + cargo_factor) / 6) + 5;
  return math.min(probability, 20);

end
