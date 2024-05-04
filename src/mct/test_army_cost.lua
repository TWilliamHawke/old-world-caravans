function Old_world_caravans:test_army_cost(list)
  for trait, unit_list in pairs(list) do
    local total_cost = 0;

    for i = 1, #unit_list do
      local unit_cost = cco("CcoMainUnitRecord", unit_list[i]):Call("Cost") or 0;
      total_cost = total_cost + unit_cost;
    end

    self:logCore(trait.." - "..total_cost)
  end
end