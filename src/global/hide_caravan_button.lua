function Old_world_caravans:hide_caravan_button_for_belegar()
  local faction = cm:get_local_faction();
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
