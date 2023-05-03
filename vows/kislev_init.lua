cm:add_first_tick_callback_new(function()
  cm:set_saved_value(Old_world_caravans.is_init_save_key .. "ksl", true);
end)

cm:add_post_first_tick_callback(
  function()
    Old_world_caravans:unlock_caravans_for_suculture("wh3_main_sc_ksl_kislev", "ksl")
  end)
