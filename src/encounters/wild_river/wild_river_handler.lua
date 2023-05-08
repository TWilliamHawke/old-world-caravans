---@param context CaravanWaylaid
function Old_world_caravans:wild_river_handler(context)
  local dilemma_name = "owc_main_dilemma_caravan_wild_river";
  local caravan = context:caravan();
  local caravan_force = caravan:caravan_force();
  local faction = context:faction()
  local cargo_amount = caravan:cargo();
  local character = context:caravan_master():character()

  local random_unit = self:get_random_unit(caravan);

  if not random_unit then
    ---@diagnostic disable-next-line: undefined-field
    cm:move_caravan(caravan);
    return
  end


  caravans:attach_battle_to_dilemma(
    dilemma_name,
    caravan,
    nil,
    false,
    nil,
    nil,
    nil,
    function()
      ---@diagnostic disable-next-line: undefined-field
      cm:set_caravan_cargo(caravan, cargo_amount - 200);
      core:trigger_custom_event("ScriptEventOwcLoseCargo", {
        character = character });
    end);

  local dilemma_builder = cm:create_dilemma_builder(dilemma_name);
  local payload_builder = cm:create_payload();
  payload_builder:remove_unit(caravan:caravan_force(), random_unit);

  dilemma_builder:add_choice_payload("FIRST", payload_builder);
  payload_builder:clear();

  local cargo_bundle = cm:create_new_custom_effect_bundle("wh3_main_dilemma_cth_caravan_2_b");
  cargo_bundle:add_effect("wh3_main_effect_caravan_cargo_DUMMY", "force_to_force_own", -200);
  cargo_bundle:set_duration(0);
  payload_builder:effect_bundle_to_force(caravan_force, cargo_bundle);

  if character:trait_points("owc_trait_grail_vow_caravan_cargo") == 1 then
    payload_builder:text_display("owc_grail_vow_complete")
  end

  dilemma_builder:add_choice_payload("SECOND", payload_builder);

  dilemma_builder:add_target("default", cm:get_military_force_by_cqi(enemy_cqi));
  dilemma_builder:add_target("target_military_1", caravan_force);

  self:log("dilemma_builder is finished, launch the dilemma")

  cm:launch_custom_dilemma_from_builder(dilemma_builder, faction);
end
