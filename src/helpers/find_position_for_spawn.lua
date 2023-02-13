---comment
---@param faction_key string
---@param region_key string
---@return integer x
---@return integer y
function Old_world_caravans:find_position_for_spawn(faction_key, region_key)
  local x, y = cm:find_valid_spawn_location_for_character_from_settlement(
    faction_key,
    region_key,
    false,
    true,
    20
  );

---@diagnostic disable-next-line: return-type-mismatch
  return x, y;
end