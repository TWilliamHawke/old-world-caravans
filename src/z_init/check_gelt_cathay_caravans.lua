function Old_world_caravans:check_gelt_cathay_caravans()
  if vfs.exists("script/campaign/mod/twill_old_world_caravans_gelt.lua") then
    self.access_to_caravans_on_first_turn.wh2_dlc13_emp_golden_order = true;
  end
end