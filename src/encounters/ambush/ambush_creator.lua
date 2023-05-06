---@param context Encounter_creator_context
---@return integer encounter_probability
function Old_world_caravans:ambush_creator(context)
  local caravan_force = context.caravan:caravan_force();
  local agents_count = caravan_force:character_list():num_items();
  local units_count = caravan_force:unit_list():num_items();

  if units_count - agents_count < 1 then return 0 end

  local cargo_factor = math.floor(context.caravan:cargo() * self.cargo_threat_mult);
  local probability = math.ceil((context.bandit_threat + cargo_factor) / 10) + 3;

  if context.caravan:caravan_master():character():has_skill("wh3_main_skill_cth_caravan_master_scouts") then
    probability = math.floor(probability / 2)
  end;
  local max_probability = math.floor(12 * context.ownership_mult);

  if caravan_force:has_effect_bundle("owc_caravan_exhausted_guards") then
    probability = probability * 2;
    max_probability = max_probability * 2;
  end

  return math.min(probability, max_probability);
end
