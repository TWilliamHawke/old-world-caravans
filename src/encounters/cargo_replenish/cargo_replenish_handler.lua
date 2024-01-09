---@param context CaravanWaylaid
function Old_world_caravans:cargo_replenish_handler(context)
  local dilemma_name = "wh3_main_dilemma_cth_caravan_2B";
  local caravan = context:caravan();

  self:bind_callback_to_dilemma(
    dilemma_name,
    caravan, 1,
    function()
      self:increase_caravan_cargo(caravan, 200)
    end);

    local dilemma_builder = cm:create_dilemma_builder(dilemma_name);
    local payload_builder = cm:create_payload();

    local replenish = cm:create_new_custom_effect_bundle("wh3_main_dilemma_cth_caravan_2");
    replenish:add_effect("wh_main_effect_force_all_campaign_replenishment_rate", "force_to_force_own", 8);
    replenish:add_effect("wh_main_effect_force_army_campaign_enable_replenishment_in_foreign_territory",
      "force_to_force_own", 1);
    replenish:set_duration(2);

    payload_builder:effect_bundle_to_force(caravan:caravan_force(), replenish);
    dilemma_builder:add_choice_payload("FIRST", payload_builder);
    payload_builder:clear();

    local cargo_bundle = cm:create_new_custom_effect_bundle("wh3_main_dilemma_cth_caravan_2_b");
    cargo_bundle:add_effect("wh3_main_effect_caravan_cargo_DUMMY", "force_to_force_own", 200);
    cargo_bundle:set_duration(0);

    payload_builder:effect_bundle_to_force(caravan:caravan_force(), cargo_bundle);
    dilemma_builder:add_choice_payload("SECOND", payload_builder);

    dilemma_builder:add_target("default", caravan:caravan_force());

    cm:launch_custom_dilemma_from_builder(dilemma_builder, caravan:caravan_force():faction());

end
