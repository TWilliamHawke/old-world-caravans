---@param faction_name string
function Old_world_caravans:cleanup_encounter_for_faction(faction_name)
  local save_key = self.encounter_faction_save_key..faction_name;
  local ok, err = pcall(function()
    local encounter_army_cqi = cm:get_saved_value(save_key);
    if not encounter_army_cqi then return end
    local force = cm:get_military_force_by_cqi(encounter_army_cqi);
    if not force or force:is_null_interface() then return end
    cm:kill_character(force:general_character():cqi(), true);

    self:log("encounter faction for "..faction_name.." has been killed")
  end);

  if not ok then
    self:logCore(tostring(err));
  end

  cm:set_saved_value(save_key, false);

  cm:callback(function()
    cm:disable_event_feed_events(false, "", "", "diplomacy_faction_destroyed");
    cm:disable_event_feed_events(false, "", "", "character_dies_battle");
    cm:disable_event_feed_events(false, "wh_event_category_diplomacy", "", "");
    cm:disable_event_feed_events(false, "wh_event_category_character", "", "");
  end, 0.2)

end