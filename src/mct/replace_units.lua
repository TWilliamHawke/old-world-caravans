---@param replacers table<string, string>
function Old_world_caravans:replace_units(replacers)
  --replace start units
  for _, data in pairs(self.start_units) do
    for _, units in pairs(data) do
      for i = 1, #units do
        local replacer = replacers[units[i]];

        if replacer then
          units[i] = replacer
        end
      end
    end
  end

  for _, faction_units in pairs(self.culture_to_units) do
    for _, group in pairs(faction_units) do
      for unit, unit_data in pairs(group) do
        local new_unit = replacers[unit];

        if new_unit then
          group[new_unit] = unit_data;
          group[unit] = nil
        end
      end
    end
  end

  for _, faction_units in pairs(self.unit_awards) do
    for _, group in pairs(faction_units) do
      for unit, unit_data in pairs(group) do
        local new_unit = replacers[unit];

        if new_unit then
          group[new_unit] = unit_data;
          group[unit] = nil
        end
      end
    end
  end


end
