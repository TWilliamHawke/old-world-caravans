function Old_world_caravans:is_late_game()
  return cm:turn_number() > 60;
end