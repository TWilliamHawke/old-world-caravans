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

  self.culture_to_units.wh_main_sc_brt_bretonnia = {
    weakA = {
      ["wh_main_brt_inf_spearmen_at_arms"] = { 2, 2, 3 },
      ["wh_main_brt_inf_men_at_arms"] = { 2, 2, 3 },
      ["wh_dlc07_brt_inf_men_at_arms_2"] = { 2, 2, 3 },
      ["wh_dlc07_brt_cav_knights_errant_0"] = { 2, 2, 2 },
    },
    weakB = {
      ["wh_dlc07_brt_inf_peasant_bowmen_2"] = { 1, 2, 3 },
      ["wh_dlc07_brt_inf_peasant_bowmen_1"] = { 1, 2, 3 },
      ["wh_main_brt_inf_peasant_bowmen"] = { 1, 2, 3 },
    },
    strongA = {
      ["wh_dlc07_brt_inf_battle_pilgrims_0"] = { 2, 2, 3 },
      ["wh_dlc07_brt_inf_foot_squires_0"] = { 2, 2, 3 },
      ["wh_dlc07_brt_art_blessed_field_trebuchet_0"] = { 1, 2, 3 },
    },
    strongB = {
      ["wh_dlc07_brt_cav_knights_errant_0"] = { 5, 2, 2 },
      ["wh_dlc07_brt_cav_questing_knights_0"] = { 2, 2, 2 },
      ["wh_main_brt_cav_knights_of_the_realm"] = { 2, 2, 2 },
      ["wh_main_brt_cav_pegasus_knights"] = { 1, 1, 1 },
    },
  }

  for _, units in pairs(self.start_units.wh_main_sc_brt_bretonnia) do
    for i = 1, #units do
      local replacer = replacers[units[i]];

      if replacer then
        units[i] = replacer
      end
    end

  end
end
