---comment
---@param list_of_regions string[]
---@return integer bandit_threat
function Old_world_caravans:calculate_bandit_threat(list_of_regions)
  if #list_of_regions == 0 then return 0 end
  local total_banditry_level = 0;
  local caravan_system = cm:model():world():caravans_system();

  for i = 1, #list_of_regions do
    local region_name = list_of_regions[i];
    local banditry_level = caravan_system:banditry_for_region_by_key(region_name);

    total_banditry_level = total_banditry_level + banditry_level;
  end

  local bandit_threat = math.floor(total_banditry_level / #list_of_regions);

  return bandit_threat
end
