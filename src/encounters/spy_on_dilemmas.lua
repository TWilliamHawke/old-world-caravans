---@diagnostic disable: undefined-field
---@param caravan CARAVAN_SCRIPT_INTERFACE
---@param enemy_cqi number
---@param encounter_callback fun()
function Old_world_caravans:spy_on_dilemmas(caravan, enemy_cqi, encounter_callback)
  core:remove_listener("owc_any_dilemma_triggered");
  core:remove_listener("owc_dillemma_choice_spy_on");

  if cm:is_multiplayer() then
    encounter_callback();
    return
  end

  core:add_listener("owc_any_dilemma_triggered",
    "DilemmaIssuedEvent",
    true,
    function()
      core:remove_listener("owc_dillemma_choice_spy_on")
      core:remove_listener("owc_any_mission_triggered");
      cm:remove_callback(self.dilemma_callback_key);
      --self:cleanup_encounter_for_faction(caravan:caravan_force():faction():name());
      --cm:set_saved_value(self.encounter_was_canceled_key, true)
      self:log("encounter was suspended")

      core:add_listener(
        "owc_dillemma_choice_spy_on",
        "DilemmaChoiceMadeEvent",
        true,
        function()
          self:spy_on_dilemmas(caravan, enemy_cqi, encounter_callback)
        end,
        false
      );
    end,
    false);


  core:add_listener("owc_any_mission_triggered",
    "MissionIssued",
    ---@param context MissionIssued
    function(context)
      local mission_name = context:mission():mission_record_key()
      return string.find(mission_name, "_qb_")
    end,
    function(context)
      core:remove_listener("owc_any_dilemma_triggered");
      core:remove_listener("owc_dillemma_choice_spy_on")
      cm:move_caravan(caravan);
      cm:disable_event_feed_events(true, "wh_event_category_diplomacy", "", "");
      cm:disable_event_feed_events(true, "wh_event_category_character", "", "");
      cm:remove_callback(self.dilemma_callback_key);
      self:cleanup_encounter_for_faction(caravan:caravan_force():faction():name());
      cm:set_saved_value(self.encounter_was_canceled_key, true)
      self:log("encounter was canceled")
    end,
    false);

  cm:callback(function()
    local enemy_force = cm:get_military_force_by_cqi(enemy_cqi);
    if not enemy_force or enemy_force:is_null_interface() then
      self:log("enemy army not found! cancel the encounter")
      cm:move_caravan(caravan);
      cm:set_saved_value(self.encounter_was_canceled_key, true)
      return
    end

    cm:disable_event_feed_events(true, "wh_event_category_diplomacy", "", "");
    cm:disable_event_feed_events(true, "wh_event_category_character", "", "");
    core:remove_listener("owc_any_mission_triggered");
    core:remove_listener("owc_any_dilemma_triggered");
    core:remove_listener("owc_dillemma_choice_spy_on");
    encounter_callback();
  end, 1, self.dilemma_callback_key)
end
