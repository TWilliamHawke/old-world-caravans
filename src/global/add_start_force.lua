---@param caravan CARAVAN_SCRIPT_INTERFACE
function Old_world_caravans:add_start_force(caravan)
  local caravan_master = caravan:caravan_force():general_character();
  local faction = caravan_master:faction();
  local subculture = faction:subculture();
  local elite_guards_data = self.db.elite_guards[subculture];

  if not elite_guards_data then return end

  local lord_cqi = caravan_master:command_queue_index();
  local lord_str = cm:char_lookup_str(lord_cqi);

  if faction:has_technology(elite_guards_data.technology) then
    cm:grant_unit_to_character(lord_str, elite_guards_data.unit);
    cm:grant_unit_to_character(lord_str, elite_guards_data.unit);
  end

  if self.peasant_economy then
    Calculate_Economy_Penalty(faction)
  end
end
