---@param context CaravanWaylaid
function Old_world_caravans:handle_caravan_encounter(context)
  local encounter_name = tostring(context:context());

  local handler = string.sub(encounter_name, 5) .. "_handler"
  if type(self[handler]) == "function" then
    self[handler](self, context);
  else
    self:logCore(handler .. " is not a function")
  end
end
