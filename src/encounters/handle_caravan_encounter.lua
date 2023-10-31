---@param context CaravanWaylaid
function Old_world_caravans:handle_caravan_encounter(context)
  local encounter_string = tostring(context:context()); --"owc_encounter_name"
  local encounter_name = string.sub(encounter_string, 5);

  local has_handler, handler = self:handler_is_exists(encounter_name);

  if has_handler then
    self[handler](self, context);
  else
    self:logCore(handler .. " is not a function")
  end
end
