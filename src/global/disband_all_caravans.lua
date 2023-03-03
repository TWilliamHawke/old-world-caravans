---@param faction FACTION_SCRIPT_INTERFACE
function Old_world_caravans:disband_all_caravans(faction)
  local force_list = faction:military_force_list();

  for i = 0, force_list:num_items() - 1 do
    local force = force_list:item_at(i);
    if force:force_type():key() == "EMP_CARAVAN" then
      cm:kill_character(force:general_character():command_queue_index(), true);
    end
  end
end