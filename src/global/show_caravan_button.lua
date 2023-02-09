function Old_world_caravans:show_caravan_button()
  local caravan_button = find_uicomponent(core:get_ui_root(), "hud_campaign", "faction_buttons_docker", "button_caravan")

  if not caravan_button then return end
  caravan_button:SetVisible(true)
end
