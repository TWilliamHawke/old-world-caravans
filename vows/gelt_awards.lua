function twill_old_world_caravans_gelt()
  if Old_world_caravans and Old_world_caravans.item_award_culture_replacer then
    Old_world_caravans.item_award_culture_replacer.wh2_dlc13_emp_golden_order = "owc_teb_cathay";
    Old_world_caravans:logCore("caravan awards for Gelt was replaced")
  end
end