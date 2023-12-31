---@param context CaravanWaylaid
function Old_world_caravans:local_trouble_handler(context)
  local caravan = context:caravan();
  local caravan_culture = context:faction():subculture();

  local function get_weight_for_node(region)
    local region_culture = self:get_subculture_of_node(region);
    local dilemma_name = self.db.local_trouble_dilemmas[region_culture];
    local culture_weight = self.node_culture_to_event_weight[caravan_culture] and
        self.node_culture_to_event_weight[caravan_culture][region_culture];

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

  local enemy_culture = self:select_random_key_by_weight(weight_table, function(val)
    return val[1];
  end) or culture_from;

  local target_region = weight_table[enemy_culture][2] or region_from:name();

  if self.random_enemies then
    enemy_culture = self:select_random_key_by_weight(self.db.local_trouble_dilemmas, function(val)
      return 1
    end) or culture_from;
  end


  self:log("selected culture is " .. enemy_culture)

  --local dilemma_name = self.db.local_trouble_dilemmas[enemy_culture] or "wh3_main_dilemma_cth_caravan_battle_1A";
  local suffix = cm:random_number(2) > 1 and "A" or "B";
  local dilemma_name = "wh3_main_dilemma_cth_caravan_battle_1" .. suffix;

  local enemy_cqi, x, y = self:create_enemy_army(
    context,
    enemy_culture,
    target_region)

  local prebattle_data = {
    caravan = context:caravan(),
    dilemma_name = dilemma_name,
    enemy_force_cqi = enemy_cqi,
    is_ambush = false,
    x = x,
    y = y,
  }

  self:create_dilemma_with_cargo(context, prebattle_data);
end
