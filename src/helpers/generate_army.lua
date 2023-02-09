---@param army_key string
---@return string
function Old_world_caravans:generate_army(army_key, event_dif)
  local default_string = [[
    wh_main_grn_inf_night_goblins,
  wh_main_grn_inf_night_goblins,
  wh_main_grn_inf_night_goblins,
  wh_main_grn_inf_night_goblins,
  wh_main_grn_mon_trolls,
  wh_main_grn_mon_trolls]];
  local army_template = self.enemy_forces[army_key];

  if not army_template then
    return default_string;
  end

  local unit_list = {};
  local filler_units = army_template.filler_units;

  local function add_units_in_list(unit, count)
    if count <= 0 or unit == "NONE" then return end
    for _ = 1, count do
      table.insert(unit_list, unit);
    end
  end

  local filler_unit = self:select_random_key_by_weight(filler_units, function(val)
        return val[1];
      end) or "NONE";

  local filler_unit_group = filler_units[filler_unit] or {};
  local min_filler_count = filler_unit_group[2];
  local max_filler_count = filler_unit_group[3];

  self:logCore("iterate through army template")
  for _, unit_group in ipairs(army_template) do
    local unit = self:select_random_key_by_weight(unit_group, function(val)
          return val[1];
        end)

    if unit then
      local min_count = unit_group[unit][2] or 1;
      local max_count = unit_group[unit][3] or 1;
      local count = cm:random_number(max_count, min_count);

      if unit == "NONE" then
        max_filler_count = max_filler_count + max_count;
        min_filler_count = min_filler_count + min_count;
      elseif count > min_count and max_filler_count > min_filler_count then
        max_filler_count = max_filler_count - 1;
      elseif count < max_count and max_filler_count > min_filler_count then
        min_filler_count = min_filler_count + 1
      end

      add_units_in_list(unit, count)
    end
  end

  add_units_in_list(filler_unit, cm:random_number(max_filler_count, min_filler_count))



  return table.concat(unit_list, ",")
end
