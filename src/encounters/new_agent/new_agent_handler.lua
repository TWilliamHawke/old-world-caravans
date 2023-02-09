---@param context CaravanWaylaid | CaravanMoved |QueryShouldWaylayCaravan
---@param event_string string
function Old_world_caravans:new_agent_handler(context, event_string)
  -- local event_data = event_string.
  local faction = context:faction();
  self:logCore("dilemma_name is "..event_string)

  local hero_unit = read_out_event_params(event_string)[1];
  local caravan_force = context:caravan():caravan_force();
  self:logCore("hero_unit is "..hero_unit)

  --ternary operator
  local choice = cm:random_number(2) > 1 and "A" or "B";
  local dilemma_name = "wh3_main_dilemma_cth_caravan_3"..choice;
  self:logCore("dilemma_name is "..dilemma_name)

  local dilemma_builder = cm:create_dilemma_builder(dilemma_name);
  local payload_builder = cm:create_payload();
  dilemma_builder:add_choice_payload("FIRST", payload_builder);

  if choice == "B" then
    payload_builder:treasury_adjustment(-500);
  end

  payload_builder:add_unit(caravan_force, hero_unit, 1, 0);
  dilemma_builder:add_choice_payload("SECOND", payload_builder);
  payload_builder:clear();

  dilemma_builder:add_target("default", caravan_force);
  cm:launch_custom_dilemma_from_builder(dilemma_builder, faction);

end