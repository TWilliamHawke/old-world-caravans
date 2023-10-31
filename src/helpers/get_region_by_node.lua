---@param caravan CARAVAN_SCRIPT_INTERFACE
---@param node_position ROUTE_POSITION_SCRIPT_INTERFACE
---@return REGION_SCRIPT_INTERFACE region
function Old_world_caravans:get_region_by_node(caravan, node_position)
  local node = caravan:position():network():node_for_position(node_position);
  return node:region_data():region();
end