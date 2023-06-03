function Old_world_caravans:disband_mar_convoys()
  local mar_vampires = cm:get_faction("ovn_mar_the_wasteland");
  if not mar_vampires or mar_vampires:is_null_interface() then return end

  if mar_vampires:is_human() then return end

  local force_list = mar_vampires:military_force_list();

  for i = 0, force_list:num_items() - 1 do
    local force = force_list:item_at(i);
    if force:force_type():key() == "MAR_CARAVAN" then
      ---@diagnostic disable-next-line: param-type-mismatch
      cm:kill_character(force:general_character():command_queue_index(), true);
    end
  end
end
