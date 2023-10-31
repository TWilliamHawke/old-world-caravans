---@param context QueryShouldWaylayCaravan
---@return nil | boolean, string | nil
function Old_world_caravans:generate_caravan_encounter(context)
  if self.encounter_should_be_canceled then
    cm:set_saved_value(self.encounter_was_canceled_key, true)
    self.encounter_should_be_canceled = false;
    self:log("encounter was canceled")
    return
  end

  if self.override_encounters then
    local result = self:handler_is_exists(self.default_encounter);
    return result, self.default_encounter;
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
  local caravan_health = 0.5 + cm:military_force_average_strength(caravan:caravan_force()) / 200; --[0.5, 1]

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

  local weight_table = {
    nothing = self.no_encounter_weight,
  }

  if cm:get_saved_value(self.encounter_was_canceled_key) then
    weight_table.nothing = 0;
    cm:set_saved_value(self.encounter_was_canceled_key, false)
  end

  self:log("probability for no encounter is " .. tostring(weight_table.nothing));

  for i = 1,  #self.encounters do
    local encounter = self.encounters[i];
    local encounter_creator = encounter .. "_creator";

    if not self:handler_is_exists(encounter) then
      self:log(encounter .. "_handler is not a function")
    end

    if type(self[encounter_creator]) == "function" then
      local probability = self[encounter_creator](self, conditions)

      if self.combat_encounters[encounter] then
        probability = math.floor(probability * self.combat_encounter_chance * caravan_health)
      end

      self:log("probability for " .. encounter .. " is " .. probability);
      weight_table[encounter] = probability;
    else
      self:log(encounter_creator .. " is not a function")
    end
  end

  local selected_encounter = self:select_random_key_by_weight(weight_table, function(val)
    return val;
  end, true) or "nothing";

  local result = self:handler_is_exists(selected_encounter);

  return result, selected_encounter;
end
