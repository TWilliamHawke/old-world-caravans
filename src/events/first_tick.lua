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
    caravans.rhox_mar_caravan_replace_listener = function()
      self:logCore("Marienburg \"Replace listeners\" function was replaced")
    end
  end)

  cm:add_post_first_tick_callback(
    function()
      --always happens
      core:remove_listener("caravan_waylay_query")
      core:remove_listener("caravan_waylaid")
      core:remove_listener("add_inital_force")
      core:remove_listener("add_inital_bundles")
      core:remove_listener("caravan_master_heal")

      --uses cathay node values when caravan completed
      caravans.culture_to_faction.wh_main_emp_empire = "cathay";
      caravans.culture_to_faction.wh_main_dwf_dwarfs = "cathay";
      caravans.culture_to_faction.wh_main_brt_bretonnia = "cathay";
      caravans.culture_to_faction.mixer_teb_southern_realms = "cathay";

      --prevent crashes in caravans:reward_item_check
      caravans.item_data.wh_main_emp_empire = {};
      caravans.item_data.wh_main_dwf_dwarfs = {};
      caravans.item_data.wh_main_brt_bretonnia = {};
      caravans.item_data.mixer_teb_southern_realms = {};

      --update trade nodes values on turn start
      for _, region in ipairs(self.new_caravan_targets) do
        table.insert(caravans.destinations_key.main_warhammer.cathay, region)
      end

      -- caravans.event_tables.wh_main_emp_empire = {};
      -- caravans.event_tables.wh_main_dwf_dwarfs = {};
      -- caravans.event_tables.wh_main_brt_bretonnia = {};
      -- caravans.event_tables.mixer_teb_southern_realms = {};

      -- if cm:get_campaign_name() ~= "wh3_main_chaos" then
      --   caravans.event_tables.wh3_main_cth_cathay = {};
      -- end

      self:hide_caravan_button_for_belegar();
      self:set_starting_endpoints_values();

      if cm:is_new_game() then
        --new gane only
        local faction_list = cm:model():world():faction_list();
        for i = 0, faction_list:num_items() - 1 do
          local faction = faction_list:item_at(i)
          self:recruit_start_caravan(faction);
        end
        return
      end

      --not new game game only

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
