---@param culture string
---@param unit_group string
---@return string
---@return integer
function Old_world_caravans:select_unit(culture, unit_group)
  if not culture or not self.culture_to_units[culture] then
    self:logCore("cannot select unit for "..culture.. " in "..unit_group);
    return "", 0;
  end

  local units = self.culture_to_units[culture][unit_group];

  local selected_unit = self:select_random_key_by_weight(units, function (val)
    return val[1];
  end)

  if not selected_unit or not units[selected_unit] then
    self:logCore("cannot select unit for "..culture.. " in "..unit_group);
    return "", 0;
  end

  local min_count = units[selected_unit][2];
  local max_count = units[selected_unit][3];

  local units_count = cm:random_number(max_count, min_count);

  return selected_unit, units_count;
end