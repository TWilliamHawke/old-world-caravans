---@param context CaravanWaylaid
function Old_world_caravans:enemy_caravan_handler(context)
  local caravan = context:caravan();
  local caravan_culture = context:faction():subculture();
  local caravan_faction_key = context:faction():name()
  local dilemma_name = "wh3_dlc23_dilemma_chd_convoy_cathay_caravan";

  local end_region = self:get_region_by_node(caravan, context:to());
  local start_region = self:get_region_by_node(caravan, context:from());
  local culture_to = self:get_subculture_of_node(end_region);
  local culture_from = self:get_subculture_of_node(start_region);
  local default_caravan = caravans.traits_to_units["wh3_main_skill_innate_cth_caravan_master_stealth"]
  local battle_region = start_region:name()
  local cargo_amount = self:is_late_game() and 300 or 200

  local weight_table = {};

  for culture, event_weignts in pairs(self.node_culture_to_event_weight) do
    if culture ~= caravan_culture then
      local weight_from = event_weignts[culture_from] or 0;
      local weitht_to = event_weignts[culture_to] or 0;

      if weight_from > 0 and weight_from < 100 then
        local caravan_chance_from = math.floor(1000 / weight_from);
        self:increment_value_in_table(weight_table, culture, caravan_chance_from);
      end

      if weitht_to > 0 and weitht_to < 100 then
        local caravan_chance_to = math.floor(1000 / weitht_to);
        self:increment_value_in_table(weight_table, culture, caravan_chance_to);
      end
    end
  end

  local enemy_culture = self:select_random_key_by_weight(weight_table,
    function(val)
      return val
    end, true) or "wh3_main_sc_cth_cathay";

  self:logCore("selected caravan culture is " .. enemy_culture)

  local caravans_list = self.start_units[enemy_culture] or self.cathay_caravans;

  local caravan_trait = self:select_random_key_by_weight(caravans_list, function(val)
    return 1;
  end) or "none";

  local unit_list = caravans_list[caravan_trait] or default_caravan;
  local general = self.culture_to_fake_caravan_master[enemy_culture] or "wh3_main_cth_lord_magistrate_yang";
  local enemy_faction = self.culture_to_enemy_faction[enemy_culture];
  local elite_guards = self.db.elite_guards[enemy_culture];

  local army_string = table.concat(unit_list, ",")

  if elite_guards and self:is_late_game() then
    local elite_unit = elite_guards.unit;

    if elite_unit then
      army_string = army_string .. "," .. elite_unit .. "," .. elite_unit
    end
  end

  local x, y = self:find_position_for_spawn(caravan_faction_key, battle_region)

  cm:create_force_with_general(enemy_faction, army_string, battle_region,
    x, y, "general", general, "", "", "", "", false,
    function(enemy_char_cqi, enemy_force_cqi)
      cm:force_declare_war(enemy_faction, caravan_faction_key, false, false);
      cm:disable_movement_for_character(cm:char_lookup_str(enemy_char_cqi));

      enemy_cqi = enemy_force_cqi;
    end);

  if enemy_cqi ~= 0 then
    cm:set_saved_value(self.encounter_faction_save_key .. caravan_faction_key, enemy_cqi);
  end

  ---@type Prebattle_caravan_data
  local prebattle_data = {
    caravan = caravan,
    dilemma_name = dilemma_name,
    is_ambush = false,
    enemy_force_cqi = enemy_cqi,
    x = x,
    y = y,
  }

  self:spy_on_dilemmas(caravan, enemy_cqi, function()
    self:bind_battle_to_dilemma(prebattle_data, 0, function()
      self:increase_caravan_cargo(caravan, cargo_amount)
    end);

    self:log("battle has attached, goto dilemma builder")

    local dilemma_builder = cm:create_dilemma_builder(dilemma_name);
    local payload_builder = cm:create_payload();

    local cargo_bundle = cm:create_new_custom_effect_bundle("wh3_main_dilemma_cth_caravan_2_b");
    cargo_bundle:add_effect("wh3_main_effect_caravan_cargo_DUMMY", "force_to_force_own", cargo_amount);
    cargo_bundle:set_duration(0);

    payload_builder:effect_bundle_to_force(caravan:caravan_force(), cargo_bundle);
    local own_faction = caravan:caravan_force():faction();

    payload_builder:text_display("dummy_convoy_cathay_caravan_first");
    dilemma_builder:add_choice_payload("FIRST", payload_builder);
    payload_builder:clear();

    payload_builder:text_display("dummy_convoy_cathay_caravan_second");
    dilemma_builder:add_choice_payload("SECOND", payload_builder);

    dilemma_builder:add_target("default", cm:get_military_force_by_cqi(enemy_cqi));
    dilemma_builder:add_target("target_military_1", caravan:caravan_force());

    self:log("Triggering dilemma:" .. dilemma_name)
    cm:launch_custom_dilemma_from_builder(dilemma_builder, own_faction);
  end)
end
