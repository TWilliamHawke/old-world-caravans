if not get_mct then return end
local mct = get_mct();

if not mct then return end

local old_world_caravans = mct:get_mod_by_key("old_world_caravans") or mct:register_mod("old_world_caravans")
old_world_caravans:set_title("Caravans of the Old World")
-- old_world_caravans:set_description(loc_prefix.."mod_desc", true)
old_world_caravans:set_log_file_path("Old_world_caravans_log.txt")
old_world_caravans:set_author("TWilliam")

if old_world_caravans.set_workshop_id then
  old_world_caravans:set_main_image("ui/mct/twill_old_world_caravans.png", 300, 300)
  old_world_caravans:set_workshop_id("2943940309")
end

local enemy_forces_options = {
  { key = "wh_main_sc_emp_empire",          text = "empire",          tt = "", default = false },
  { key = "wh_main_sc_brt_bretonnia",       text = "bretonnia",       tt = "", default = false },
  { key = "wh3_main_sc_ksl_kislev",         text = "kislev",          tt = "", default = false },
  { key = "wh_main_sc_dwf_dwarfs",          text = "dwarfs",          tt = "", default = false },
  { key = "wh3_main_sc_ogr_ogre_kingdoms",  text = "ogre_kingdoms",   tt = "", default = true },
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
  { key = "wh3_main_sc_cth_cathay",         text = "cathay",          tt = "", default = false },
  { key = "wh3_dlc23_sc_chd_chaos_dwarfs",  text = "chaos dwarfs",    tt = "", default = false },
  { key = "wh_main_sc_chs_chaos",           text = "chaos warriors",  tt = "", default = false },
}

local encounters = {
  { key = "nothing",          text = "nothing",          tt = "", default = true },
  { key = "ambush",           text = "ambush",           tt = "", default = false },
  { key = "cargo_replenish",  text = "cargo_replenish",  tt = "", default = false },
  { key = "enemy_attack",     text = "enemy_attack",     tt = "", default = false },
  { key = "local_trouble",    text = "local_trouble",    tt = "", default = false },
  { key = "new_agent",        text = "new_agent",        tt = "", default = false },
  { key = "new_units",        text = "new_units",        tt = "", default = false },
  { key = "shortcut",         text = "shortcut",         tt = "", default = false },
  { key = "giftFromInd",      text = "giftFromInd",      tt = "", default = false },
  { key = "enemy_caravan",    text = "enemy_caravan",    tt = "", default = false },
  { key = "friendly_caravan", text = "friendly_caravan", tt = "", default = false },
  { key = "ogres_my_lord",    text = "ogres_my_lord",    tt = "", default = false },
  { key = "magic_item",       text = "magic_item",       tt = "", default = false },
  { key = "wild_river",       text = "wild_river",       tt = "", default = false },
  { key = "training_camp",    text = "training_camp",    tt = "", default = false },
  { key = "daemons_attack",   text = "daemons_attack",   tt = "", default = false },
  { key = "offenceorDefence", text = "offenceorDefence", tt = "", default = false },
  { key = "slayers",          text = "slayers",          tt = "", default = false },
  { key = "undead_attack",    text = "undead_attack",    tt = "", default = false },

}

local combat_encounter_options = {
  { key = "0.5", text = "0.5x",  tt = "", is_default = false },
  { key = "1",   text = "1x",   tt = "", is_default = true },
  { key = "1.5", text = "1.5x", tt = "", is_default = false },
  { key = "2",   text = "2x",   tt = "", is_default = false },
}

local on_click_options = {
  { key = "none",     text = "owc_mct_on_settlement_click_none_text",     tt = "",                                     is_default = true },
  { key = "move",     text = "owc_mct_on_settlement_click_move_text",     tt = "owc_mct_on_settlement_click_move_tt",  is_default = false },
  { key = "award",    text = "owc_mct_on_settlement_click_award_text",    tt = "owc_mct_on_settlement_click_award_tt", is_default = false },
  { key = "banditry", text = "owc_mct_on_settlement_click_banditry_text", tt = "",                                     is_default = false },
  { key = "position", text = "owc_mct_on_settlement_click_position_text", tt = "",                                     is_default = false },
}

local award_options = {
  { key = "all",    text = "owc_mct_allow_item_awards_all_text",    tt = "owc_mct_allow_item_awards_all_tt",    is_default = true },
  { key = "cathay", text = "owc_mct_allow_item_awards_cathay_text", tt = "owc_mct_allow_item_awards_cathay_tt", is_default = false },
  { key = "none",   text = "owc_mct_allow_item_awards_none_text",   tt = "owc_mct_allow_item_awards_none_tt",   is_default = false },
}

local player_caravans_options = {
  { key = "default",    text = "owc_mct_player_caravans_default_text",    tt = "owc_mct_player_caravans_default_tt",    is_default = true },
  { key = "enable_all", text = "owc_mct_player_caravans_enable_all_text", tt = "owc_mct_player_caravans_enable_all_tt", is_default = false },
  { key = "disable",   text = "owc_mct_player_caravans_disable_text",   tt = "owc_mct_player_caravans_disable_tt",   is_default = false },
}


