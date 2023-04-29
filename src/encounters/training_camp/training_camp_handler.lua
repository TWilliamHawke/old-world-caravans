---@param context CaravanWaylaid
function Old_world_caravans:training_camp_handler(context)
  local dilemma_name = "wh3_dlc23_dilemma_chd_convoy_training_camp";
  local caravan = context:caravan();
  local faction = context:faction()

  ---@type Prebattle_caravan_data
  local prebattle_data = {
    caravan = caravan,
    dilemma_name = dilemma_name,
    enemy_force_cqi = -1,
  }

  self:bind_battle_to_dilemma(prebattle_data, 0, function()
  end)

  local dilemma_builder = cm:create_dilemma_builder(dilemma_name);
  local payload_builder = cm:create_payload();

  local experience = cm:create_new_custom_effect_bundle("wh3_dlc23_dilemma_chd_convoy_experience");
  experience:add_effect("wh2_main_effect_captives_unit_xp", "force_to_force_own", 2000);
  experience:set_duration(1);

  payload_builder:effect_bundle_to_force(caravan:caravan_force(), experience);
  payload_builder:text_display("dummy_convoy_training_camp_first");
  dilemma_builder:add_choice_payload("FIRST", payload_builder);
  payload_builder:clear();

  payload_builder:text_display("dummy_convoy_training_camp_second");
  dilemma_builder:add_choice_payload("SECOND", payload_builder);

  dilemma_builder:add_target("default", caravan:caravan_force());

  cm:launch_custom_dilemma_from_builder(dilemma_builder, faction);
end
