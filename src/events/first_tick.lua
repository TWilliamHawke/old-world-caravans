function Old_world_caravans:add_first_tick_callbacks()
  cm:add_first_tick_callback_new(
    function()
      local faction_list = cm:model():world():faction_list();
      for i = 0, faction_list:num_items() - 1 do
        local faction = faction_list:item_at(i)
        self:recruit_start_caravan(faction);
      end
      cm:set_saved_value(self.is_init_save_key, true);

      if vfs.exists("text/twill_old_world_caravans_brt.loc") then
        self:log("bretonnia init")
        cm:set_saved_value(self.is_init_save_key .. "brt", true);
      end

      if vfs.exists("script/campaign/mod/twill_old_world_caravans_teb.lua") then
        self:log("southern realms init")
        cm:set_saved_value(self.is_init_save_key .. "teb", true);
      end
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

      if not cm:get_saved_value(self.is_init_save_key) then
        self:unlock_caravans_for_suculture("wh_main_sc_emp_empire", "emp")
        self:unlock_caravans_for_suculture("wh_main_sc_dwf_dwarfs", "dwf")

        cm:set_saved_value(self.is_init_save_key, true);
      end

      if vfs.exists("text/twill_old_world_caravans_brt.loc") then
        self:unlock_caravans_for_suculture("wh_main_sc_brt_bretonnia", "brt")
      end

      if vfs.exists("script/campaign/mod/twill_old_world_caravans_teb.lua") then
        self:unlock_caravans_for_suculture("mixer_teb_southern_realms", "teb")
      end
    end
  );
end
