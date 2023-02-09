function Old_world_caravans:hide_caravan_button_for_belegar()
  local player_faction = cm:get_local_faction();
  if player_faction:name() ~= self.belegar_faction then return end;
      self:logCore("first tick")
  if player_faction:has_effect_bundle("wh_dlc06_belegar_karak_owned_false_first") then
    --hide caravan button
    local caravan_button = find_uicomponent(core:get_ui_root(), "hud_campaign", "faction_buttons_docker", "button_caravan")

    if not caravan_button then
      self:logCore("caravan_button not found")
      else
        caravan_button:SetVisible(false)
      end;
  end

end
