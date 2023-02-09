---@param context CaravanWaylaid
---@param event_string string
function Old_world_caravans:local_trouble_handler(context, event_string)
  local caravan = context:caravan();
  local caravan_culture = context:faction():subculture();
  local dilemma_name = "wh3_main_dilemma_cth_caravan_battle_1A";

  local function get_weight_for_node(region)
    local region_culture = self:get_culture_of_node(region);
    local culture_weight = self.node_culture_to_event_weight[caravan_culture] and
        self.node_culture_to_event_weight[caravan_culture][region_culture];

        self:logCore("node culture is "..region_culture)

    if region_culture == "wh_main_sc_dwf_dwarfs" or not culture_weight then
      return 0, region_culture
    end

    return culture_weight, region_culture
  end

  local region_from = self:get_region_by_node(caravan, context:from());
  local region_to = self:get_region_by_node(caravan, context:to());

  local weight_form, culture_from = get_weight_for_node(region_from);
  local weight_to, culture_to = get_weight_for_node(region_to);

  local weight_table = {
    [culture_from] = { weight_form, region_from:name() },
    [culture_to] = { weight_to, region_to:name() },
  }

  local enemy_culture = self:select_random_key_by_weight(weight_table, function (val)
    return val[1];
  end) or culture_from;

  local target_region = weight_table[enemy_culture][2];
  local encounter_diff = 1;

  self:logCore("selected culture is "..enemy_culture)


  local enemy_cqi = self:prepare_forces_for_battle(context, function ()
    return enemy_culture, target_region, encounter_diff;
  end,
  function (encounter_army)
    encounter_army:apply_effect("wh2_dlc16_bundle_scripted_wood_elf_encounter", 0);
  end)

  self:create_dilemma_with_cargo(context, dilemma_name, enemy_cqi);
end
