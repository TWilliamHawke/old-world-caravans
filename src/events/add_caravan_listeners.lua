function Old_world_caravans:add_caravan_listeners()
  core:add_listener(
    "owc_add_inital_force",
    "CaravanRecruited",
    ---@param context CaravanRecruited
    ---@return boolean
    function(context)
      return context:caravan():caravan_force():faction():subculture() ~= "wh3_main_sc_cth_cathay";
    end,
    ---@param context CaravanRecruited
    function(context)
      local caravan = context:caravan();
      self:add_start_force(caravan);
    end,
    true
  );
  core:add_listener(
    "owc_antiupkeep",
    "CaravanSpawned",
    ---@param context CaravanSpawned
    function(context)
      return context:faction():is_human();
    end,
    ---@param context CaravanSpawned
    function(context)
      local caravan_focre = context:caravan():caravan_force();
      self:remove_caravan_upkeep(caravan_focre);
    end,
    true
  );
  
  
  core:add_listener(
    "owc_caravan_waylay_query_no_cathay",
    "QueryShouldWaylayCaravan",
    function(context)
      return context:faction():is_human() and cm:get_campaign_name() ~= "wh3_main_chaos";
    end,
    ---comment
    ---@param context QueryShouldWaylayCaravan
    function(context)
      self:generate_caravan_encounter(context)
      self:log("My handler for QueryShouldWaylayCaravan")
    end,
    true
  );

  core:add_listener(
    "owc_caravan_waylaid_no_cathay",
    "CaravanWaylaid",
    function(context)
      return cm:get_campaign_name() ~= "wh3_main_chaos"
    end,
    function(context)
      self:handle_caravan_encounter(context)
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
      return context:faction():is_human();
    end,
    ---@param context CaravanCompleted
    function(context)
      local faction = context:faction()
      local node = context:complete_position():node()
      local region_name = node:region_key()
      self:give_caravan_award(faction, region_name);
    end,
    true
  )

  


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
