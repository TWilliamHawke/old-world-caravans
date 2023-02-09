---@param region REGION_SCRIPT_INTERFACE
---@return string
function Old_world_caravans:get_culture_of_node(region)
  local region_name = region:name();

  return self.trade_nodes_to_culture[region_name] or self:get_culture_of_region(region);
end