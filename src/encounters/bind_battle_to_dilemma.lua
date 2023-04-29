---@param prebattle_data Prebattle_caravan_data
---@param callback function
---@param callback_choice integer
function Old_world_caravans:bind_battle_to_dilemma(prebattle_data, callback_choice, callback)
  local caravan = prebattle_data.caravan;
  local caravan_faction = caravan:caravan_force():faction():name();
  local caravan_cqi = caravan:caravan_force():command_queue_index();
  local dilemma_listener_key = "owc_dilemma_" .. caravan_faction;
  core:remove_listener(dilemma_listener_key);

  ---@param context DilemmaChoiceMadeEvent
  local function encounterDilemmaChoice(context)
    local dilemma = context:dilemma();

    if prebattle_data.dilemma_name ~= dilemma then return end
    local choice = context:choice();

    if choice == callback_choice then
      callback();
      self:log("Apply callback");
    end

    if choice == 0 and prebattle_data.enemy_force_cqi > 0 then
      self:teleport_caravan_to_position(caravan, prebattle_data.x, prebattle_data.y);
      cm:disable_event_feed_events(true, "", "", "character_dies_battle");
      cm:disable_event_feed_events(true, "wh_event_category_diplomacy", "", "");
      cm:disable_event_feed_events(true, "wh_event_category_character", "", "");

      self:log("Start battle");
      cm:force_attack_of_opportunity(prebattle_data.enemy_force_cqi, caravan_cqi, prebattle_data.is_ambush);
    elseif choice == 1 then
      self:cleanup_encounter_for_faction(caravan_faction);
      ---@diagnostic disable-next-line: undefined-field
      cm:move_caravan(caravan);

      if cm:model():combined_difficulty_level() == -3 then
        cm:save();
      end
    end
  end

  core:add_listener(
    dilemma_listener_key,
    "DilemmaChoiceMadeEvent",
    true,
    function(context)
      encounterDilemmaChoice(context)
    end,
    false
  );
end
