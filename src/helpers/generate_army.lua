---@param army_key string
---@param budget number
---@return string
---@return table<string>
function Old_world_caravans:generate_army(army_key, encounter_dif)
  local default_string = [[
    wh_main_grn_inf_night_goblins,
  wh_main_grn_inf_night_goblins,
  wh_main_grn_inf_night_goblins,
  wh_main_grn_inf_night_goblins,
  wh_main_grn_mon_trolls,
  wh_main_grn_mon_trolls]];
  local army_template = self.enemy_forces[army_key];
  local budget = self.encounter_budgets[encounter_dif];


  if not army_template then
    return default_string, {};
  end

  local unit_list = {};
  local filler_units_weight = (army_template.filler_units_mult or 1) * self.filler_unit_weight;
  local unit_budget = math.max(budget / (#army_template + filler_units_weight), 500);
  local filler_unit_budget = unit_budget * filler_units_weight;
  local filler_units = army_template.filler_units or {};
  local unit_cap = cm:random_number(2) > 1 and 7 or 8;

  local function add_units_in_list(unit, count)
    if count <= 0 or unit == "NONE" then return end
    for _ = 1, count do
      table.insert(unit_list, unit);
    end
  end

  local function select_unit(units, local_budget)
    local unit_key = self:select_random_key_by_weight(units, function(val)
      return val;
    end) or "NONE";

    if unit_key == "NONE" then
      filler_unit_budget = filler_unit_budget + unit_budget;
      return local_budget - unit_budget;
    end

    local unit_cost = cco("CcoMainUnitRecord", unit_key):Call("Cost");
    if not unit_cost or unit_cost == 0 then
      unit_cost = unit_budget;
    end

    local units_count = local_budget / unit_cost
    units_count = math.max(units_count, 1)
    --units_count = math.floor(units_count);
    local chance_to_increace = units_count - math.floor(units_count);
    units_count = math.floor(units_count);

    --chance_to_increace < 0.2 => 0%
    --chance_to_increace > 0.8 => 100%
    if cm:random_number(6, 0) / 10 < chance_to_increace - 0.2 then
      units_count = units_count + 1;
    end

    units_count = math.min(units_count, unit_cap);
    add_units_in_list(unit_key, units_count);
    self:log(unit_key..": x"..units_count)

    if unit_cost >= local_budget then
      return 0
    end

    return local_budget - unit_cost * units_count;
  end

  local budget_balance = 0;

  for _, unit_group in ipairs(army_template) do
    budget_balance = select_unit(unit_group, unit_budget + budget_balance)
  end

  select_unit(filler_units, filler_unit_budget + budget_balance);

  return table.concat(unit_list, ","), unit_list
end
