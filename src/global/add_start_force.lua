---comment
---@param caravan CARAVAN_SCRIPT_INTERFACE
function Old_world_caravans:add_start_force(caravan)
  local force_list = {};
  local caravan_master = caravan:caravan_force():general_character();
  local faction = caravan_master:faction();

  for skill, units in pairs(self.start_units) do
    if caravan_master:has_skill(skill) then
      force_list = units;
      break
    end
  end

  local lord_cqi = caravan_master:command_queue_index();
  local lord_str = cm:char_lookup_str(lord_cqi);

  for i in ipairs(force_list) do
    cm:grant_unit_to_character(lord_str, force_list[i]);
  end

  if faction:has_technology("wh_main_tech_dwf_civ_3_2") then
    cm:grant_unit_to_character(lord_str, "wh_main_dwf_inf_longbeards");
    cm:grant_unit_to_character(lord_str, "wh_main_dwf_inf_longbeards");
  elseif faction:has_technology("owc_emp_defended_caravans") then
    cm:grant_unit_to_character(lord_str, "wh_main_emp_inf_greatswords");
    cm:grant_unit_to_character(lord_str, "wh_main_emp_inf_greatswords");
  end
end
