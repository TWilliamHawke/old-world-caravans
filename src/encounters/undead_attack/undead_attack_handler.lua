---@param context CaravanWaylaid
function Old_world_caravans:undead_attack_handler(context)
  local caravan = context:caravan()
  local faction = context:faction()
  local dilemma_name = "owc_main_dilemma_undead_attack";
  local _, list_of_regions = self:get_regions_list(context);
  local selected_culture = "wh_main_sc_vmp_vampire_counts"

  local target_region = self:get_region_by_node(caravan, context:to()):name();

  for i = 0, list_of_regions:num_items() - 1 do
    local region = list_of_regions:item_at(i);
    local corruption_level = cm:get_corruption_value_in_region(region:region(), "wh3_main_corruption_vampiric") or 0;
    if corruption_level > 0 then
      target_region = region:key()
      break
    end
  end

  local enemy_cqi, x, y = self:create_enemy_army(context, selected_culture, target_region)

  local prebattle_data = {
    caravan = context:caravan(),
    dilemma_name = dilemma_name,
    enemy_force_cqi = enemy_cqi,
    is_ambush = false,
    x = x,
    y = y,
  }

  local random_unit = self:get_random_unit(caravan);

  if not random_unit then
    self:log("not enough units for ambush event")
    ---@diagnostic disable-next-line: undefined-field
    cm:move_caravan(caravan);
    return
  end

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
    dilemma_builder:add_target("default", cm:get_military_force_by_cqi(enemy_cqi));
    dilemma_builder:add_target("target_military_1", caravan:caravan_force());

    self:log("dilemma_builder is finished, launch the dilemma")

    cm:launch_custom_dilemma_from_builder(dilemma_builder, faction);
  end)
end
