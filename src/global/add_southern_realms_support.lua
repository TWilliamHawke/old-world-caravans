function Old_world_caravans:add_southern_realms_support()
  if vfs.exists("script/frontend/mod/cataph_teb.lua") then
    self:log("add_southern_realms_support")

    self.culture_to_agent_subtype.wh_main_sc_teb_teb = "teb_duellist_hero";
    self.trade_nodes_to_culture.wh3_main_combi_region_monument_of_the_moon = "wh_main_sc_teb_teb"

    self.culture_to_units.wh_main_sc_teb_teb = {
      weakA = {
        ["teb_half_pikes"] = { 2, 2, 3 },
        ["teb_billmen"] = { 2, 2, 3 },
        ["teb_pikemen"] = { 1, 2, 3 },
        ["teb_conqui_lancers"] = { 2, 2, 2 },
        ["teb_carabiniers"] = { 2, 2, 2 },
        ["teb_conqui_adventurers"] = { 2, 2, 3 },
      },
      weakB = {
        ["teb_xbowmen"] = { 2, 2, 3 },
        ["teb_handgunners"] = { 2, 2, 3 },
        ["teb_border_rangers"] = { 2, 2, 2 },
        ["teb_pavisiers"] = { 1, 2, 2 },
      },
      strongA = {
        ["teb_pikemen"] = { 2, 2, 3 },
        ["teb_duellists"] = { 2, 2, 3 },
        ["teb_republican_guard"] = { 2, 1, 2 },
        ["teb_light_cannon"] = { 1, 1, 2 },
        ["teb_galloper"] = { 1, 1, 2 },
      },
      strongB = {
        ["teb_militia_knights"] = { 3, 2, 2 },
        ["teb_broken_lances"] = { 2, 2, 2 },
        ["teb_paymaster"] = { 3, 2, 2 },
        ["teb_kotrs"] = { 2, 1, 1 },
      },
    }
  else
    self:log("replace teb with empire");

    self.enemy_forces.wh_main_sc_teb_teb_1 = self.enemy_forces.wh_main_sc_emp_empire_1;
    self.enemy_forces.wh_main_sc_teb_teb_2 = self.enemy_forces.wh_main_sc_emp_empire_2;
    self.enemy_forces.wh_main_sc_teb_teb_3 = self.enemy_forces.wh_main_sc_emp_empire_3;
    self.unit_awards.wh_main_sc_teb_teb = self.unit_awards.wh3_main_sc_ogr_ogre_kingdoms;
    self.node_culture_to_event_weight.mixer_teb_southern_realms = {};
  end
end
