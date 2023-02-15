function Old_world_caravans:mct_init(context)
  local mct = context:mct()
  local fluc_mct = mct:get_mod_by_key("old_world_caravans")
  local settings = fluc_mct:get_settings();

  self.default_enemy_culture = settings.default_enemy;
  self.override_encounters = not not settings.override_encounters
  self.default_difficult = tonumber(settings.default_difficult)
  self.encounter_budget_1 = tonumber(settings.encounter_budget_1)
  self.encounter_budget_2 = tonumber(settings.encounter_budget_2)
  self.encounter_budget_3 = tonumber(settings.encounter_budget_3)
  self.filler_unit_weight = tonumber(settings.filler_unit_weight) / 10

  self:logCore("filler_unit_weight is "..tostring(self.filler_unit_weight));

end