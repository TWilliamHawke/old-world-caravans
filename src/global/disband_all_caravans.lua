---@diagnostic disable: param-type-mismatch
---@param faction FACTION_SCRIPT_INTERFACE
function Old_world_caravans:disband_all_caravans(faction)
  local force_list = faction:military_force_list();

  for i = 0, force_list:num_items() - 1 do
    local force = force_list:item_at(i);
    if force:force_type():key() == "EMP_CARAVAN" then
      cm:kill_character(force:general_character():command_queue_index(), true);
      if not faction:is_human() then
        cm:treasury_mod(faction:name(), 800);
      end
    end
  end
end