function Old_world_caravans:try_game_init_stuff()
  if self.core_data_was_added then return end

  self:add_caravan_units_to_vanilla();
  self:fill_core_caravans_data();
  --self:disband_mar_convoys();
  self:set_starting_endpoints_values();
  self:hide_caravan_button_without_access();
  self:apply_cargo_value_effect(self.cargo_value)

  self.core_data_was_added = true;

end