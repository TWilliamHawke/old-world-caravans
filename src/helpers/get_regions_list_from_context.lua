---@param context CaravanWaylaid
---@return nil | string[]
function Old_world_caravans:get_regions_list_from_context(context)
  if context:from():is_null_interface() or context:to():is_null_interface() then
    return nil;
  end

  local regions = {}; ---@type string[]

  local from_node = context:caravan():position():network():node_for_position(context:from());
  local to_node = context:caravan():position():network():node_for_position(context:to());
  
  local route_segment = context:caravan():position():network():segment_between_nodes(
    from_node, to_node);

  if route_segment:is_null_interface() then
    return nil;
  end

  local list_of_regions = route_segment:regions();
	if list_of_regions:is_empty() then
    self:logCore("No Regions in an Ivory Road segment - Need to fix data in DaVE: campaign_map_route_segments")
    return nil;
  end

  for i = 0, list_of_regions:num_items() - 1 do
    local region_name = list_of_regions:item_at(i):region():name();
    table.insert(regions, region_name);
  end

  return regions;

end
