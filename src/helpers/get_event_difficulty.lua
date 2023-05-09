---comment
---@param context CaravanWaylaid
---@return 1 | 2 | 3 event_difficulty
---@return integer
function Old_world_caravans:get_event_difficulty(context)
  local list_of_regions = self:get_regions_list(context) or {};
  local bandit_threat = self:calculate_bandit_threat(list_of_regions)
  local caravan = context:caravan()


  local force_cqi = caravan:caravan_force():command_queue_index();
  local caravan_cost = cm:force_gold_value(force_cqi)
  local additional_budget = 0;

  local banditary_dif = 1;
  local cost_dif = 1;

  if bandit_threat > 70 then
    banditary_dif = 3
  elseif bandit_threat > 40 then
    banditary_dif = 2;
  end

  if cm:random_number(6, 1) * 500 <= caravan_cost - 9000 then
    cost_dif = 3;
  elseif cm:random_number(5, 1) * 500 <= caravan_cost - 6000 then
    cost_dif = 2;
  end

  if caravan_cost > 12000 then
    additional_budget = math.floor((caravan_cost - 12000) * 0.7);
    self:log("additional_budget for encounter force is "..additional_budget)
  end

  return math.max(banditary_dif, cost_dif), additional_budget;
end
