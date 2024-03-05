---@param faction FACTION_SCRIPT_INTERFACE
---@return boolean
function Old_world_caravans:faction_is_supported(faction)
  local sc = faction:subculture();
  if not self.award_types[sc] then return false end
  if self:faction_is_modded(faction) then return false end

  return true;
end