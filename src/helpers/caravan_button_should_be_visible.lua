---@param faction FACTION_SCRIPT_INTERFACE
function Old_world_caravans:caravan_button_should_be_visible(faction)
  if not faction:is_human() then return false end
  local faction_name = faction:name();
  local faction_sc = faction:subculture();

  if faction_sc == "wh3_main_sc_cth_cathay" then return true end

  local access_on_first_turn = self.access_to_caravans_on_first_turn[faction_name];

  if access_on_first_turn == true then
    return true
  elseif access_on_first_turn == false then
    if faction_name == self.belegar_faction then
      return not faction:has_effect_bundle("wh_dlc06_belegar_karak_owned_false_first")
    else
      return not not cm:get_saved_value(self.is_init_save_key..faction_name);
    end
  else
    return false
  end
end