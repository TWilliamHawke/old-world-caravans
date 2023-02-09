---@param context QueryShouldWaylayCaravan
---@return boolean
function Old_world_caravans:segment_is_sea(context)
  local from_node = context:caravan():position():network():node_for_position(context:from());
  local region_name = from_node:region_key();

  return self.sea_nodes[region_name] == true;
end
