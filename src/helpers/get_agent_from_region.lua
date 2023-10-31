---@param node ROUTE_POSITION_SCRIPT_INTERFACE
---@param caravan CARAVAN_SCRIPT_INTERFACE
---@return string
---@return integer
function Old_world_caravans:get_agent_from_region(node, caravan)
  local region = self:get_region_by_node(caravan, node);
  local caravan_master = caravan:caravan_master():character();
  local caravan_culture = caravan_master:faction():subculture();
  local region_culture = self:get_subculture_of_node(region);
  local culture_weight = self:get_culture_weight(region_culture, caravan_culture);
  local agent = self.culture_to_agent_unit[region_culture];

  if not agent or region_culture == caravan_culture then
    return "", 0;
  end;

  if self:caravan_master_has_cultural_trait(caravan_master, region_culture) then
    culture_weight = culture_weight * 10;
  end

  return agent, culture_weight
end;