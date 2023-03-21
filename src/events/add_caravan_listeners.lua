function Old_world_caravans:add_caravan_listeners()
  core:add_listener(
    "owc_add_inital_force",
    "CaravanRecruited",
    ---@param context CaravanRecruited
    ---@return boolean
    function(context)
      local faction = context:faction()
      return not self:faction_is_modded(faction);
    end,
    ---@param context CaravanRecruited
    function(context)
      local caravan = context:caravan();
      local subculture = context:caravan():caravan_force():faction():subculture()
      ---@diagnostic disable-next-line: undefined-field
      cm:set_character_excluded_from_trespassing(context:caravan():caravan_master():character(), true);

      if subculture ~= "wh3_main_sc_cth_cathay" then
        self:add_start_force(caravan);
      else
        add_inital_force(caravan);
      end
    end,
    true
  );
  core:add_listener(
    "owc_caravan_spawned",
    "CaravanSpawned",
    ---@param context CaravanSpawned
    function(context)
      local faction = context:faction()
      return not self:faction_is_modded(faction);
    end,
    ---@param context CaravanSpawned
    function(context)
      if context:faction():subculture() ~= "wh3_main_sc_cth_cathay" then
        local caravan_force = context:caravan():caravan_force();
        self:remove_caravan_upkeep(caravan_force);
      end

      local caravan = context:caravan();
      cm:set_saved_value("caravans_dispatched_" .. context:faction():name(), true);
      local caravan_master_lookup = cm:char_lookup_str(caravan:caravan_force():general_character():command_queue_index())
      cm:force_character_force_into_stance(caravan_master_lookup, "MILITARY_FORCE_ACTIVE_STANCE_TYPE_FIXED_CAMP");
    end,
    true
  );

  
  core:add_listener(
    "owc_caravan_waylay_query_no_cathay",
    "QueryShouldWaylayCaravan",
    function(context)
      return context:faction():is_human() and not self:faction_is_modded(context:faction());
    end,
    ---comment
    ---@param context QueryShouldWaylayCaravan
    function(context)
      if cm:get_campaign_name() ~= "wh3_main_chaos" then
        self:generate_caravan_encounter(context)
      else
        ivory_road_event_handler(context)
      end
      self:log("My handler for QueryShouldWaylayCaravan")
    end,
    true
  );

  core:add_listener(
    "owc_caravan_waylaid_no_cathay",
    "CaravanWaylaid",
    function(context)
      return not self:faction_is_modded(context:faction())
    end,
    function(context)
      if cm:get_campaign_name() ~= "wh3_main_chaos" then
        self:handle_caravan_encounter(context);
      else
        waylaid_caravan_handler(context);
      end
      self:log("My handler for CaravanWaylaid")
    end,
    true
  );

  core:add_listener(
    "owc_SettlementSelected_caravan_test",
    "SettlementSelected",
    function()
      return self.debug_mode
    end,
    ---@param context SettlementSelected
    function(context)
      local settlement = context:garrison_residence():region():name();
      local banditry_level = cm:model():world():caravans_system():banditry_for_region_by_key(settlement);

      self:log("banditry_level for " .. settlement .. " is " .. banditry_level);
    end,
    true
  )

  core:add_listener(
    "owc_CaravanCompleted",
    "CaravanCompleted",
    ---@param context CaravanCompleted
    function(context)
      return not self:faction_is_modded(context:faction());
    end,
    ---@param context CaravanCompleted
    function(context)
      self:complete_caravans(context)
      local faction = context:faction()

      if not faction:is_human() then return end
      local node = context:complete_position():node()
      local region_name = node:region_key()
      self:give_caravan_award(faction, region_name);
    end,
    true
  )

  core:add_listener(
    "owc_caravan_moved",
    "CaravanMoved",
    function(context)
      return not context:caravan():is_null_interface() and not self:faction_is_modded(context:faction());
    end,
    function(context)
      self:teleport_caravan(context)
    end,
    true
  );

  core:add_listener(
    "OWC_add_ai_effect",
    "FactionTurnStart",
    ---@param context FactionTurnStart
    ---@return boolean
    function(context)
      local subculture = context:faction():subculture();
      return self.culture_to_trait[subculture] ~= nil;
    end,
    ---@param context FactionTurnStart
    function(context)
      local faction = context:faction();
      if faction:is_human() then return end
      local effect_key = "wh3_main_caravan_AI_threat_reduction";

      if not faction:has_effect_bundle(effect_key) then
        cm:apply_effect_bundle(effect_key, faction:name(), 0)
      end
    end,
    true
  );
end
