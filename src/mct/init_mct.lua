function Old_world_caravans:mct_init(context)
  local mct = context:mct()
  local fluc_mct = mct:get_mod_by_key("old_world_caravans")
  local settings = fluc_mct:get_settings(); ---@type MCT_settings

  self.default_enemy_culture = settings.default_enemy;
  self.override_enemy = settings.override_enemy
  self.override_encounters = settings.override_encounters
  self.default_encounter = settings.default_encounter
  self.scale_difficulty_cargo = settings.scale_difficulty_cargo
  self.scale_difficulty_strenght = settings.scale_difficulty_strenght
  self.default_difficult = settings.default_difficult
  self.encounter_budgets[1] = tonumber(settings.encounter_budget_1)
  self.encounter_budgets[2] = tonumber(settings.encounter_budget_2)
  self.encounter_budgets[3] = tonumber(settings.encounter_budget_3)
  --self.filler_unit_weight = tonumber(settings.filler_unit_weight) / 10
  self.no_encounter_weight = settings.no_encounter_weight;

end