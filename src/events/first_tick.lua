function Old_world_caravans:add_first_tick_callbacks()
  cm:add_first_tick_callback_new(
    function()
      cm:set_saved_value(self.is_init_save_key, true);
      cm:set_saved_value(self.is_init_save_key .. "brt", true);

      if vfs.exists("script/campaign/mod/twill_old_world_caravans_teb.lua") then
        self:log("southern realms init")
        cm:set_saved_value(self.is_init_save_key .. "teb", true);
      end
    end
  );

  cm:add_first_tick_callback(function()
    local ok, err = pcall(function()
      self:fill_core_caravans_data();
      self:disband_mar_convoys();
      self:set_starting_endpoints_values();
    end);

    if not ok then
      self:logCore(tostring(err));
    end
  end)

  cm:add_post_first_tick_callback(
    function()
      self:add_caravan_units_to_vanilla(); --second time to make sure
      --always happens

      self:hide_caravan_button_without_access();
      self:set_starting_endpoints_values();

      self:apply_cargo_value_effect(self.cargo_value)

      if cm:is_new_game() then
        --new game only
        local human_factions = cm:get_human_factions();
        for i = 1, #human_factions do
          local faction = human_factions[i]
          self:recruit_start_caravan(faction);
        end
        return
      end

      --if load existing save:

      if not cm:get_saved_value(self.is_init_save_key) then
        self:unlock_caravans_for_suculture("wh_main_sc_emp_empire", "emp")
        self:unlock_caravans_for_suculture("wh_main_sc_dwf_dwarfs", "dwf")

        cm:set_saved_value(self.is_init_save_key, true);
      end

      self:unlock_caravans_for_suculture("wh_main_sc_brt_bretonnia", "brt")

      if vfs.exists("script/campaign/mod/twill_old_world_caravans_teb.lua") then
        self:unlock_caravans_for_suculture("mixer_teb_southern_realms", "teb")
      end
    end
  );
end
