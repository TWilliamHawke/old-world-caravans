---comment
---@param caravan CARAVAN_SCRIPT_INTERFACE
---@param enemy_cqi number
---@param dilemma_name string
---@param is_ambush boolean
---@param callback function | nil
function Old_world_caravans:bind_battle_to_dilemma(caravan, dilemma_name, enemy_cqi, is_ambush, callback)
  local caravan_faction = caravan:caravan_force():faction():name();
  local caravan_cqi = caravan:caravan_force():command_queue_index();
  local dilemma_listener_key = "owc_dilemma_" .. caravan_faction;
  core:remove_listener(dilemma_listener_key);

  ---@param context DilemmaChoiceMadeEvent
  local function encounterDilemmaChoice(context)
    local dilemma = context:dilemma();

    if dilemma_name ~= dilemma then return end
    local choice = context:choice();

    if choice == 0 then
      self:log("Start battle");
      cm:disable_event_feed_events(true, "", "", "character_dies_battle");
      cm:disable_event_feed_events(true, "wh_event_category_diplomacy", "", "");
      cm:disable_event_feed_events(true, "wh_event_category_character", "", "");

      cm:force_attack_of_opportunity(enemy_cqi, caravan_cqi, is_ambush);
    else
      self:cleanup_encounter();
      if callback then
        callback();
      end
      ---@diagnostic disable-next-line: undefined-field
      cm:move_caravan(caravan);
      self:log("Apply callback");
    end
  end

  core:add_listener(
    dilemma_listener_key,
    "DilemmaChoiceMadeEvent",
    true,
    function(context)
      local ok, err = pcall(function()
        encounterDilemmaChoice(context)
      end);

      if not ok then
        self:logCore(tostring(err));
        self:cleanup_encounter();
      end
    end,
    false
  );
end
