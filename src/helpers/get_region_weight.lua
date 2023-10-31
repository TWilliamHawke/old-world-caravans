---@param region_culture string
---@param caravan_master CHARACTER_SCRIPT_INTERFACE
---@return integer
function Old_world_caravans:get_region_weight(region_culture, caravan_master)
  local caravan_culture = caravan_master:faction():subculture();
  local culture_weight = self:get_culture_weight(region_culture, caravan_culture);

  if self:caravan_master_has_cultural_trait(caravan_master, region_culture) then
    culture_weight = culture_weight * 10;
  end

  return culture_weight;
end