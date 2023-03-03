---@param context CaravanWaylaid
function Old_world_caravans:new_agent_handler(context)
  -- local event_data = event_string.
  local faction = context:faction();
  local caravan = context:caravan();

  local start_node_agent, start_node_weight = self:get_agent_from_region(context:from(),caravan);
  local end_node_agent, end_node_weight = self:get_agent_from_region(context:to(), caravan);

  local weight_table = {
    [start_node_agent] = start_node_weight,
    [end_node_agent] = end_node_weight
  }

  local hero_unit = self:select_random_key_by_weight(weight_table, function (val)
    return val;
  end) or "wh3_main_ogr_cha_hunter_0";

  local caravan_force = context:caravan():caravan_force();
  self:log("hero_unit is "..hero_unit)

  local choice = cm:random_number(2) > 1 and "A" or "B";
  local dilemma_name = "wh3_main_dilemma_cth_caravan_3"..choice;

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

  attach_battle_to_dilemma(dilemma_name, caravan);

  cm:launch_custom_dilemma_from_builder(dilemma_builder, faction);

end