local first_section = old_world_caravans:get_last_section();
first_section:set_localised_text("owc_mct_section_difficulty");

local encounter_budget_1 = old_world_caravans:add_new_option("encounter_budget_1", "slider");
---@cast encounter_budget_1 MCT.Option.Slider
encounter_budget_1:set_text("owc_mct_encounter_budget_1");
encounter_budget_1:set_tooltip_text("owc_mct_encounter_budget_tooltip");
encounter_budget_1:slider_set_min_max(2000, 5000)
encounter_budget_1:set_default_value(3500)
encounter_budget_1:slider_set_step_size(500, 0)

local encounter_budget_2 = old_world_caravans:add_new_option("encounter_budget_2", "slider");
---@cast encounter_budget_2 MCT.Option.Slider
encounter_budget_2:set_text("owc_mct_encounter_budget_2")
encounter_budget_2:set_tooltip_text("owc_mct_encounter_budget_tooltip");
encounter_budget_2:slider_set_min_max(3000, 7500)
encounter_budget_2:set_default_value(5000)
encounter_budget_2:slider_set_step_size(500, 0)

local encounter_budget_3 = old_world_caravans:add_new_option("encounter_budget_3", "slider");
---@cast encounter_budget_3 MCT.Option.Slider
encounter_budget_3:set_text("owc_mct_encounter_budget_3")
encounter_budget_3:set_tooltip_text("owc_mct_encounter_budget_tooltip");
encounter_budget_3:slider_set_min_max(5000, 10000)
encounter_budget_3:set_default_value(7000)
encounter_budget_3:slider_set_step_size(500, 0)

-- local scale_difficulty_cargo = old_world_caravans:add_new_option("scale_difficulty_cargo", "checkbox")
-- scale_difficulty_cargo:set_text("owc_mct_scale_difficulty_cargo", true)
-- scale_difficulty_cargo:set_tooltip_text("owc_mct_scale_difficulty_cargo_tooltip", true);

-- local scale_difficulty_strenght = old_world_caravans:add_new_option("scale_difficulty_strenght", "checkbox")
-- scale_difficulty_strenght:set_text("owc_mct_scale_difficulty_strenght", true)
-- scale_difficulty_strenght:set_tooltip_text("owc_mct_scale_difficulty_strenght_tooltip", true);

local combat_probability = old_world_caravans:add_new_option("combat_probability", "dropdown")
---@cast combat_probability MCT.Option.Dropdown
combat_probability:set_text("owc_mct_combat_probability")
combat_probability:add_dropdown_values(combat_encounter_options)


local no_encounter_weight = old_world_caravans:add_new_option("no_encounter_weight", "slider")
---@cast no_encounter_weight MCT.Option.Slider
no_encounter_weight:set_text("owc_mct_no_encounter_weight")
no_encounter_weight:set_tooltip_text("owc_mct_no_encounter_weight_tooltip")
no_encounter_weight:slider_set_min_max(0, 50)
no_encounter_weight:set_default_value(50)
no_encounter_weight:slider_set_step_size(10, 0)


local accessibility_section = old_world_caravans:add_new_section("m_accessibility")
accessibility_section:set_localised_text("owc_mct_section_accessibility")

local force_enable = old_world_caravans:add_new_option("force_enable", "checkbox")
---@cast force_enable MCT.Option.Checkbox
force_enable:set_text("owc_mct_force_enable")
force_enable:set_tooltip_text("owc_mct_force_enable_tooltip")force_enable:set_uic_visibility(false, false)

local player_caravans = old_world_caravans:add_new_option("player_caravans", "dropdown")
---@cast player_caravans MCT.Option.Dropdown
player_caravans:add_dropdown_values(player_caravans_options)
player_caravans:set_text("owc_mct_player_caravans")

player_caravans:add_option_set_callback(function()
  force_enable:revert_to_default();
end, false)

local ai_empire_caravans = old_world_caravans:add_new_option("ai_empire_caravans", "checkbox")
---@cast ai_empire_caravans MCT.Option.Checkbox
ai_empire_caravans:set_text("owc_mct_ai_empire_caravans")
ai_empire_caravans:set_default_value(true)

local ai_dwarf_caravans = old_world_caravans:add_new_option("ai_dwarf_caravans", "checkbox")
---@cast ai_dwarf_caravans MCT.Option.Checkbox
ai_dwarf_caravans:set_text("owc_mct_ai_dwarf_caravans")
ai_dwarf_caravans:set_default_value(true)

local ai_bretonnia_caravans = old_world_caravans:add_new_option("ai_bretonnia_caravans", "checkbox")
---@cast ai_bretonnia_caravans MCT.Option.Checkbox
ai_bretonnia_caravans:set_text("owc_mct_ai_bretonnia_caravans")

local ai_teb_caravans = old_world_caravans:add_new_option("ai_teb_caravans", "checkbox")
---@cast ai_teb_caravans MCT.Option.Checkbox
ai_teb_caravans:set_text("owc_mct_ai_teb_caravans")

if not vfs.exists("script/campaign/mod/twill_old_world_caravans_teb.lua") then
  ai_teb_caravans:set_uic_visibility(false, false)
