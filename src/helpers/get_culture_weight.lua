---@param region_culture string
---@param caravan_culture string
---@return integer
function Old_world_caravans:get_culture_weight(region_culture, caravan_culture)
  local nodes_weight = self.node_culture_to_event_weight[caravan_culture];

  if not nodes_weight then return 0 end

  return nodes_weight[region_culture] or 0;
end;