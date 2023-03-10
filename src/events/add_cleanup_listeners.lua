function Old_world_caravans:add_cleanup_listeners()
  core:add_listener(
    "owc_encounter_faction_cleanup",
    "BattleCompleted",
    function()
      return cm:get_saved_value(self.encounter_faction_save_key);
    end,
    function()
      cm:callback(
        function()
          self:cleanup_encounter()
        end, 0.5, self.cleanup_encounter_debounce_key
      )
    end,
    true
  );

  core:add_listener(
    "owc_EndOfRound_encounter_faction_cleanup",
    "EndOfRound",
    function()
      return cm:get_saved_value(self.encounter_faction_save_key);
    end,
    function()
      self:cleanup_encounter();
    end,
    true
  );


end;