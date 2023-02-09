---comment
---@param list_of_regions string[]
---@return integer bandit_threat
function Old_world_caravans:calculate_bandit_threat(list_of_regions)
  local total_banditry_level = 0;
  if #list_of_regions == 0 then return 0 end

  for i = 1, #list_of_regions do
    local region_name = list_of_regions[i];
    local banditry_level = cm:model():world():caravans_system():banditry_for_region_by_key(region_name);
    --self:logCore("bandits in regon: " .. region_name .. ": " .. tostring(banditry_level));

    total_banditry_level = total_banditry_level + banditry_level;


  end


  local bandit_threat = math.floor(total_banditry_level / #list_of_regions);

  return bandit_threat
end