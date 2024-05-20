---@param faction FACTION_SCRIPT_INTERFACE
function Old_world_caravans:hide_caravan_button_without_access(faction)
  local faction_name = faction:name();
  if self.access_to_caravans_on_first_turn[faction_name] == nil then return end

  if not self:faction_is_supported(faction) then return end

  if self:caravan_button_should_be_hidden(faction) then
    self:trigger_toggle_button_event(faction, false)
  end
end
