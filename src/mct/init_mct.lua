function Old_world_caravans:mct_init(context)
  local mct = context:mct()
  local fluc_mct = mct:get_mod_by_key("old_world_caravans")
  local settings = fluc_mct:get_settings();

  self.default_enemy_culture = settings.default_enemy;

  self:logCore(self.default_enemy_culture)

end