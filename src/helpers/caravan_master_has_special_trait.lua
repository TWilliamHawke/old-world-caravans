---@param caravan_master CHARACTER_SCRIPT_INTERFACE
---@param region_culture string
---@return boolean
function Old_world_caravans:caravan_master_has_special_trait(caravan_master, region_culture)
  local caravan_culture = caravan_master:faction():subculture();
  local caravan_traits = self.culture_to_trait[caravan_culture];

  if not caravan_traits then return false end

  local cultural_trait = caravan_traits[region_culture];

  if not cultural_trait then return false end

  return caravan_master:has_skill(cultural_trait);


end;