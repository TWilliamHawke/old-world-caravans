function Old_world_caravans:fill_core_caravans_data()
  --uses cathay node values when caravan completed
  caravans.culture_to_faction.wh_main_emp_empire = "cathay";
  caravans.culture_to_faction.wh_main_dwf_dwarfs = "cathay";
  caravans.culture_to_faction.wh_main_brt_bretonnia = "cathay";
  caravans.culture_to_faction.mixer_teb_southern_realms = "cathay";
  caravans.culture_to_faction.wh3_main_ksl_kislev = "cathay";

  --prevent crashes in caravans:reward_item_check
  caravans.item_data.wh_main_emp_empire = {};
  caravans.item_data.wh_main_dwf_dwarfs = {};
  caravans.item_data.wh_main_brt_bretonnia = {};
  caravans.item_data.mixer_teb_southern_realms = {};
  caravans.item_data.wh3_main_ksl_kislev = {};

  --increase some cathay caravans
  table.insert(caravans.traits_to_units.wh3_main_skill_innate_cth_caravan_master_gunner, "wh3_main_cth_inf_crane_gunners_0")
  local army = caravans.traits_to_units["wh3_main_skill_innate_cth_caravan_master_Former-Artillery-Officer"]
  table.insert(army, "wh3_main_cth_inf_jade_warriors_1")

  --update trade nodes values on turn start
  for i = 1, #self.new_caravan_targets do
    table.insert(caravans.destinations_key.main_warhammer.cathay, self.new_caravan_targets[i])
  end

  --copy cathay caravan units
  for trait, units in pairs(caravans.traits_to_units) do
    ---@diagnostic disable-next-line: undefined-field
    if trait:sub(1, 25) == "wh3_main_skill_innate_cth" then
      self.cathay_caravans[trait] = {};

      for i = 1, #units do
        table.insert(self.cathay_caravans[trait], units[i])
      end
    end
  end

  --remove kislev caravans from friendly_caravan encounter
  if not vfs.exists("script/campaign/mod/twill_old_world_caravans_ksl.lua") then
    self.node_culture_to_event_weight.wh3_main_sc_ksl_kislev = {};
  end

  -- caravans.event_tables.wh_main_emp_empire = {};
  -- caravans.event_tables.wh_main_dwf_dwarfs = {};
  -- caravans.event_tables.wh_main_brt_bretonnia = {};
  -- caravans.event_tables.mixer_teb_southern_realms = {};

  -- if cm:get_campaign_name() ~= "wh3_main_chaos" then
  --   caravans.event_tables.wh3_main_cth_cathay = {};
  -- end
end
