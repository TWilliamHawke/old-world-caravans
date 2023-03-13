---@diagnostic disable: redundant-parameter
---@param context Encounter_creator_context
---@return integer encounter_probability
function Old_world_caravans:local_trouble_creator(context)
  if cm:is_multiplayer() and cm:get_saved_value(self.encounter_faction_save_key) then
    return 0
  end

  local caravan_master = context.caravan:caravan_master():character();
  local caravan_faction = context.faction;

  local culture_from = self:get_culture_of_node(context.from);
  local culture_to = self:get_culture_of_node(context.to);
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

  local unfriendly_regions_count = 0;

  ---@param region REGION_SCRIPT_INTERFACE
  ---@return boolean
  local function region_is_friendly(region)
    local region_owner = region:owning_faction();

    if region_owner:name() == caravan_faction:name() then
      return true;
    end

    if region_owner:allied_with(caravan_faction) then return true end

    if caravan_faction:subculture() == "wh_main_sc_emp_empire" and not region_owner:pooled_resource_manager():resource("emp_loyalty"):is_null_interface() then
      local loyalty = region_owner:pooled_resource_manager():resource("emp_loyalty"):value();

      if loyalty > 1 then return true end
    end
    return false;
  end

  for i = 0, context.list_of_regions:num_items() - 1 do
    local region = context.list_of_regions:item_at(i):region();

    if not region_is_friendly(region) then
      unfriendly_regions_count = unfriendly_regions_count + 1;
    end
  end

  local regions_count = context.list_of_regions:num_items();

  local probability_mult = regions_count > 0
      and unfriendly_regions_count / regions_count or 1;

  local probability = math.ceil(context.bandit_threat * probability_mult / 10);

  return probability
end
