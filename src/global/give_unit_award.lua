---comment
---@param caravan CARAVAN_SCRIPT_INTERFACE
---@param region_name string
function Old_world_caravans:give_unit_award(caravan, region_name)
  local region_sc = self.award_culture_replacer[region_name]
      or self.trade_nodes_to_culture[region_name];
  if not region_sc then return end

  local caravan_faction = caravan:caravan_force():faction();
  local caravan_sc = caravan_faction:subculture();

  if not self.awards[caravan_sc] then return end
  if not caravan_faction:is_human() then return end
  if self:faction_is_modded(caravan_faction) then return end

  local caravan_force = caravan:caravan_force()
  local units_count = caravan_force:unit_list():num_items();
  if units_count > 19 then return end
  local caravan_master = caravan_force:general_character();

  local type = self:is_late_game() and "late" or "early";

  local units = self.unit_awards[region_sc]
      and self.unit_awards[region_sc][type];

  if not units then return end

  local unit_key = self:select_random_key_by_weight(units, function(val)
    return val
  end)

  if not unit_key then return end

  local incident_name = "emp_caravan_completed_units";
  local cqi = caravan_faction:command_queue_index();

  local payload_builder = cm:create_payload();
  self:log("award unit is "..tostring(unit_key))

  local count = self:caravan_master_has_special_trait(caravan_master, region_sc) and 2 or 1
  payload_builder:add_unit(caravan_force, unit_key, count, 0)
  local char_cqi = caravan_force:general_character():command_queue_index()

  ---@diagnostic disable-next-line: undefined-field
  cm:trigger_custom_incident_with_targets(
    cqi,
    incident_name,
    true,
    payload_builder,
    0,
    0,
    char_cqi,
    0,
    0,
    0
  )
end
