function Old_world_caravans:hide_caravan_button_without_access()
  local faction = cm:get_local_faction(true);
  local faction_name = faction:name();
  if self.access_to_caravans_on_first_turn[faction_name] == nil then return end

  if self:faction_is_modded(faction) then return end
  if not self:faction_has_caravans(faction) then return end
  if self:caravan_button_should_be_visible(faction) then return end

  local caravan_button = find_uicomponent(core:get_ui_root(),
  "hud_campaign", "faction_buttons_docker", "button_caravan")

  if not caravan_button then
    self:log("caravan_button not found")
  else
    caravan_button:SetVisible(false)
    self:log("hide caravan button")
  end
end
