---@param context CaravanWaylaid
function Old_world_caravans:daemons_attack_handler(context)
  local caravan = context:caravan()
  local faction = context:faction()
  local dilemma_name = "wh3_main_dilemma_cth_caravan_battle_4";
  local region_keys, list_of_regions = self:get_regions_list(context)
  local bandit_threat = self:calculate_bandit_threat(region_keys or {});
  local encounter_dif = self:get_event_difficulty(bandit_threat, caravan);

  local daemons = {
    "wh3_main_sc_kho_khorne",
    "wh3_main_sc_nur_nurgle",
    "wh3_main_sc_tze_tzeentch",
    "wh3_main_sc_sla_slaanesh",
  }

  local target_region = self:get_region_by_node(caravan, context:to()):name();

  for i = 0, list_of_regions:num_items() - 1 do
    local region = list_of_regions:item_at(i);

    ---@diagnostic disable-next-line: redundant-parameter
    if cm:get_highest_corruption_in_region(region:region(), self.chaos_corruptions) then
      target_region = region:key();
      break
    end
  end

  local selected_culture = daemons[cm:random_number(#daemons)]

  local enemy_cqi, x, y = self:create_enemy_army(context, function()
    return selected_culture, target_region, encounter_dif
  end)

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
    dilemma_builder:add_choice_payload("FIRST", payload_builder);
    payload_builder:clear();

    payload_builder:remove_unit(caravan:caravan_force(), random_unit);
    dilemma_builder:add_choice_payload("SECOND", payload_builder);
    dilemma_builder:add_target("default", cm:get_military_force_by_cqi(enemy_cqi));
    dilemma_builder:add_target("target_military_1", caravan:caravan_force());

    self:log("dilemma_builder is finished, launch the dilemma")

    cm:launch_custom_dilemma_from_builder(dilemma_builder, faction);
  end)
end
