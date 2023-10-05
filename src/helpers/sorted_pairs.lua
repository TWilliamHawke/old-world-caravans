function Old_world_caravans:sorted_pairs(t)
  -- Sorting a dictionary is key to preventing desyncs in multiplayer.
  -- Extract and sort the keys
  local keys = {}
  for k in pairs(t) do
    table.insert(keys, k)
  end
  table.sort(keys)

  -- Iterator function
  local i = 0
  return function()
    i = i + 1
    local key = keys[i]
    if key then
      return key, t[key]
    end
  end
end
