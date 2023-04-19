---@diagnostic disable: redundant-parameter
---@param context Encounter_creator_context
---@return integer encounter_probability
function Old_world_caravans:local_trouble_creator(context)

  local caravan_master = context.caravan:caravan_master():character();

  local culture_from = self:get_subculture_of_node(context.from);
  local culture_to = self:get_subculture_of_node(context.to);
  local dilemma_from = self.db.local_trouble_dilemmas[culture_from];
  local dilemma_to = self.db.local_trouble_dilemmas[culture_to];

  if not dilemma_from or not dilemma_to then
    return 0;
  end

  if self:caravan_master_has_special_trait(caravan_master, culture_from) then
    return 0;
  end

  if self:caravan_master_has_special_trait(caravan_master, culture_to) then
    return 0;
  end


  local probability = math.ceil(context.bandit_threat / 6);

  local max_probability = math.floor(20 * context.ownership_mult)
  return math.min(probability, max_probability);

end
