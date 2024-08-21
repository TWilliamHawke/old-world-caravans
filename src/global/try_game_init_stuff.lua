function Old_world_caravans:try_game_init_stuff()
  if self.core_data_was_added then return end

  self:add_caravan_units_to_vanilla();
  self:set_starting_endpoints_values();
  self:fill_core_caravans_data();
  --self:disband_mar_convoys();
  self:apply_cargo_value_effect(self.cargo_value)

  local human_factions = cm:get_human_factions();

  for i = 1, #human_factions do
    local faction_name = human_factions[i]
    local faction = cm:get_faction(faction_name)

    if faction then
      self:hide_caravan_button_without_access(faction);
    end
  end

  --wrapper for reward_item_check
  self.reward_item_check = caravans.reward_item_check;

  ---@diagnostic disable-next-line: duplicate-set-field
  caravans.reward_item_check = function(_, faction, region_key, caravan_master)
    local culture = faction:culture()
    local reward_list = caravans.reward_list[culture]
    if not reward_list or not reward_list[region_key] then return end
    self.reward_item_check(caravans, faction, region_key, caravan_master)
  end

  self.core_data_was_added = true;
end
