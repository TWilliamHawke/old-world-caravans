---comment
---@param bandit_threat integer
---@param caravan CARAVAN_SCRIPT_INTERFACE
---@return 1 | 2 | 3 event_difficulty
function Old_world_caravans:get_event_difficulty(bandit_threat, caravan)
  function get_event_difficulty_banditary()
    if bandit_threat > 70 then
      return 3
    elseif bandit_threat > 40 then
      return 2;
    else
      return 1;
    end
  end

  function get_event_difficulty_cargo()
    if not self.scale_difficulty_cargo then return 1 end
    local cargo = caravan:cargo();

    if cm:random_number(10, 1) * 100 <= cargo - 1400 then
      return 2;
    else
      return 1;
    end
  end

  function get_event_difficulty_units()
    if not self.scale_difficulty_strenght then return 1 end
    local caravan_size = caravan:caravan_force():unit_list():num_items();

    if bandit_threat > 40 and cm:random_number(3, 1) <= caravan_size - 18 then
      return 3
    elseif cm:random_number(4, 1) <= caravan_size - 14 then
      return 2;
    else
      return 1;
    end
  end

  local cargo_dif = get_event_difficulty_cargo();
  local banditary_dif = get_event_difficulty_banditary();
  local units_dif = get_event_difficulty_units();

  return math.max(cargo_dif, banditary_dif, units_dif);
end
