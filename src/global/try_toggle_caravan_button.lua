---@param faction FACTION_SCRIPT_INTERFACE
---@param state boolean
function Old_world_caravans:try_toggle_caravan_button(faction, state)
  if not faction:is_human() then return end
  if state == true and self.disable_player_caravans then return end
  if cm:get_local_faction(true):name() ~= faction:name() then return end
  if self.access_to_caravans_on_first_turn[faction:name()] == nil then return end
  if faction:culture() == "wh3_main_cth_cathay" then return end
  if self:faction_is_modded(faction) then return end

  local caravan_button = find_uicomponent(core:get_ui_root(), "hud_campaign", "faction_buttons_docker", "button_caravan");

  if not caravan_button then return end
  caravan_button:SetVisible(state);
end
