---@param faction FACTION_SCRIPT_INTERFACE
function Old_world_caravans:caravan_button_should_be_visible(faction)
  if not faction:is_human() then return false end
  if not self:faction_is_supported(faction) then return true end
  local faction_name = faction:name();

  local access_on_first_turn = self.access_to_caravans_on_first_turn[faction_name] or
      (cm:get_campaign_name() == "cr_oldworld" and self.access_to_caravans_old_world_override[faction_name]);

  if access_on_first_turn == true or self.force_enable then
    return true
  end

  if faction_name == self.belegar_faction then
    return not not cm:get_saved_value(self.is_init_save_key .. faction_name) or
        not faction:has_effect_bundle("wh_dlc06_belegar_karak_owned_false_first")
  else
    --confederation flag check
    return not not cm:get_saved_value(self.is_init_save_key .. faction_name);
  end
  return false
end
