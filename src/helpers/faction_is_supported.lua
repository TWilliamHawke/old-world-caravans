---@param faction FACTION_SCRIPT_INTERFACE
---@return boolean
function Old_world_caravans:faction_is_supported(faction)
  local sc = faction:subculture();
  local campaign = cm:get_campaign_name();
  if not self.supported_campaigns[campaign] then return false end
  if not self.award_types[sc] then return false end
  if self:faction_is_modded(faction) then return false end

  return true;
end