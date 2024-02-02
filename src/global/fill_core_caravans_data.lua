function Old_world_caravans:fill_core_caravans_data()

  for _, culture in ipairs(self.new_caravan_cultures) do
    --set cathay node values when caravan completed
    caravans.culture_to_faction[culture] = "cathay";
    caravans.item_data[culture] = {};
    self:create_empty_event(culture)
  end

  if self.supported_campaigns[cm:get_campaign_name()] then
    self:create_empty_event("wh3_main_cth_cathay")
  end

  --increase some cathay caravans
  table.insert(caravans.traits_to_units.wh3_main_skill_innate_cth_caravan_master_gunner,
    "wh3_main_cth_inf_crane_gunners_0")
  local army = caravans.traits_to_units["wh3_main_skill_innate_cth_caravan_master_Former-Artillery-Officer"]
  table.insert(army, "wh3_main_cth_inf_jade_warriors_1")

  --update trade nodes values on turn start
  for i = 1, #self.new_caravan_targets.main_warhammer do
    table.insert(caravans.destinations_key.main_warhammer.cathay, self.new_caravan_targets.main_warhammer[i])
  end

  if caravans.destinations_key.cr_oldworld then
    for i = 1, #self.new_caravan_targets.cr_oldworld do
      table.insert(caravans.destinations_key.cr_oldworld.cathay, self.new_caravan_targets.cr_oldworld[i])
    end
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

end
