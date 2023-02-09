---comment
---@param bandit_threat integer
---@return 1 | 2 | 3 event_difficulty
function Old_world_caravans:get_event_difficulty(bandit_threat)
  if bandit_threat > 70 then
    return 3
  elseif bandit_threat > 40 then
    return 2;
  else
    return 1;
  end
end
