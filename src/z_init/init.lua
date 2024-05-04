function Old_world_caravans:init()
  self:create_new_log();
  self:add_first_tick_callbacks();
  self:add_mct_listeners();
  self:add_caravan_listeners();
  self:add_specific_faction_listeners();
  self:add_cleanup_listeners();
  self:add_southern_realms_support();
  self:check_gelt_cathay_caravans();
end

Old_world_caravans:init();

function twill_old_world_caravans()
  Old_world_caravans:try_game_init_stuff();
end
