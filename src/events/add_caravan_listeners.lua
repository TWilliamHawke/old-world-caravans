function Old_world_caravans:add_caravan_listeners()
  core:remove_listener("owc_add_inital_force")
  core:remove_listener("owc_caravan_spawned")
  core:remove_listener("owc_caravan_waylay_query_no_cathay")
  core:remove_listener("owc_caravan_waylaid_no_cathay")
  core:remove_listener("owc_SettlementSelected_caravan_test")
  core:remove_listener("owc_CaravanCompleted")
  core:remove_listener("owc_caravan_moved")
  core:remove_listener("owc_kill_ai_caravans")
  core:remove_listener("owc_kill_karak_hirn_caravans")
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
      local chosen_caravan = cm:get_saved_value("chosen_caravan_master_" .. faction:name());
      local current_caravan =  context:caravan():caravan_force():command_queue_index();
      local current_caravan_is_chosen = not chosen_caravan or chosen_caravan == current_caravan;
      return faction:is_human() and self:faction_is_supported(faction) and current_caravan_is_chosen
    end,
    ---comment
    ---@param context QueryShouldWaylayCaravan
    function(context)
      local faction_key = context:faction():name()
      if self.events_fired[faction_key] then return end
      self:log("My handler for QueryShouldWaylayCaravan")

      local has_handler, selected_encounter = self:generate_caravan_encounter(context)
      self:log("selected_encounter is " .. tostring(selected_encounter))

      if has_handler then
        ---@diagnostic disable-next-line: redundant-parameter
        context:flag_for_waylay("owc?" .. selected_encounter)
        self.events_fired[faction_key] = true;
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
      return self.debug_mode and not cm:is_multiplayer();
    end,
    ---@param context SettlementSelected
    function(context)
      local settlement_name = context:garrison_residence():region():name();
      local faction = cm:get_local_faction(true);

      if self.on_settlement_click == "banditry" then
        local banditry_level = cm:model():world():caravans_system():banditry_for_region_by_key(settlement_name);
        self:log("banditry_level for " .. settlement_name .. " is " .. banditry_level);
      elseif self.on_settlement_click == "position" then
        local log_x = context:garrison_residence():region():settlement():logical_position_x();
        local log_y = context:garrison_residence():region():settlement():logical_position_y();
        self:log("owc-" .. settlement_name .. "\t" .. tostring(log_x) .. "\t" .. tostring(log_y));
      elseif self.on_settlement_click == "award" then
        self:give_caravan_award(faction, settlement_name);

        if Convoys_of_new_world then
          Convoys_of_new_world:get_item_award_test(faction, settlement_name)
        end
      elseif self.on_settlement_click == "move" then
        local caravans_list = cm:model():world():caravans_system():faction_caravans(faction);
        if not caravans_list or caravans_list:is_null_interface() then return end
        local caravan = caravans_list:active_caravans():item_at(0)
        if not caravan or caravan:is_null_interface() then return end
        ---@diagnostic disable-next-line: undefined-field
        cm:move_caravan(caravan)
      elseif self.on_settlement_click == "confederation" then
        local player = faction:name();
        local target = context:garrison_residence():faction():name();
        if player ~= target then
          cm:force_confederation(faction:name(), context:garrison_residence():faction():name());
        end
      end
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
    "owc_CaravanCompleted_cathay_modded",
    "CaravanCompleted",
    ---@param context CaravanCompleted
    function(context)
      local faction = context:faction();
      local faction_sc = faction:subculture();
      return faction:is_human() and self:murranji_mod_is_active() and faction_sc == "wh3_main_sc_cth_cathay";
    end,
    ---@param context CaravanCompleted
    function(context)
      local faction = context:faction()

      ---@diagnostic disable-next-line: undefined-field
      local node = context:complete_position():node();
      local region_name = node:region_key()
      self:give_caravan_award(faction, region_name);
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

  core:add_listener(
    "owc_kill_karak_hirn_caravans",
    "FactionTurnEnd",
    ---@param context FactionTurnEnd
    ---@return boolean
    function(context)
      local faction = context:faction();
      local faction_name = faction:name();
      return not faction:is_human()
        and self.belegar_confederation_skip[faction_name];
    end,
    ---@param context FactionTurnEnd
    function(context)
      local belegar = cm:get_faction(self.belegar_faction);

      if belegar and belegar:is_human() then
        self:disband_all_caravans(context:faction());
      end
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
