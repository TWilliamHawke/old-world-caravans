function Old_world_caravans:add_caravan_listeners()
  core:remove_listener("owc_add_inital_force")
  core:remove_listener("owc_caravan_spawned")
  core:remove_listener("owc_caravan_waylay_query_no_cathay")
  core:remove_listener("owc_caravan_waylaid_no_cathay")
  core:remove_listener("owc_SettlementSelected_caravan_test")
  core:remove_listener("owc_CaravanCompleted")
  core:remove_listener("owc_caravan_moved")
  core:remove_listener("owc_kill_ai_caravans")
  core:remove_listener("OWC_add_ai_effect")
  core:remove_listener("OWC_caravan_finished")

  core:add_listener(
    "owc_add_inital_force",
    "CaravanRecruited",
    ---@param context CaravanRecruited
    ---@return boolean
    function(context)
      local faction = context:faction()
      return self:faction_is_supported(faction);
    end,
    ---@param context CaravanRecruited
    function(context)
      local caravan = context:caravan();
      self:add_start_force(caravan);
    end,
    true
  );

  core:add_listener(
    "owc_caravan_spawned",
    "CaravanSpawned",
    ---@param context CaravanSpawned
    function(context)
      local faction = context:faction()
      return self:faction_is_supported(faction);
    end,
    ---@param context CaravanSpawned
    function(context)
      if context:caravan():caravan_force():force_type():key() == "EMP_CARAVAN" then
        local caravan_force = context:caravan():caravan_force();
        self:remove_caravan_upkeep(caravan_force);
      end
    end,
    true
  );


  core:add_listener(
    "owc_caravan_waylay_query_no_cathay",
    "QueryShouldWaylayCaravan",
    function(context)
      local faction = context:faction()
      return faction:is_human() and self:faction_is_supported(faction);
    end,
    ---comment
    ---@param context QueryShouldWaylayCaravan
    function(context)
      self:log("My handler for QueryShouldWaylayCaravan")

      local has_handler, selected_encounter = self:generate_caravan_encounter(context)
      self:log("selected_encounter is " .. tostring(selected_encounter))

      if has_handler then
        ---@diagnostic disable-next-line: redundant-parameter
        context:flag_for_waylay("owc?" .. selected_encounter)
      end
    end,
    true
  );

  core:add_listener(
    "owc_caravan_waylaid_no_cathay",
    "CaravanWaylaid",
    function(context)
      local faction = context:faction()
      return faction:is_human() and self:faction_is_supported(faction);
    end,
    ---@param context CaravanWaylaid
    function(context)
      local ok, err = pcall(function()
        self:handle_caravan_encounter(context);
      end);

      if not ok then
        self:logCore(tostring(err));
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
      -- local banditry_level = cm:model():world():caravans_system():banditry_for_region_by_key(settlement);
      local faction = cm:get_local_faction(true);

      local log_x = context:garrison_residence():region():settlement():logical_position_x();
      local log_y = context:garrison_residence():region():settlement():logical_position_y();
      self:log("owc-" .. settlement .. "\t" .. tostring(log_x) .. "\t" .. tostring(log_y));

      --self:give_caravan_award(faction, settlement)
      -- cm:move_caravan(cm:model():world():caravans_system():faction_caravans(faction):active_caravans()
      -- :item_at(0))

      -- local caravan = cm:model():world():caravans_system():faction_caravans(faction):active_caravans():item_at(0)
      -- cm:move_caravan(caravan)

      -- self:log("banditry_level for " .. settlement .. " is " .. banditry_level);
    end,
    true
  )

  core:add_listener(
    "owc_CaravanCompleted",
    "CaravanCompleted",
    ---@param context CaravanCompleted
    function(context)
      local faction = context:faction()
      return faction:is_human() and self:faction_is_supported(faction);
    end,
    ---@param context CaravanCompleted
    function(context)
      local faction = context:faction()

      ---@diagnostic disable-next-line: undefined-field
      local node = context:complete_position():node();
      local caravan = context:caravan();
      local region_name = node:region_key()
      self:give_caravan_award(faction, region_name);
      self:give_unit_award(caravan, region_name)
      ---@diagnostic disable-next-line: param-type-mismatch
      cm:remove_effect_bundle_from_force("owc_caravan_cargo_cap", caravan:caravan_force():command_queue_index())
    end,
    true
  )

  core:add_listener(
    "owc_caravan_moved",
    "CaravanMoved",
    function(context)
      local faction = context:faction();
      return self:faction_is_supported(faction);
    end,
    ---comment
    ---@param context CaravanMoved
    function(context)
      self:heal_caravan_master(context)
    end,
    true
  );

  core:add_listener(
    "owc_kill_ai_caravans",
    "FactionTurnEnd",
    ---@param context FactionTurnEnd
    ---@return boolean
    function(context)
      local faction = context:faction();
      local faction_sc = faction:subculture();
      local faction_name = faction:name();
      return not faction:is_human() and
          (self.ai_caravans[faction_sc] == false or self.minor_without_caravans[faction_name]);
    end,
    ---@param context FactionTurnEnd
    function(context)
      self:disband_all_caravans(context:faction());
    end,
    true
  );

  -- core:add_listener(
  --   "owc_kill_mar_caravans",
  --   "FactionTurnEnd",
  --   ---@param context FactionTurnEnd
  --   ---@return boolean
  --   function(context)
  --     local faction = context:faction();
  --     return faction:is_human() and self.debug_mode;
  --   end,
  --   function()
  --     self:disband_mar_convoys();
  --   end,
  --   true
  -- );

  core:add_listener(
    "OWC_add_ai_effect",
    "FactionTurnStart",
    ---@param context FactionTurnStart
    ---@return boolean
    function(context)
      local faction = context:faction();
      return self:faction_is_supported(faction);
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
