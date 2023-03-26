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

  if settings.force_enable then
    local human_factions = cm:get_human_factions()
    
    for _, faction_name in ipairs(human_factions) do
      local faction = cm:get_faction(faction_name)
      if self:faction_has_caravans(faction) and not self:caravan_button_should_be_visible(faction) then
        if cm:get_local_faction():name() == faction_name then
          self:show_caravan_button();
        end
        cm:set_saved_value(self.is_init_save_key .. faction_name, true)
      end
    end
  end

  self.force_enable = settings.force_enable;
end