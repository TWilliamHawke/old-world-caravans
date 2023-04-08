---@param subculture string
---@param key string
function Old_world_caravans:unlock_caravans_for_suculture(subculture, key)
  if cm:get_saved_value(self.is_init_save_key .. key) then return end
  local human_factions = cm:get_human_factions();
  if not human_factions then return end

  for i = 1, #human_factions do
    local faction = cm:get_faction(human_factions[i])
    if faction and faction:subculture() == subculture then
      self:unlock_caravan_recruitment(human_factions[i]);
    end
  end

  cm:set_saved_value(self.is_init_save_key .. key, true);
end
