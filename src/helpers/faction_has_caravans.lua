function Old_world_caravans:faction_has_caravans(faction)
  local caravans_list = cm:model():world():caravans_system():faction_caravans(faction);
  return not caravans_list:is_null_interface();
end