---@param faction FACTION_SCRIPT_INTERFACE
function Old_world_caravans:caravan_button_should_be_visible(faction)
  if not faction:is_human() then return false end
  if self:faction_is_modded(faction) then return true end
  local faction_name = faction:name();
  local subculture = faction:subculture();

  if not self.start_units[subculture] then return true end

  if self.other_mods[faction_name] and cm:get_campaign_name() == "wh3_main_chaos" then
    return false
  end

  local access_on_first_turn = self.access_to_caravans_on_first_turn[faction_name];

  if access_on_first_turn == true then
    return true
  elseif access_on_first_turn == false then
    if self.force_enable then
      return true
    end

    if faction_name == self.belegar_faction then
      return not not cm:get_saved_value(self.is_init_save_key..faction_name) or not faction:has_effect_bundle("wh_dlc06_belegar_karak_owned_false_first")
    else
      return not not cm:get_saved_value(self.is_init_save_key..faction_name);
    end
  else
    return false
  end
end
