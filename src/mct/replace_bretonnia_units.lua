function Old_world_caravans:replace_bretonnia_units()
  local replacers = {
    owc_dlc07_brt_inf_battle_pilgrims_0 = "wh_dlc07_brt_inf_battle_pilgrims_0",
    owc_dlc07_brt_inf_foot_squires_0 = "wh_dlc07_brt_inf_foot_squires_0",
    owc_dlc07_brt_inf_men_at_arms_2 = "wh_dlc07_brt_inf_men_at_arms_2",
    owc_dlc07_brt_inf_peasant_bowmen_1 = "wh_dlc07_brt_inf_peasant_bowmen_1",
    owc_dlc07_brt_inf_peasant_bowmen_2 = "wh_dlc07_brt_inf_peasant_bowmen_2",
    owc_main_brt_inf_men_at_arms = "wh_main_brt_inf_men_at_arms",
    owc_main_brt_inf_peasant_bowmen = "wh_main_brt_inf_peasant_bowmen",
    owc_main_brt_inf_spearmen_at_arms = "wh_main_brt_inf_spearmen_at_arms",
    owc_dlc07_brt_art_blessed_field_trebuchet_0 = "wh_dlc07_brt_art_blessed_field_trebuchet_0",
  }

  for _, units in pairs(self.culture_to_units.wh_main_sc_brt_bretonnia) do
    for unit_key, unit_data in pairs(units) do
      local replacer = replacers[unit_key];

      if replacer then
        units[replacer] = unit_data;
        units[unit_key] = { 0, 0, 0 }
      end
    end
  end

  for _, units in pairs(self.start_units.wh_main_brt_bretonnia) do
    for i = 1, #units do
      local replacer = replacers[units[i]];

      if replacer then
        units[i] = replacer
      end
    end

  end
end
