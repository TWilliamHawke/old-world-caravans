---comment
---@param caravan CARAVAN_SCRIPT_INTERFACE
function Old_world_caravans:add_start_force(caravan)
  local force_list = self.start_units.wh_main_brt_bretonnia.brt_caravan_skill_innate_empire;
  local caravan_master = caravan:caravan_force():general_character();
  local faction = caravan_master:faction();
  local culture = faction:culture();
  local units_list = self.start_units[culture] or {}

  for skill, units in pairs(units_list) do
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
  elseif faction:has_technology("wh2_dlc13_tech_emp_economy_3") then
    cm:grant_unit_to_character(lord_str, "wh_main_emp_inf_greatswords");
    cm:grant_unit_to_character(lord_str, "wh_main_emp_inf_greatswords");
  elseif faction:has_technology("wh_dlc07_tech_brt_economy_other_draft") then
    cm:grant_unit_to_character(lord_str, "owc_dlc07_brt_inf_foot_squires_0");
    cm:grant_unit_to_character(lord_str, "owc_dlc07_brt_inf_foot_squires_0");
  elseif faction:has_technology("teb_tech_exped_vets") then
    cm:grant_unit_to_character(lord_str, "teb_republican_guard");
    cm:grant_unit_to_character(lord_str, "teb_republican_guard");
  end
  self:logCore("before check")

  if self.peasant_economy then
    Calculate_Economy_Penalty(faction)
  end

end
