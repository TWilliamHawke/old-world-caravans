---@param context CaravanWaylaid
---@param event_string string
function Old_world_caravans:local_trouble_handler(context, event_string)
  local caravan = context:caravan();
  local caravan_culture = context:faction():subculture();

  local function get_weight_for_node(region)
    local region_culture = self:get_culture_of_node(region);
    local dilemma_name = self.db.local_trouble_dilemmas[region_culture];
    local culture_weight = self.node_culture_to_event_weight[caravan_culture] and
        self.node_culture_to_event_weight[caravan_culture][region_culture];

        self:logCore("node culture is "..region_culture)

    if not dilemma_name or not culture_weight then
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

  local dilemma_name = self.db.local_trouble_dilemmas[enemy_culture] or "wh3_main_dilemma_cth_caravan_battle_1A";


  local enemy_cqi = self:prepare_forces_for_battle(context,
  function ()
    return enemy_culture, target_region, encounter_diff;
  end,
  function (enemy_force_cqi)
    cm:apply_effect_bundle_to_force("wh2_dlc16_bundle_scripted_wood_elf_encounter", tostring(enemy_force_cqi), 0)
    self:logCore("apply_effect_bundle_to_force")
  end)

  self:create_dilemma_with_cargo(context, dilemma_name, enemy_cqi);
end
