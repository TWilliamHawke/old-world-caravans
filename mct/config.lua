if not get_mct then return end
local mct = get_mct();

if not mct then return end

local old_world_caravans = mct:register_mod("old_world_caravans")
old_world_caravans:set_title("Caravans of the Old World", false)
-- old_world_caravans:set_description(loc_prefix.."mod_desc", true)
old_world_caravans:set_log_file_path("Old_world_caravans_log.txt")
old_world_caravans:set_author("TWilliam")

local unit_caps_size_options = {
  { key = "wh_main_sc_emp_empire",          text = "empire",          tt = "", default = true },
  { key = "wh_main_sc_brt_bretonnia",       text = "bretonnia",       tt = "", default = false },
  { key = "wh3_main_sc_ksl_kislev",         text = "kislev",          tt = "", default = false },
  { key = "wh_main_sc_dwf_dwarfs",          text = "dwarfs",          tt = "", default = false },
  { key = "wh3_main_sc_ogr_ogre_kingdoms",  text = "ogre_kingdoms",   tt = "", default = false },
  { key = "wh_main_sc_teb_teb",             text = "southern_realms", tt = "", default = false },
  { key = "wh2_main_sc_hef_high_elves",     text = "high_elves",      tt = "", default = false },
  { key = "wh_dlc05_sc_wef_wood_elves",     text = "wood_elves",      tt = "", default = false },
  { key = "wh2_main_sc_lzd_lizardmen",      text = "lizardmen",       tt = "", default = false },
  { key = "wh_dlc03_sc_bst_beastmen",       text = "beastmen",        tt = "", default = false },
  { key = "wh_main_sc_grn_greenskins",      text = "greenskins",      tt = "", default = false },
  { key = "wh_main_sc_vmp_vampire_counts",  text = "vampire_counts",  tt = "", default = false },
  { key = "wh_dlc08_sc_nor_norsca",         text = "norsca",          tt = "", default = false },
  { key = "wh2_dlc11_sc_cst_vampire_coast", text = "vampire_coast",   tt = "", default = false },
  { key = "wh2_main_sc_def_dark_elves",     text = "dark_elves",      tt = "", default = false },
  { key = "wh2_main_sc_skv_skaven",         text = "skaven",          tt = "", default = false },
  { key = "wh2_dlc09_sc_tmb_tomb_kings",    text = "tombking",        tt = "", default = false },
  { key = "wh3_main_sc_kho_khorne",         text = "khorne",          tt = "", default = false },
  { key = "wh3_main_sc_sla_slaanesh",       text = "slaanesh",        tt = "", default = false },
  { key = "wh3_main_sc_tze_tzeentch",       text = "tzeentch",        tt = "", default = false },
  { key = "wh3_main_sc_nur_nurgle",         text = "nurgle",          tt = "", default = false },
}

local encounters = {
  { key = "nothing",         text = "nothing",         tt = "", default = false },
  { key = "ambush",          text = "ambush",          tt = "", default = false },
  { key = "cargo_replenish", text = "cargo_replenish", tt = "", default = false },
  { key = "enemy_attack",    text = "enemy_attack",    tt = "", default = true },
  { key = "local_trouble",   text = "local_trouble",   tt = "", default = false },
  { key = "new_agent",       text = "new_agent",       tt = "", default = false },
  { key = "new_units",       text = "new_units",       tt = "", default = false },
  { key = "shortcut",        text = "shortcut",        tt = "", default = false },
}


local first_section = old_world_caravans:get_section_by_key("default");
first_section:set_localised_text("Encounters Difficulty", false);

local encounter_budget_1 = old_world_caravans:add_new_option("encounter_budget_1", "slider");
encounter_budget_1:set_text("Easy Encounters")
encounter_budget_1:slider_set_min_max(2000, 5000)
encounter_budget_1:set_default_value(3500)
encounter_budget_1:slider_set_step_size(500)

local encounter_budget_2 = old_world_caravans:add_new_option("encounter_budget_2", "slider");
encounter_budget_2:set_text("Medium Encounters")
encounter_budget_2:slider_set_min_max(3000, 7000)
encounter_budget_2:set_default_value(5000)
encounter_budget_2:slider_set_step_size(500)

local encounter_budget_3 = old_world_caravans:add_new_option("encounter_budget_3", "slider");
encounter_budget_3:set_text("Hard Encounters")
encounter_budget_3:slider_set_min_max(5000, 10000)
encounter_budget_3:set_default_value(7000)
encounter_budget_3:slider_set_step_size(500)

-- local filler_unit_weight = old_world_caravans:add_new_option("filler_unit_weight", "slider");
-- filler_unit_weight:set_text("Filler units weight")
-- filler_unit_weight:slider_set_min_max(10, 20)
-- filler_unit_weight:set_default_value(15)
-- filler_unit_weight:slider_set_step_size(1)

local scale_difficulty_cargo = old_world_caravans:add_new_option("scale_difficulty_cargo", "checkbox")
scale_difficulty_cargo:set_text("Scale difficulty with caravan cargo")

local scale_difficulty_strenght = old_world_caravans:add_new_option("scale_difficulty_strenght", "checkbox")
scale_difficulty_strenght:set_text("Scale difficulty with caravan size")

local no_encounter_weight = old_world_caravans:add_new_option("no_encounter_weight", "slider")
no_encounter_weight:set_text("Probability of no encounter")
no_encounter_weight:slider_set_min_max(0, 50)
no_encounter_weight:set_default_value(50)
no_encounter_weight:slider_set_step_size(10)


local debug_section = old_world_caravans:add_new_section("n_debug")
debug_section:set_localised_text("Debug Section")
debug_section:set_visibility(false)

local override_encounters = old_world_caravans:add_new_option("override_encounters", "checkbox")
override_encounters:set_text("Override Encounters")

local default_encounter = old_world_caravans:add_new_option("default_encounter", "dropdown")
default_encounter:set_text("Default Encounter")
default_encounter:add_dropdown_values(encounters)

local enable_log = old_world_caravans:add_new_option("enable_log", "checkbox")
enable_log:set_text("Enable Logging")

local override_enemy = old_world_caravans:add_new_option("override_enemy", "checkbox")
override_enemy:set_text("Override Enemy")

local default_enemy = old_world_caravans:add_new_option("default_enemy", "dropdown")
default_enemy:set_text("Default Enemy")
default_enemy:add_dropdown_values(unit_caps_size_options)

local default_difficult = old_world_caravans:add_new_option("default_difficult", "slider")
default_difficult:set_text("Default Difficult")
default_difficult:slider_set_min_max(1, 3)
default_difficult:set_default_value(1)
default_difficult:slider_set_step_size(1)
