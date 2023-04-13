Old_world_caravans = {
  is_init_save_key = "owc_mod_is_init",
  encounter_faction_save_key = "owc_encounter_faction",
  cleaup_encounter_debounce_key = "owc_kill_key",
  dilemma_callback_key = "dilemma_callback_key",
  debug_mode = true,
  invasion_key = "owc_encounter",
  belegar_faction = "wh_main_dwf_karak_izor",
  k8p_region_name = "wh3_main_combi_region_karak_eight_peaks",
  override_enemy = false,
  default_enemy_culture = nil, ---@type nil | string
  default_difficult = 1, ---@type 1 | 2 | 3
  db = {},
  encounter_budgets = {
    3500,
    5000,
    6500
  },
  filler_unit_weight = 1.5,
  cargo_threat_mult = 0.015,
  scale_difficulty_cargo = false,
  scale_difficulty_strenght = false,
  override_encounters = false,
  default_encounter = "",
  no_encounter_weight = 50,
  encounter_was_canceled_key = "owc_encounter_was_canceled",
  encounter_should_be_canceled = false,
  force_enable = false,
  ai_caravans = {
    wh_main_sc_emp_empire = true,
    wh_main_sc_dwf_dwarfs = true,
    wh3_main_sc_cth_cathay = true,
    wh_main_sc_brt_bretonnia = false,
    mixer_teb_southern_realms = false,
  },
}