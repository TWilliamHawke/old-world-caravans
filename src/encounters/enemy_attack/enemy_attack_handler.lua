---@param context CaravanWaylaid
function Old_world_caravans:enemy_attack_handler(context)
  local dilemma_name = "owc_main_dilemma_caravan_enemy_force";
  local caravan = context:caravan();
  local caravan_faction = context:faction();
  local caravan_force = caravan:caravan_force();
  local emeny_culture, target_region = self:get_enemy_by_regions(context)

  local enemy_cqi, x, y = self:create_enemy_army(
    context,
    emeny_culture,
    target_region,
    "wh2_dlc16_bundle_scripted_wood_elf_encounter",
    "owc_caravan_no_menace_bellow");

  ---@type Prebattle_caravan_data
  local prebattle_data = {
    caravan = context:caravan(),
    dilemma_name = dilemma_name,
    enemy_force_cqi = enemy_cqi,
    is_ambush = false,
    x = x,
    y = y,
  }

  self:spy_on_dilemmas(caravan, enemy_cqi, function()
    self:bind_battle_to_dilemma(prebattle_data, 1, function()
    end);

    self:log("battle has attached, goto dilemma builder")

    local dilemma_builder = cm:create_dilemma_builder(dilemma_name);
    local payload_builder = cm:create_payload();
    payload_builder:text_display("dummy_convoy_hungry_daemons_first")

    dilemma_builder:add_choice_payload("FIRST", payload_builder);
    payload_builder:clear();

    local cargo_bundle = cm:create_new_custom_effect_bundle("owc_caravan_exhausted_guards");
    cargo_bundle:set_duration(5);
    payload_builder:effect_bundle_to_force(caravan_force, cargo_bundle);
    dilemma_builder:add_choice_payload("SECOND", payload_builder);

    dilemma_builder:add_target("default", cm:get_military_force_by_cqi(enemy_cqi));
    dilemma_builder:add_target("target_military_1", caravan_force);

    self:log("dilemma_builder is finished, launch the dilemma")

    cm:launch_custom_dilemma_from_builder(dilemma_builder, caravan_faction);
  end)
end
