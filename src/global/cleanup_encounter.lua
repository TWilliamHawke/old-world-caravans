function Old_world_caravans:cleanup_encounter()
  local ok, err = pcall(function()
        local encounter_army = invasion_manager:get_invasion(self.invasion_key);
        if not encounter_army then return end
        encounter_army:kill(false);
        invasion_manager:remove_invasion(self.invasion_key)
        self:logCore("encounter faction has been killed")
      end);

  if not ok then
    self:logCore(tostring(err));
  end

  cm:disable_event_feed_events(false, "", "", "diplomacy_war_declared")
  cm:disable_event_feed_events(false, "", "", "character_dies_battle")
  cm:disable_event_feed_events(false, "wh_event_category_diplomacy", "", "");
  cm:disable_event_feed_events(false, "wh_event_category_character", "", "");

end
