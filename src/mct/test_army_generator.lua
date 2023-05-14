function Old_world_caravans:test_army_generator()
  self:create_new_log()
  local army_key = tostring(self.default_enemy_culture) .. "_" .. tostring(self.default_difficult)
  self:logCore("test of " .. army_key)

  for i = 1, 20 do
    self:log("Army #" .. tostring(i))
    self:generate_army(self.default_enemy_culture, self.default_difficult, 0)
  end
end
