---@param faction FACTION_SCRIPT_INTERFACE
---@return boolean
function Old_world_caravans:faction_has_caravans(faction)
  local access = self.access_to_caravans_on_first_turn[faction:name()];
  if access == nil then return false end
  local caravans_list = cm:model():world():caravans_system():faction_caravans(faction);
  return not caravans_list:is_null_interface();
end