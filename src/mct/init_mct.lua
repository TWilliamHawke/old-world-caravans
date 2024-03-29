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
  self.debug_mode = settings.enable_log;
  self.force_enable = settings.force_enable;
  self.peasant_economy = settings.peasant_economy;
  self.random_enemies = settings.random_enemies;
  self.cargo_value = settings.cargo_value;
  self.combat_encounter_chance = tonumber(settings.combat_probability);

  self.ai_caravans.wh_main_sc_brt_bretonnia = settings.ai_bretonnia_caravans;
  self.ai_caravans.wh_main_sc_emp_empire = settings.ai_empire_caravans;
  self.ai_caravans.wh_main_sc_dwf_dwarfs = settings.ai_dwarf_caravans;
  self.ai_caravans.mixer_teb_southern_realms = settings.ai_teb_caravans;
  self.ai_caravans.wh3_main_sc_ksl_kislev = settings.ai_ksl_caravans;

  if settings.peasant_economy then
    self:replace_units(self.brt_replacers)
  end

  if settings.replace_units then
    self:replace_units(self.main_replacers)

    if vfs.exists("script/campaign/mod/twill_old_world_caravans_teb.lua") then
      self:replace_units(self.teb_replacers)
    end
  end
end