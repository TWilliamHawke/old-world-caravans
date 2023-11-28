---@diagnostic disable: redundant-parameter
---@param context Encounter_creator_context
---@return integer encounter_probability
function Old_world_caravans:local_trouble_creator(context)

  local caravan_master = context.caravan:caravan_master():character();
  local caravan_culture = context.faction:subculture();
  local cargo = context.caravan:cargo();
  local cargo_factor = math.floor(math.max(cargo - 500, 0) * 0.004);

  if cargo > 1200 then
    cargo_factor = cargo_factor * 2;
  end

  local culture_from = self:get_subculture_of_node(context.from);
  local culture_to = self:get_subculture_of_node(context.to);
  local dilemma_from = self.db.local_trouble_dilemmas[culture_from];
  local dilemma_to = self.db.local_trouble_dilemmas[culture_to];
  local character = context.caravan:caravan_master():character()

  if not dilemma_from and not dilemma_to then
    return 0;
  end

  if self:caravan_master_has_cultural_trait(caravan_master, culture_from) then
    return 0;
  end

  if self:caravan_master_has_cultural_trait(caravan_master, culture_to) then
    return 0;
  end

  local probability = math.ceil(context.bandit_threat / 5) + cargo_factor;

  if character:trait_points("owc_trait_grail_vow_caravan_cargo") == 1 then
    probability = 20
  end


  local max_probability = math.floor(25 * context.ownership_mult)
  return math.min(probability, max_probability);

end
