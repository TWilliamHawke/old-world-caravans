function Old_world_caravans:start_callback_race()
  if not self.debug_mode then return end
  self:cleanup_encounter();

  core:add_listener(
    "owc_callback_war",
    "BattleCompleted",
    function()
      return true
    end,
    function()
      cm:callback(
        function()
          cm:remove_callback(self.cleanup_encounter_debounce_key);
          core:remove_listener("owc_callback_war");
        end, 0.2
      )
    end,
    false
  );


end