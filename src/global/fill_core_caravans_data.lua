function Old_world_caravans:fill_core_caravans_data()
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
end