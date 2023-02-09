---@param context CaravanWaylaid
---@param event_string string
function Old_world_caravans:shortcut_handler(context, event_string)
  local type = cm:random_number(2) > 1 and "A" or "B";
  local dilemma_name = "wh3_main_dilemma_cth_caravan_1" .. type;
  self:logCore("dilemma_name is "..dilemma_name)
  core:remove_listener("caravan_moved_no_cathay");

  local caravan = context:caravan();

  attach_battle_to_dilemma(
    dilemma_name,
    caravan,
    nil,
    false,
    nil,
    nil,
    nil,
    function()
      ---@diagnostic disable-next-line: undefined-field
      cm:move_caravan(caravan);
    end);

    self:logCore("battle has attached, goto dilemma builder")
    local dilemma_builder = cm:create_dilemma_builder(dilemma_name);
    local payload_builder = cm:create_payload();

    local scout_skill = caravan:caravan_master():character():bonus_values():scripted_value("caravan_scouting", "value")
    dilemma_builder:add_choice_payload("FIRST", payload_builder);
    payload_builder:clear();

    payload_builder:treasury_adjustment(math.floor(-500 * ((100 + scout_skill) / 100)));
    dilemma_builder:add_choice_payload("SECOND", payload_builder);

    dilemma_builder:add_target("default", caravan:caravan_force());
    self:logCore("dilemma_builder is finished, launch the dilemma")

    out.design("Triggering dilemma:" .. dilemma_name)
    cm:launch_custom_dilemma_from_builder(dilemma_builder, caravan:caravan_force():faction());

end
