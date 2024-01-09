---@param context CaravanWaylaid
function Old_world_caravans:offenceorDefence_handler(context)
  local dilemma_name = "owc_main_dilemma_armory_supply";
  local caravan = context:caravan();
  local faction = context:faction();
  local caravan_force = caravan:caravan_force();

  self:bind_callback_to_dilemma(
    dilemma_name,
    caravan);

  local dilemma_builder = cm:create_dilemma_builder(dilemma_name);
  local payload_builder = cm:create_payload();

  local offence = cm:create_new_custom_effect_bundle("wh3_dlc23_dilemma_chd_convoy_offence");
  offence:add_effect("wh_main_effect_force_stat_melee_attack", "force_to_force_own", 10);
  offence:add_effect("wh_main_effect_force_stat_weapon_strength", "force_to_force_own", 20);
  offence:set_duration(5);

  payload_builder:effect_bundle_to_force(caravan_force, offence);

  payload_builder:text_display("dummy_convoy_offence_defence_first");
  dilemma_builder:add_choice_payload("FIRST", payload_builder);
  payload_builder:clear();

  local defence = cm:create_new_custom_effect_bundle("wh3_dlc23_dilemma_chd_convoy_defence");
  defence:add_effect("wh_main_effect_force_stat_melee_defence", "force_to_force_own", 10);
  defence:add_effect("wh_main_effect_force_stat_armour", "force_to_force_own", 20);
  defence:set_duration(5);

  payload_builder:effect_bundle_to_force(caravan_force, defence);

  payload_builder:text_display("dummy_convoy_offence_defence_second");
  dilemma_builder:add_choice_payload("SECOND", payload_builder);

  dilemma_builder:add_target("default", caravan_force);

  cm:launch_custom_dilemma_from_builder(dilemma_builder, faction);
end
