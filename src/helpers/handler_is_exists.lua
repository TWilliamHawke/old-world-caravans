function Old_world_caravans:handler_is_exists(encounter)
  local is_exists = false;
  local encounter_handler = encounter .. "_handler";

  if type(self[encounter_handler]) == "function" then
    is_exists = true;
  end

  return is_exists, encounter_handler;
end