---@param context CaravanWaylaid
function Old_world_caravans:shortcut_handler(context)
  local type = cm:random_number(2, 1) > 1 and "A" or "B";
  local dilemma_name = "wh3_main_dilemma_cth_caravan_1" .. type;
  self:log("dilemma_name is " .. dilemma_name)

  local caravan = context:caravan();

  self:bind_callback_to_dilemma(dilemma_name, caravan, 1, function()
    ---@diagnostic disable-next-line: undefined-field
    cm:move_caravan(caravan);
  end)

  local dilemma_builder = cm:create_dilemma_builder(dilemma_name);
  local payload_builder = cm:create_payload();

  local scout_skill = caravan:caravan_master():character():bonus_values():scripted_value("caravan_scouting", "value")
  payload_builder:text_display("dummy_convoy_guide_first")
  dilemma_builder:add_choice_payload("FIRST", payload_builder);
  payload_builder:clear();

  payload_builder:treasury_adjustment(math.floor(-500 * ((100 + scout_skill) / 100)));
  payload_builder:text_display("dummy_convoy_guide_second")
  dilemma_builder:add_choice_payload("SECOND", payload_builder);

  dilemma_builder:add_target("default", caravan:caravan_force());

  cm:launch_custom_dilemma_from_builder(dilemma_builder, caravan:caravan_force():faction());
end
