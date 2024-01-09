---@param dilemma_name string
---@param caravan CARAVAN_SCRIPT_INTERFACE
---@param callback_choice integer | nil
---@param callback function | nil
function Old_world_caravans:bind_callback_to_dilemma(dilemma_name, caravan, callback_choice, callback)
  local caravan_faction = caravan:caravan_force():faction():name();
  local dilemma_listener_key = "owc_dilemma_" .. caravan_faction;

  core:add_listener(
    dilemma_listener_key,
    "DilemmaChoiceMadeEvent",
    function(context)
      return context:dilemma() == dilemma_name
    end,
    function(context)
      local faction = context:faction();
      local faction_key = faction:name();
      local choice = context:choice();
      core:remove_listener("owc_dilemma_" .. faction_key);

      ---@diagnostic disable-next-line: undefined-field
      cm:move_caravan(caravan);

      if callback and callback_choice == choice then
        callback();
      end
    end,
    true
  );
end;
