---comment
---@param faction FACTION_SCRIPT_INTERFACE
function Old_world_caravans:faction_is_modded(faction)
  local faction_name = faction:name();
  local faction_sc = faction:subculture();
  local mod = self.other_mods[faction_name] or self.other_mods[faction_sc];

  if self:murranji_mod_is_active() and faction_sc == "wh3_main_sc_cth_cathay" then
    return true;
  end

  if not mod then
    return false;
  else
    return vfs.exists(mod);
  end
end