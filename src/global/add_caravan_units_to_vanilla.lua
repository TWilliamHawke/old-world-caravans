function Old_world_caravans:add_caravan_units_to_vanilla()
  for _, faction_units in pairs(self.start_units) do
    for trait, units in pairs(faction_units) do
      caravans.traits_to_units[trait] = units;
    end
  end
end