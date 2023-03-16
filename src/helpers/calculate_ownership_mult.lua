---comment
---@param list_of_regions REGION_DATA_LIST_SCRIPT_INTERFACE
---@param caravan_faction FACTION_SCRIPT_INTERFACE
---@return number
function Old_world_caravans:calculate_ownership_mult(list_of_regions, caravan_faction)
  local ownership_mult = 0;
  if list_of_regions:num_items() < 1 then
    return 1;
  end

  local function get_region_mult(region)
    local region_owner = region:owning_faction();

    if region_owner:name() == caravan_faction:name() then
      return 0.5;
    end

    if region_owner:allied_with(caravan_faction) then return 0.75 end

    if caravan_faction:subculture() == "wh_main_sc_emp_empire" and not region_owner:pooled_resource_manager():resource("emp_loyalty"):is_null_interface() then
      local loyalty = region_owner:pooled_resource_manager():resource("emp_loyalty"):value();

      if loyalty > 7 then return 0.75 end
    end
    return 1;
  end


  for i = 0, list_of_regions:num_items() - 1 do
    local region = list_of_regions:item_at(i):region();
    ownership_mult = ownership_mult + get_region_mult(region)
  end

  return ownership_mult / list_of_regions:num_items();

end