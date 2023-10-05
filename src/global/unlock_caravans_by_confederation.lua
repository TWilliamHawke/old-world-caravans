---@param faction FACTION_SCRIPT_INTERFACE
---@param other_faction FACTION_SCRIPT_INTERFACE
function Old_world_caravans:unlock_caravans_by_confederation(faction, other_faction)
  if not self:faction_has_caravans(faction) then return end
  if self:caravan_button_should_be_visible(faction) then return end
  if faction:name() == self.belegar_faction then return end

  local other_name = other_faction:name();

  if self.access_to_caravans_on_first_turn[other_name] then
    if cm:get_local_faction(true):name() == faction:name() then
      self:show_caravan_button();
    end
    cm:set_saved_value(self.is_init_save_key .. faction:name(), true)

    local caravans_list = cm:model():world():caravans_system():faction_caravans(faction);
    if caravans_list:is_null_interface() then return end
    local available_caravans = caravans_list:available_caravan_recruitment_items();

    if available_caravans:is_empty() then
      self:unlock_caravan_recruitment(faction:name())
    end
  end

end