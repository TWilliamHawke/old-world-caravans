---@param list_of_regions string[]
---@param caravan_owner FACTION_SCRIPT_INTERFACE
---@return table<string, integer> evil_faction_threat
---@return table<string, string> threated_regions
function Old_world_caravans:calculate_evil_faction_threat(list_of_regions, caravan_owner)
  local evil_threat = {}; ---@type table<string, integer>
  local threated_regions = {}; ---@type table<string, string>

  for i = 1, #list_of_regions do
    local region_name = list_of_regions[i];
    local region = cm:model():world():region_data_for_key(region_name):region();

    local region_owner = region:owning_faction();
    local owner_subculture = self:get_subculture_of_region(region);
    local threat_mult = self.threat_weight_by_culture[owner_subculture] or 1;

    local region_threats = self.threats[region_name];

    if region_threats then
      for culture, threat in pairs(region_threats) do
        self:increment_value_in_table(evil_threat, culture, threat);
        threated_regions[culture] = region_name;
      end
    end

    for corruption_type, culture in pairs(self.coruption_to_culture) do
      local corruption_level = cm:get_corruption_value_in_region(region, corruption_type);
      local threat_add = math.ceil(corruption_level / 35);

      if threat_add > 0 then
        threated_regions[culture] = region_name;
      end

      if threat_add > 0 and corruption_type == "wh3_main_corruption_vampiric" then
        if evil_threat.wh2_dlc11_sc_cst_vampire_coast then
          culture = "wh2_dlc11_sc_cst_vampire_coast"
        end
      end

      self:increment_value_in_table(evil_threat, culture, threat_add);
    end

    if self.threat_weight_by_culture[owner_subculture] then
      self:increment_value_in_table(evil_threat, owner_subculture, threat_mult);
      threated_regions[owner_subculture] = region_name;

      ---@diagnostic disable-next-line: redundant-parameter
      if region_owner:at_war_with(caravan_owner) then
        self:increment_value_in_table(evil_threat, owner_subculture, 2);
      end
    end

  end

  return evil_threat, threated_regions
end
