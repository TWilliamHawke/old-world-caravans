---@param enemy_culture string
---@param encounter_dif number
---@param additional_budget number
---@return string
---@return string | nil general
function Old_world_caravans:generate_army(enemy_culture, encounter_dif, additional_budget)
  local default_string = [[
    wh_main_grn_inf_orc_big_uns,
  wh_main_grn_inf_night_goblins,
  wh_main_grn_inf_night_goblins,
  wh_main_grn_inf_night_goblins,
  wh_main_grn_mon_trolls,
  wh_main_grn_mon_trolls]];

  local force_key = enemy_culture .. "_" .. tostring(encounter_dif);
  local army_template = self.enemy_forces[force_key];
  local budget = self.encounter_budgets[encounter_dif] + additional_budget;
  local min_army_size = self.min_army_size[encounter_dif] or 0
  local general = self.enemy_forces[force_key] and self.enemy_forces[force_key].general;


  if not army_template then
    return default_string;
  end

  local unit_list = {};
  local filler_units_weight = (army_template.filler_units_mult or 1) * self.filler_unit_weight;
  local unit_budget = math.max(budget / (#army_template + filler_units_weight), 500);
  local filler_unit_budget = unit_budget * filler_units_weight;

  if filler_unit_budget > 2500 and #army_template > 0 then
    filler_unit_budget = 2500;
    unit_budget = (budget - 2500) / #army_template;
  end

  local filler_units = army_template.filler_units or {};
  local unit_cap = cm:random_number(2) > 1 and 6 or 7;

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
    self:log(unit_key .. ": x" .. units_count)

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

  if #unit_list < min_army_size and #unit_list > 0 then
    for _ = #unit_list, min_army_size - 1 do
      self:log("additional unit: "..unit_list[#unit_list])
      table.insert(unit_list, unit_list[#unit_list])
    end
  end

  return table.concat(unit_list, ","), general
end
