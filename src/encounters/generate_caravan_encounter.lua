---@param context QueryShouldWaylayCaravan
function Old_world_caravans:generate_caravan_encounter(context)
  if self.encounter_should_be_canceled then
    cm:set_saved_value(self.encounter_was_canceled_key, true)
    self.encounter_should_be_canceled = false;
    self:log("encounter was canceled")
    return
  end

  local region_names, list_of_regions = self:get_regions_list(context);
  if not region_names then return end


  local caravan = context:caravan();
  local caravan_master = context:caravan_master():character();
  local faction = context:faction();
  local start_region = self:get_region_by_node(caravan, context:from());
  local end_region = self:get_region_by_node(caravan, context:to());
  local bandit_threat = self:calculate_bandit_threat(region_names);
  local ownership_mult = self:calculate_ownership_mult(list_of_regions, faction)

  ---@type Encounter_creator_context
  local conditions = {
    caravan = caravan,
    caravan_master = caravan_master,
    list_of_regions = list_of_regions,
    bandit_threat = bandit_threat,
    faction = faction,
    from = start_region,
    to = end_region,
    ownership_mult = ownership_mult,
  };

  local no_encounter_weight = self.no_encounter_weight / 2;

  if cm:get_saved_value(self.encounter_was_canceled_key) then
    no_encounter_weight = 0;
    cm:set_saved_value(self.encounter_was_canceled_key, false)
  end

  local weight_table = {
    nothing = no_encounter_weight,
  }

  for _, encounter in ipairs(self.encounters) do
    local encounter_creator = encounter .. "_creator";
    local encounter_handler = encounter .. "_handler";

    if type(self[encounter_handler]) == "function" then
    else
      self:log(encounter_handler .. " is not a function")
    end

    if type(self[encounter_creator]) == "function" then
      local probability = self[encounter_creator](self, conditions)
      self:log("probability for " .. encounter .. " is " .. probability);
      weight_table[encounter] = probability;
    else
      self:log(encounter_creator .. " is not a function")
    end
  end

  local selected_encounter = self:select_random_key_by_weight(weight_table, function(val)
        return val;
      end, true) or "nothing";

  if self.override_encounters then
    selected_encounter = self.default_encounter
  end

  self:log("selected_encounter is " .. selected_encounter)
  if selected_encounter == "nothing" then return end

  ---@diagnostic disable-next-line: redundant-parameter
  context:flag_for_waylay("owc_"..selected_encounter)
end
