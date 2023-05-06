---comment
---@param bandit_threat integer
---@param caravan CARAVAN_SCRIPT_INTERFACE
---@return 1 | 2 | 3 event_difficulty
function Old_world_caravans:get_event_difficulty(bandit_threat, caravan)
  local force_cqi = caravan:caravan_force():command_queue_index();
  local caravan_size = caravan:caravan_force():unit_list():num_items();
  local caravan_cost = cm:force_gold_value(force_cqi)

  local banditary_dif = 1;
  local units_dif = 1;
  local cost_dif = 1;

  if bandit_threat > 70 then
    banditary_dif = 3
  elseif bandit_threat > 40 then
    banditary_dif = 2;
  end

  if cm:random_number(3, 1) <= caravan_size - 18 then
    units_dif = 3
  elseif cm:random_number(5, 1) <= caravan_size - 13 then
    units_dif = 2;
  end

  if cm:random_number(6, 1) * 500 <= caravan_cost - 10000 then
    cost_dif = 3;
  elseif cm:random_number(6, 1) * 500 <= caravan_cost - 6500 then
    cost_dif = 2;
  end

  return math.max(banditary_dif, units_dif, cost_dif);
end
