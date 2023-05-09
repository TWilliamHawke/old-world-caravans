---@diagnostic disable: undefined-field
---@param context CaravanWaylaid
function Old_world_caravans:ambush_handler(context)
  local emeny_culture, target_region = self:get_enemy_by_regions(context)
  local dilemma_name = "owc_main_dilemma_caravan_1";
  local caravan = context:caravan();
  local caravan_force = caravan:caravan_force();

  local enemy_cqi, x, y = self:create_enemy_army(
    context,
    emeny_culture,
    target_region,
    "wh2_dlc17_bundle_scripted_lizardmen_encounter",
    "owc_caravan_no_menace_bellow"
  );

  local random_unit = self:get_random_unit(caravan)

  if not random_unit then
    self:log("not enough units for ambush event")
    cm:move_caravan(caravan);
    return
  end

  ---@type Prebattle_caravan_data
  local prebattle_data = {
    caravan = caravan,
    dilemma_name = dilemma_name,
    enemy_force_cqi = enemy_cqi,
    is_ambush = true,
    x = x,
    y = y
  }

  self:spy_on_dilemmas(caravan, enemy_cqi, function()
    self:bind_battle_to_dilemma(prebattle_data, 0, function()
    end);

    self:log("battle has attached, goto dilemma builder")

    local dilemma_builder = cm:create_dilemma_builder(dilemma_name);
    local payload_builder = cm:create_payload();
    payload_builder:text_display("dummy_convoy_redeadify_first")
    dilemma_builder:add_choice_payload("FIRST", payload_builder);
    payload_builder:clear();

    payload_builder:remove_unit(caravan:caravan_force(), random_unit);
    payload_builder:text_display("dummy_convoy_redeadify_second")
    dilemma_builder:add_choice_payload("SECOND", payload_builder);
    dilemma_builder:add_target("default", caravan:caravan_force());

    self:log("dilemma_builder is finished, launch the dilemma")

    cm:launch_custom_dilemma_from_builder(dilemma_builder, caravan_force:faction());
  end);
end
