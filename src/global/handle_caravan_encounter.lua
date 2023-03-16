---@param context CaravanWaylaid
function Old_world_caravans:handle_caravan_encounter(context)
  local encounter_name = context:context();

  local handler = encounter_name .. "_handler"
  if type(self[handler]) == "function" then
    self[handler](self, context);
  else
    self:logCore(handler .. " is not a function")
  end
end
