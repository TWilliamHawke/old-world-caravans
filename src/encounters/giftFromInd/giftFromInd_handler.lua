---@param context CaravanWaylaid
function Old_world_caravans:giftFromInd_handler(context)
  local dilemma_name = "wh3_main_dilemma_cth_caravan_5";
  local caravan = context:caravan();

  self:bind_callback_to_dilemma(dilemma_name, caravan);

  local dilemma_builder = cm:create_dilemma_builder(dilemma_name);
  local payload_builder = cm:create_payload();

  --FIRST double cargo capacity and value, and additional cargo
  payload_builder:character_trait_change(caravan:caravan_master():character(),
    "wh3_main_trait_blessed_by_ind_riches", false)

  local cargo_bundle = cm:create_new_custom_effect_bundle("wh3_main_dilemma_cth_caravan_2_b");
  cargo_bundle:add_effect("wh3_main_effect_caravan_cargo_DUMMY", "force_to_force_own", 1000);
  cargo_bundle:set_duration(0);
  payload_builder:effect_bundle_to_force(caravan:caravan_force(), cargo_bundle);

  dilemma_builder:add_choice_payload("FIRST", payload_builder);
  payload_builder:clear();

  --SECOND trait and free units
  payload_builder:character_trait_change(caravan:caravan_master():character(),
    "wh3_main_trait_blessed_by_ind_blades", false)
  local num_units = caravan:caravan_force():unit_list():num_items()

  if num_units < 20 then
    payload_builder:add_unit(caravan:caravan_force(), "wh3_main_cth_inf_dragon_guard_0",
      math.min(3, 20 - num_units), 9);
  end

  dilemma_builder:add_choice_payload("SECOND", payload_builder);

  dilemma_builder:add_target("default", caravan:caravan_force());

  cm:launch_custom_dilemma_from_builder(dilemma_builder, caravan:caravan_force():faction());
end
