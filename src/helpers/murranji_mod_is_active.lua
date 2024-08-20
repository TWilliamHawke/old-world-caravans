function Old_world_caravans:murranji_mod_is_active()
  return not not caravans.calculate_unit_probability;
end