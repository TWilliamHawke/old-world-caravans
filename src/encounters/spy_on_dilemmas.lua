---@diagnostic disable: undefined-field
---@param caravan CARAVAN_SCRIPT_INTERFACE
---@param encounter_callback fun()
function Old_world_caravans:spy_on_dilemmas(caravan, encounter_callback)
  if caravan:caravan_force():faction():subculture() ~= "wh_main_sc_emp_empire" or cm:is_multiplayer() then
    encounter_callback();
    return
  end

  core:add_listener("owc_any_dilemma_triggered",
    "DilemmaIssuedEvent",
    true,
    function()
      cm:move_caravan(caravan);
      cm:disable_event_feed_events(true, "wh_event_category_diplomacy", "", "");
      cm:disable_event_feed_events(true, "wh_event_category_character", "", "");
      cm:remove_callback(self.dilemma_callback_key);
      self:cleanup_encounter();
      cm:set_saved_value(self.encounter_was_canceled_key, true)
      self:log("encounter was canceled")
    end,
    false);

  cm:callback(function()
    cm:disable_event_feed_events(true, "wh_event_category_diplomacy", "", "");
    cm:disable_event_feed_events(true, "wh_event_category_character", "", "");
    core:remove_listener("owc_any_dilemma_triggered");
    encounter_callback();
  end, 1, self.dilemma_callback_key)
end
