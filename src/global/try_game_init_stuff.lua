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

  self.core_data_was_added = true;
end