function Old_world_caravans:cleanup_encounter()
  local ok, err = pcall(function()
        local faction_key = cm:get_saved_value(self.encounter_faction_save_key);
        if not faction_key then return end
        local faction = cm:get_faction(faction_key);
        if faction:is_null_interface() then return end
        cm:kill_all_armies_for_faction(faction);
        self:log("encounter faction has been killed")
      end);

  if not ok then
    self:logCore(tostring(err));
  end

  cm:set_saved_value(self.encounter_faction_save_key, false);

  cm:disable_event_feed_events(false, "", "", "diplomacy_war_declared")
  cm:disable_event_feed_events(false, "", "", "character_dies_battle")
  cm:disable_event_feed_events(false, "wh_event_category_diplomacy", "", "");
  cm:disable_event_feed_events(false, "wh_event_category_character", "", "");
end
