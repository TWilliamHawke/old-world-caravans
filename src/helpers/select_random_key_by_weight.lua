---comment
---@param table table | string
---@param eneble_log boolean | nil
---@param weigth_selector fun(val): integer
---@return string | nil key
function Old_world_caravans:select_random_key_by_weight(table, weigth_selector, eneble_log)
  if not table or type(table) ~= "table" then return nil end
  local total_weight = 0;

  for _, val in pairs(table) do
    local weight = val and weigth_selector(val) or 0;
    total_weight = total_weight + tonumber(weight);
  end

  if total_weight == 0 then return nil end

  if eneble_log then
    self:logCore("total weight is "..total_weight)
  end;

  local random_number = cm:random_number(total_weight, 1);
  total_weight = 0;
  local random_key = "";

  if eneble_log then
    self:logCore("random_number is "..random_number)
  end;


  for key, val in pairs(table) do
    random_key = key;
    local weight = val and weigth_selector(val) or 0;

    total_weight = total_weight + tonumber(weight);
    if total_weight >= random_number then break end
  end

  return random_key;
end