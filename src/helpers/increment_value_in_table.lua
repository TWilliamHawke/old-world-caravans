---comment
---@param table table<string, integer>
---@param field string
---@param value integer | nil
function Old_world_caravans:increment_value_in_table(table, field, value)
  if value == 0 then return end
  value = value or 1
  local current_value = table[field];

  if not current_value then
    table[field] = value;
  else
    table[field] = current_value + value;
  end

end;