end

local ai_ksl_caravans = old_world_caravans:add_new_option("ai_ksl_caravans", "checkbox")
---@cast ai_ksl_caravans MCT.Option.Checkbox
ai_ksl_caravans:set_text("owc_mct_ai_ksl_caravans")

if not vfs.exists("script/campaign/mod/twill_old_world_caravans_ksl.lua") then
  ai_ksl_caravans:set_uic_visibility(false, false)
end

local faction_section = old_world_caravans:add_new_section("n_factions")
faction_section:set_localised_text("owc_mct_section_miscellaneous")

local peasant_economy = old_world_caravans:add_new_option("peasant_economy", "checkbox")
---@cast peasant_economy MCT.Option.Checkbox
peasant_economy:set_text("owc_mct_peasant_economy")
peasant_economy:set_tooltip_text("owc_mct_peasant_economy_tooltip")

local replace_units = old_world_caravans:add_new_option("replace_units", "checkbox")
---@cast replace_units MCT.Option.Checkbox
replace_units:set_text("owc_mct_avoid_unit_caps")
replace_units:set_tooltip_text("owc_mct_avoid_unit_caps_tt")

local random_enemies = old_world_caravans:add_new_option("random_enemies", "checkbox")
---@cast random_enemies MCT.Option.Checkbox
random_enemies:set_text("owc_mct_random_enemies")
random_enemies:set_tooltip_text("owc_mct_random_enemies_tooltip")

local cargo_value = old_world_caravans:add_new_option("cargo_value", "slider");
---@cast cargo_value MCT.Option.Slider
cargo_value:set_text("owc_mct_avoid_cargo_value")
cargo_value:slider_set_min_max(0, 200)
cargo_value:set_default_value(100)
cargo_value:slider_set_step_size(10, 0)
cargo_value:set_tooltip_text("owc_mct_avoid_cargo_value_tt")

local allow_item_awards = old_world_caravans:add_new_option("allow_item_awards", "dropdown")
---@cast allow_item_awards MCT.Option.Dropdown
allow_item_awards:set_text("owc_mct_allow_item_awards")
allow_item_awards:add_dropdown_values(award_options)


local debug_section = old_world_caravans:add_new_section("o_debug")
debug_section:set_localised_text("owc_mct_section_debug")

local override_encounters = old_world_caravans:add_new_option("override_encounters", "checkbox")
---@cast override_encounters MCT.Option.Checkbox
override_encounters:set_text("owc_mct_override_encounters")
override_encounters:set_tooltip_text("owc_mct_override_encounters_tooltip")

local default_encounter = old_world_caravans:add_new_option("default_encounter", "dropdown")
---@cast default_encounter MCT.Option.Dropdown
default_encounter:set_text("owc_mct_default_encounter")
default_encounter:add_dropdown_values(encounters)

local enable_log = old_world_caravans:add_new_option("enable_log", "checkbox")
---@cast enable_log MCT.Option.Checkbox
enable_log:set_text("owc_mct_enable_log")
enable_log:set_tooltip_text("owc_mct_enable_log_tooltip")

local on_settlement_click = old_world_caravans:add_new_option("on_settlement_click", "dropdown")
---@cast on_settlement_click MCT.Option.Dropdown
on_settlement_click:set_text("owc_mct_on_settlement_click")
on_settlement_click:add_dropdown_values(on_click_options)



local override_enemy = old_world_caravans:add_new_option("override_enemy", "checkbox")
---@cast override_enemy MCT.Option.Checkbox
override_enemy:set_text("owc_mct_override_enemy")
override_enemy:set_tooltip_text("owc_mct_override_enemy_tooltip")

local default_enemy = old_world_caravans:add_new_option("default_enemy", "dropdown")
---@cast default_enemy MCT.Option.Dropdown
default_enemy:set_text("owc_mct_default_enemy")
default_enemy:add_dropdown_values(enemy_forces_options)

local default_difficult = old_world_caravans:add_new_option("default_difficult", "slider")
---@cast default_difficult MCT.Option.Slider
default_difficult:set_text("owc_mct_default_difficult")
default_difficult:slider_set_min_max(1, 3)
default_difficult:set_default_value(1)
default_difficult:slider_set_step_size(1, 0)


if encounter_budget_1.set_is_global then
  encounter_budget_1:set_is_global(true);
  encounter_budget_2:set_is_global(true);
  encounter_budget_3:set_is_global(true);
  no_encounter_weight:set_is_global(true);
  force_enable:set_is_global(true);
  ai_empire_caravans:set_is_global(true);
  ai_bretonnia_caravans:set_is_global(true);
  ai_dwarf_caravans:set_is_global(true);
  ai_teb_caravans:set_is_global(true);
  peasant_economy:set_is_global(true);
  random_enemies:set_is_global(true);
  combat_probability:set_is_global(true);
  ai_ksl_caravans:set_is_global(true);
  cargo_value:set_is_global(true);
  replace_units:set_is_global(true);
  allow_item_awards:set_is_global(true);
  player_caravans:set_is_global(true);
else
  debug_section:set_visibility(false)
end
