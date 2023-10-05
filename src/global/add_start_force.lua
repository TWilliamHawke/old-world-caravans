---@param caravan CARAVAN_SCRIPT_INTERFACE
function Old_world_caravans:add_start_force(caravan)
  local caravan_master = caravan:caravan_force():general_character();
  local faction = caravan_master:faction();
  local subculture = faction:subculture();
  local units_list = self.start_units[subculture];
  local elite_guards_data = self.db.elite_guards[subculture];

  if not units_list then return end

  ---@diagnostic disable-next-line: undefined-field
  local innate_skill = caravan_master:background_skill()
  local force_list = units_list[innate_skill] or
  self.start_units.wh_main_sc_brt_bretonnia.brt_caravan_skill_innate_empire;

  local lord_cqi = caravan_master:command_queue_index();
  local lord_str = cm:char_lookup_str(lord_cqi);

  for i = 1, #force_list do
    cm:grant_unit_to_character(lord_str, force_list[i]);
  end

  if elite_guards_data and faction:has_technology(elite_guards_data.technology) then
    cm:grant_unit_to_character(lord_str, elite_guards_data.unit);
    cm:grant_unit_to_character(lord_str, elite_guards_data.unit);
  end

  if self.peasant_economy then
    Calculate_Economy_Penalty(faction)
  end
end
