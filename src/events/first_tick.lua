function Old_world_caravans:add_first_tick_callbacks()
  cm:add_first_tick_callback_new(
    function()
      self:recruit_start_caravan();
      cm:set_saved_value(self.is_init_save_key, true);
    end
  );

  cm:add_post_first_tick_callback(
    function()
      core:remove_listener("caravan_waylay_query")
      core:remove_listener("caravan_waylaid")
      core:remove_listener("add_inital_force")
      core:remove_listener("add_inital_bundles")
      core:remove_listener("caravan_finished")
      core:remove_listener("caravan_master_heal")

      Old_world_caravans:hide_caravan_button_for_belegar();

      if cm:is_new_game() then return end

      self:set_starting_endpoints_values();

      if cm:get_saved_value(self.is_init_save_key) then return end

      local human_factions = cm:get_human_factions();

      for i = 1, #human_factions do
        self:unlock_caravan_recruitment(human_factions[i]);
      end

      cm:set_saved_value(self.is_init_save_key, true);
    end
  );
end
