---@param region REGION_SCRIPT_INTERFACE
---@param caravan_master CHARACTER_SCRIPT_INTERFACE
---@return string
---@return integer
function Old_world_caravans:get_agent_from_region(region, caravan_master)
  local caravan_culture = caravan_master:faction():subculture();
  local region_culture = self:get_culture_of_node(region);
  local culture_weight = self:get_culture_weight(region_culture, caravan_culture);
  local agent = self.culture_to_agent_subtype[region_culture];

  if not agent or region_culture == caravan_culture then
    return "", 0;
  end;

  if self:caravan_master_has_special_trait(caravan_master, region_culture) then
    culture_weight = culture_weight * 10;
  end

  return agent, culture_weight
end;