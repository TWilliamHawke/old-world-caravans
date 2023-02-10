if not get_mct then return end
local mct = get_mct();

if not mct then return end;

local old_world_caravans = mct:register_mod("old_world_caravans")
old_world_caravans:set_title("Old world Caravans", false)
-- old_world_caravans:set_description(loc_prefix.."mod_desc", true)
old_world_caravans:set_log_file_path("Old_world_caravans_log.txt")
old_world_caravans:set_author("TWilliam")

local unit_caps_size_options = {
  { key = "wh_main_sc_emp_empire", text = "empire", tt = "", default = true },
  { key = "wh_main_sc_brt_bretonnia", text = "bretonnia", tt = "", default = false },
  { key = "wh3_main_sc_ksl_kislev", text = "kislev", tt = "", default = false },
  { key = "wh_main_sc_dwf_dwarfs", text = "dwarfs", tt = "", default = false },
  { key = "wh3_main_sc_ogr_ogre_kingdoms", text = "ogre_kingdoms", tt = "", default = false },
  { key = "wh_main_sc_teb_teb", text = "empire", tt = "", default = false },
  { key = "wh2_main_sc_hef_high_elves", text = "high_elves", tt = "", default = false },
  { key = "wh_dlc05_sc_wef_wood_elves", text = "wood_elves", tt = "", default = false },
  { key = "wh2_main_sc_lzd_lizardmen", text = "lizardmen", tt = "", default = false },
  { key = "wh_dlc03_sc_bst_beastmen", text = "beastmen", tt = "", default = false },
  { key = "wh_main_sc_grn_greenskins", text = "greenskins", tt = "", default = false },
  { key = "wh_main_sc_vmp_vampire_counts", text = "vampire_counts", tt = "", default = false },
  { key = "wh_dlc08_sc_nor_norsca", text = "norsca", tt = "", default = false },
  { key = "wh2_dlc11_sc_cst_vampire_coast", text = "vampire_coast", tt = "", default = false },
  { key = "wh2_main_sc_def_dark_elves", text = "dark_elves", tt = "", default = false },
  { key = "wh2_main_sc_skv_skaven", text = "skaven", tt = "", default = false },
  { key = "wh2_dlc09_sc_tmb_tomb_kings", text = "tombking", tt = "", default = false },
  { key = "wh3_main_sc_kho_khorne", text = "khorne", tt = "", default = false },
  { key = "wh3_main_sc_sla_slaanesh", text = "slaanesh", tt = "", default = false },
  { key = "wh3_main_sc_tze_tzeentch", text = "tzeentch", tt = "", default = false },
  { key = "wh3_main_sc_nur_nurgle", text = "nurgle", tt = "", default = false },
  }

local default_enemy = old_world_caravans:add_new_option("default_enemy", "dropdown")
default_enemy:set_text("Default Enemy")
default_enemy:add_dropdown_values(unit_caps_size_options)
default_enemy:set_default_value("100")

local default_difficult = old_world_caravans:add_new_option("default_difficult", "slider")
default_difficult:set_text("Default Difficult")
default_difficult:slider_set_min_max(1, 3)
default_difficult:set_default_value(1)
default_difficult:slider_set_step_size(1)

local override_encounters = old_world_caravans:add_new_option("override_encounters", "checkbox")
override_encounters:set_text("Override Encounters")
