---@diagnostic disable: undefined-field
---@param context CaravanWaylaid
---@param prebattle_data Prebattle_caravan_data
function Old_world_caravans:create_dilemma_with_cargo(context, prebattle_data)
  local caravan = context:caravan();
  local caravan_faction = context:faction();
  local cargo_amount = caravan:cargo();
  local caravan_force = caravan:caravan_force();
  local character = context:caravan_master():character()
  local enemy_cqi = prebattle_data.enemy_force_cqi

  self:spy_on_dilemmas(caravan, enemy_cqi, function()
    self:bind_battle_to_dilemma(prebattle_data, 1, function()
      cm:set_caravan_cargo(caravan, cargo_amount - 200);
      core:trigger_custom_event("ScriptEventOwcLoseCargo", {
        character = character});
    end);

    self:log("battle has attached, goto dilemma builder")

    local dilemma_builder = cm:create_dilemma_builder(prebattle_data.dilemma_name);
    local payload_builder = cm:create_payload();

    dilemma_builder:add_choice_payload("FIRST", payload_builder);
    payload_builder:clear();

    local cargo_bundle = cm:create_new_custom_effect_bundle("wh3_main_dilemma_cth_caravan_2_b");
    cargo_bundle:add_effect("wh3_main_effect_caravan_cargo_DUMMY", "force_to_force_own", -200);
    cargo_bundle:set_duration(0);
    payload_builder:effect_bundle_to_force(caravan_force, cargo_bundle);
    dilemma_builder:add_choice_payload("SECOND", payload_builder);

    dilemma_builder:add_target("default", cm:get_military_force_by_cqi(enemy_cqi));
    dilemma_builder:add_target("target_military_1", caravan_force);

    self:log("dilemma_builder is finished, launch the dilemma")

    cm:launch_custom_dilemma_from_builder(dilemma_builder, caravan_faction);
  end)
end
