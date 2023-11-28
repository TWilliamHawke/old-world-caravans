function caravans:waylaid_caravan_handler(context)

  local event_name_formatted = context:context();
	local caravan_handle = context:caravan();
	local event_key = self:read_out_event_key(event_name_formatted);
	local culture = caravan_handle:caravan_force():faction():culture();

	local events = self.event_tables[culture];

  if not events then return end
  if not events[event_key] then return end
  if not events[event_key][2] then return end

	events[event_key][2](event_name_formatted,caravan_handle);

end
