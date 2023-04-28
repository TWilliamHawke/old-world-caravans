---@param context CaravanWaylaid
function Old_world_caravans:daemons_attack_handler(context)
  local caravan = context:caravan()
  local faction = context:faction()
  local dilemma_name = "wh3_main_dilemma_cth_caravan_battle_4";
  local list_of_regions = self:get_regions_list(context) or {};
  local bandit_threat = self:calculate_bandit_threat(list_of_regions);
  local encounter_dif = self:get_event_difficulty(bandit_threat, caravan);

  local daemons = {
    wh3_main_sc_kho_khorne = true,
    wh3_main_sc_nur_nurgle = true,
    wh3_main_sc_tze_tzeentch = true,
    wh3_main_sc_sla_slaanesh = true,
  }

  local target_region = self:get_region_by_node(caravan, context:to()):name();

  if #list_of_regions > 0 then
    local index = cm:random_number(#list_of_regions, 1);
    target_region = list_of_regions[index];
  end


  local selected_culture = self:select_random_key_by_weight(daemons, function(val)
    return 1
  end) or "wh3_main_sc_kho_khorne";

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

  if not random_unit then return end

  self:spy_on_dilemmas(caravan, enemy_cqi, function()
    self:bind_battle_to_dilemma(prebattle_data, function()
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
