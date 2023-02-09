---@param region REGION_SCRIPT_INTERFACE
---@return string
function Old_world_caravans:get_culture_of_region(region)
  local region_owner = region:owning_faction();
  if region:is_abandoned() or region_owner:is_null_interface() then
    return "wh2_main_sc_skv_skaven";
  end
  return region_owner:subculture();
end