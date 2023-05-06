---@param context CaravanWaylaid
function Old_world_caravans:friendly_caravan_handler(context)
  local dilemma_name = "owc_main_dilemma_friendly_caravan";
  local caravan = context:caravan()
  local caravan_faction = context:faction()

  local prebattle_data = {
    caravan = caravan,
    dilemma_name = dilemma_name,
    enemy_force_cqi = -1,
  }


  self:bind_battle_to_dilemma(prebattle_data, 0, function()
    ---@diagnostic disable-next-line: undefined-field
    cm:move_caravan(caravan);
    self:increase_caravan_cargo(caravan, -200)
  end)

  local dilemma_builder = cm:create_dilemma_builder(dilemma_name);
  local payload_builder = cm:create_payload();

  local cargo_bundle = cm:create_new_custom_effect_bundle("wh3_main_dilemma_cth_caravan_2_b");
  cargo_bundle:add_effect("wh3_main_effect_caravan_cargo_DUMMY", "force_to_force_own", -200);
  cargo_bundle:set_duration(0);

  payload_builder:faction_ancillary_gain(caravan_faction, "owc_main_anc_enchanted_item_jar_of_all_souls")
  payload_builder:effect_bundle_to_force(caravan:caravan_force(), cargo_bundle);
  dilemma_builder:add_choice_payload("FIRST", payload_builder);

  payload_builder:clear();

  payload_builder:text_display("dummy_convoy_power_overwhelming_second");
  dilemma_builder:add_choice_payload("SECOND", payload_builder);


  cm:launch_custom_dilemma_from_builder(dilemma_builder, caravan_faction);

end
