---@param context CaravanWaylaid
---@return encounter_diff event_difficulty
---@return integer additional_budget
function Old_world_caravans:get_event_difficulty(context)
  local list_of_regions = self:get_regions_list(context) or {};
  local bandit_threat = self:calculate_bandit_threat(list_of_regions)
  local caravan = context:caravan()


  local force_cqi = caravan:caravan_force():command_queue_index();
  local caravan_cost = cm:force_gold_value(force_cqi)
  local additional_budget = 0;

  local banditary_dif = 1; ---@type encounter_diff
  local cost_dif = 1; ---@type encounter_diff

  if bandit_threat > 70 then
    banditary_dif = 3;
  elseif bandit_threat > 40 then
    banditary_dif = 2;
  end

  local med_encounter_floor = 6500
  local hard_encounter_floor = 9500

  if cm:random_number(8, 1) * 500 <= caravan_cost - hard_encounter_floor then
    cost_dif = 3;
  elseif cm:random_number(5, 1) * 500 <= caravan_cost - med_encounter_floor then
    cost_dif = 2;
  end

  if caravan_cost > 12000 and cost_dif == 3 then
    additional_budget = math.floor((caravan_cost - 12000) * 0.7);
    self:log("additional_budget for encounter force is "..additional_budget)
  end

  return math.max(banditary_dif, cost_dif), additional_budget;
end
